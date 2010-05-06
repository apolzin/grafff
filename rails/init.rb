require 'grafff'

# TODO different init procedures for rails 2 and 3

require 'grafff/rails/controller'
require 'grafff/rails/helper'

ActionController::Base.send :include, Grafff::Rails::Controller
ActionView::Base.send :include, Grafff::Rails::Helper
