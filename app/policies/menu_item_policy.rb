class MenuItemPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.present?
  end

  def permitted_attributes
    user.nil? ? super : %i(name page_id)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
