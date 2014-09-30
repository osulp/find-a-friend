class PostCollectionDecorator < Draper::CollectionDecorator
  attr_accessor :user_posts

  def initialize(object, edit_posts=false, user_posts=false)
    @edit_posts ||= edit_posts
    @user_posts ||= user_posts
    super(object)
  end

  def id
    if edit_posts?
      "my-posts-table"
    else
      "all-posts-table"
    end
  end

  def user_posts?
    !!@user_posts
  end

  def edit_posts?
    !!@edit_posts
  end

end
