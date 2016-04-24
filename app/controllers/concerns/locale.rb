module Concerns
  module Locale
    attr_reader :locale

    def set_locale
      @locale = request.env['X_LOCALE']
    end

    def self.included(receiver)
      receiver.before_action :set_local
    end
  end
end
