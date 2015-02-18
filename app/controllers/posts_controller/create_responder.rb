class PostsController
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
end
