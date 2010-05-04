if ActionController
  require 'grafff_helper'
  require 'grafff_controller'
  require 'facebook_user'

  ActionController::Base.send(:include, Grafff::Controller)
  ActionController::Base.send(:helper_method, 'facebook_credentials')
  ActionView::Base.send(:include, Grafff::Helper)
end
