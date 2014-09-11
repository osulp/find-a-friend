class PostsController < ApplicationController
  respond_to :html, :json
  before_filter :current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :check_sign_in, :only => [:new, :edit]
  before_filter :find_post, :only => [:edit, :update, :destroy, :show]
  before_filter :find_decorated_post, :only => [:show]

  def index
    @posts = PostDecorator.decorate_collection(Post.all)
  end

  def new
    @post = Post.new
    @locations = Location.all
  end
   
  def create
    @post = Post.new(post_params)
    check_conflict
    if @post.save
      flash[:success] = I18n.t("post.success.posting")
      if @post.meeting_time
        if @post.meeting_time.strftime(I18n.t("time.formats.date")) != Time.now.strftime(I18n.t("time.formats.date"))
          flash[:warning] = I18n.t("post.warnings.future")
        end
      end
      if @post.recipients.present?
        UserMailer.delay.new_post_email(@post)
      end
    else
      flash[:error] = I18n.t("post.errors.posting")
    end

    respond_with @post, :location => root_path
  end

  def show
  end

  def edit
    @locations = Location.all
  end

  def update
    check_conflict
    if @post.onid == current_user
      @post.update_attributes(post_params)
    end
    if @post.recipients.present?
      UserMailer.delay.update_post_email(@post)
    end
    respond_with @post, :location => root_path
  end

  def destroy
    if @post.destroy
      flash[:success] = I18n.t("post.success.deleting")
    else
      flash[:error] = I18n.t("post.errors.deleting")
    end
    respond_with @post
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :meeting_time, :end_time, :recipients, :onid, :allow_onid, :location)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def find_decorated_post
    @post = Post.find(params[:id]).decorate
  end
	
  def check_sign_in
    redirect_to signin_path if current_user.nil?
  end

  def check_conflict
    @user_posts = Post.where(:onid => @post.onid)
    flash[:error] = I18n.t('post.errors.overlap') if conflict(@user_posts, @post)
  end

  def conflict(user_posts, subject)
    user_posts.each do |post| 
      if(((post.meeting_time < subject.meeting_time) && (subject.meeting_time < post.end_time)) && ((post.meeting_time < subject.end_time) && (subject.end_time < post.meeting_time)))
        return true
      elsif((subject.meeting_time < post.meeting_time) && (post.meeting_time < subject.end_time))
        return true
      elsif((subject.meeting_time < post.end_time) && (post.end_time < subject.end_time))
        return true
      end
    end
  end
end
