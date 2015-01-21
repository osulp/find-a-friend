class PostPolicy < ApplicationPolicy
  def update?
    user == record.onid
  end
  def destroy?
    user == record.onid
  end
end
