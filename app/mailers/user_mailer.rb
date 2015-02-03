class UserMailer < ActionMailer::Base
  default from: "Find a Friend <system@findfriend.library.oregonstate.edu>"
  
	def new_post_email(post)
    @post = post
    if post.allow_onid
      mail(to: post.recipients, subject: post.title, reply_to: "#{post.onid}@onid.oregonstate.edu")
    else
      mail(to: post.recipients, subject: post.title)
    end
	end
end
