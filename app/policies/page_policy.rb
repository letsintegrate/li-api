class PagePolicy < ApplicationPolicy
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
    user.nil? ? super : %i(slug)
  end

  def whitelisted_attributes
    user.nil? ? super : %i(title_translations content_translations)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
