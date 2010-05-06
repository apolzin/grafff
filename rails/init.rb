require 'grafff'

Grafff::Record.decode('text/javascript') do |data|
  ActiveSupport::JSON.decode(data).
      inject({}) { |mem, (k, v)| mem.update k.to_sym => v }
end

# TODO different init procedures for rails 2 and 3

require 'grafff/rails/controller'
require 'grafff/rails/helper'

ActionController::Base.send :include, Grafff::Rails::Controller
ActionView::Base.send :include, Grafff::Rails::Helper
