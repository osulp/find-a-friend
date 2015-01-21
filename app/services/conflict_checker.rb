class ConflictChecker
  def self.call(user_posts, post, callback)
    new(user_posts, post, callback).run!
  end
  attr_reader :user_posts, :post, :callbacks

  def initialize(user_posts, post, callbacks=[])
    @user_posts = user_posts
    @post = post
    @callbacks = SubscriptionList.new(*Array.wrap(callbacks))
  end

  def run!
    if conflicts?
      callbacks.conflicts(post)
    else
      callbacks.no_conflict(post)
    end
  end

  def conflicts?
    user_posts.each do |post_1| 
      next if post == post_1
      return true if TimeConflictChecker.new(post_1.time_range, post.time_range).conflicts?
    end
    return false
  end

end
