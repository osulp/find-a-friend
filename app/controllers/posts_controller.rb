class PostsController < ApplicationController
  respond_to :html, :json
  before_filter :check_sign_in, :only => [:new, :edit]
  before_filter :find_post, :only => [:edit, :update, :destroy, :show]
  before_filter :find_decorated_post, :only => [:show]
  rescue_from Pundit::NotAuthorizedError, :with => :not_authorized

  def index
    @abouts = About.all
    @posts = PostFacade.new(current_user)
    @locations = Location.all
  end

  def new
    @post = Post.new
    @locations = Location.all
  end

  def create
    @post = Post.new(post_params.merge(:onid => current_user))
    ConflictChecker.call(user_posts, @post, CreateResponder.new(self))
  end

  class CreateResponder < SimpleDelegator
    def conflicts(post)
      flash[:error] = I18n.t('post.errors.overlap')
      respond_with post, :location => new_post_path(post)
    end

    def no_conflict(post)
      post_saved(post) if post.save
      respond_with post, :location => root_path
    end

    def post_saved(post)
      flash[:success] = I18n.t("post.success.posting")
      flash[:warning] = I18n.t("post.warnings.future") if meeting_time_in_future?(post.meeting_time)
      UserMailer.delay.new_post_email(post) if post.recipients.present?
    end

    private

    def meeting_time_in_future?(meeting_time)
      meeting_time ||= Time.at(0)
      meeting_time.strftime(I18n.t("time.formats.date")) != Time.now.strftime(I18n.t("time.formats.date"))
    end
  end

  def show
  end

  def edit
    authorize @post
    @locations = Location.all
  end

  def update
    authorize @post
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
    authorize @post
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

  def user_posts
    Post.where(:onid => current_user)
  end

  def post_params
    params.require(:post).permit(:title, :description, :meeting_time, :end_time, :recipients, :allow_onid, :location)
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
    return true unless ConflictChecker.new(user_posts, @post).conflicts?
    flash[:error] = I18n.t('post.errors.overlap')
    false
  end

  def not_authorized
    flash[:error] = I18n.t('post.errors.permissions')
    redirect_to root_path
  end
end
