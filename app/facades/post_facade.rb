class PostFacade
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def today_posts
    PostCollectionDecorator.new(Post.today)
  end
  
  def user_future_posts
    PostCollectionDecorator.new(future_posts, true, false)
  end

  def part_of_posts
    PostCollectionDecorator.new(user_part_of_posts, false, true)
  end

  private

  def user_part_of_posts
    if user.present?
      Post.future.where("recipients LIKE '%#{user}%'")
    else
      []
    end
  end

  def future_posts
    Post.where(:onid => user).future
  end

end
