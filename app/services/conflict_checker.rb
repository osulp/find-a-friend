class ConflictChecker
  def self.call(user_posts, post, callback)
    new(user_posts, post, callback).run!
  end
  attr_reader :user_posts, :post, :callbacks

  def initialize(user_posts, post, callbacks=[])
    @user_posts = user_posts
    @post = post
    @callbacks = Array.wrap(callbacks)
  end

  def run!
    if conflicts?
      notify_conflicts
    else
      notify_no_conflict
    end
  end

  def conflicts?
    user_posts.each do |post_1| 
      next if post == post_1
      return true if TimeConflictChecker.new(post_1.time_range, post.time_range).conflicts?
    end
    return false
  end

  private

  def notify_conflicts
    callbacks.each do |callback|
      callback.conflicts(post)
    end
  end

  def notify_no_conflict
    callbacks.each do |callback|
      callback.no_conflict(post)
    end
  end
end
