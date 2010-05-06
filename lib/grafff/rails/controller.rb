module Grafff::Rails
  module Controller

    def self.included(controller)
      controller.helper_method :grafff
    end

    def grafff # behaves like a Ruby on Rails session
      unless defined? @__grafff
        app_id = I18n.translate 'grafff.app_id', :default => I18n.
            translate('grafff.app_id', :locale => I18n.default_locale)
        secret = I18n.translate 'grafff.secret', :default => I18n.
            translate('grafff.secret', :locale => I18n.default_locale)
        cookie = request.cookies["fbs_#{ app_id }"]

        @__grafff = Grafff::Factory.new cookie, secret
      end

      @__grafff
    end

  end
end
