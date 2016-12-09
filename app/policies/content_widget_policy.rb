class ContentWidgetPolicy < WidgetPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
