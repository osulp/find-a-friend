class PostsController < ApplicationController
  respond_to :html, :json
  before_filter :current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :check_sign_in, :only => [:new, :edit]
  before_filter :find_post, :only => [:edit, :update, :destroy, :show]
  before_filter :find_decorated_post, :only => [:show]

  def index
    @abouts = About.all
    @posts = PostCollectionDecorator.new(Post.today)
    @user_posts = Post.future.where(:onid => current_user) if current_user
    @user_posts ||= []
    @user_posts = PostCollectionDecorator.new(@user_posts, true)
    @part_of_posts = Post.future.where("recipients LIKE '%#{current_user}%'") if current_user
    @part_of_posts ||= []
    @part_of_posts = PostCollectionDecorator.new(@part_of_posts, false)
    @locations = Location.all
  end

  def new
    @post = Post.new
    @locations = Location.all
  end
   
  def create
    @post = Post.new(post_params)
    if check_conflict
      if @post.save
        flash[:success] = I18n.t("post.success.posting")
        if @post.meeting_time
          if @post.meeting_time.strftime(I18n.t("time.formats.date")) != Time.now.strftime(I18n.t("time.formats.date"))
            flash[:warning] = I18n.t("post.warnings.future")
          end
        end
      else
        flash[:error] = I18n.t("post.errors.posting")
      end
      if @post.recipients.present?
        UserMailer.delay.new_post_email(@post)
      end
      respond_with @post, :location => root_path
    else
      respond_with @post, :location => new_post_path(@post)
    end
  end

  def show
  end

  def edit
    @locations = Location.all
  end

  def update
    @post.attributes = post_params
    if check_conflict
      if @post.onid == current_user
        @post.save
      end
      if @post.recipients.present?
        UserMailer.delay.update_post_email(@post)
      end
      respond_with @post, :location => root_path
    else
      respond_with @post, :location => edit_post_path(@post)
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = I18n.t("post.success.deleting")
    else
      flash[:error] = I18n.t("post.errors.deleting")
    end
    respond_with @post
  end

  def query
    @posts = Post.where("location = ? AND end_time >= ? AND meeting_time <= ?", params[:location], Time.parse(params[:start]), Time.parse(params[:end]))
    respond_with @posts
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
    redirect_to signin_path(:source => request.original_url) if current_user.nil?
  end

  def check_conflict
    @user_posts = Post.where(:onid => current_user)
    if @user_posts.length > 0 && !@user_posts.nil?
      if conflict(@user_posts, @post)
        flash[:error] = I18n.t('post.errors.overlap')
        return false
      else
        return true
      end
    else
      return true
    end
  end

  def conflict(user_posts, post2)
    user_posts.each do |post1| 
      unless post1.id == post2.id
        return true if post2.meeting_time <= post1.end_time && post1.meeting_time <= post2.end_time
      end
    end
    return false
  end
end
