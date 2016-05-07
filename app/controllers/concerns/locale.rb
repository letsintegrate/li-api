module Concerns
  module Locale
    attr_reader :locale

    def set_locale
      @locale = request.env['HTTP_X_LOCALE']
      I18n.locale = @locale
    end

    def self.included(receiver)
      receiver.before_action :set_locale
    end
  end
end
