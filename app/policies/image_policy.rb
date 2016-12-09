class ImagePolicy < ApplicationPolicy
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
    user.nil? ? super : %i()
  end

  def whitelisted_attributes
    user.nil? ? super : %i(file)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
