class PostCollectionDecorator < Draper::CollectionDecorator
  attr_accessor :user_posts

  def initialize(object, user_posts=false)
    @user_posts ||= user_posts
    super(object)
  end

  def id
    if user_posts?
      "my-posts-table"
    else
      "all-posts-table"
    end
  end

  def user_posts?
    !!@user_posts
  end

end
