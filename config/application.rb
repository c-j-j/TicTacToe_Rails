require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module TictactoeRails
  class Application < Rails::Application
    config.active_support.bare  = true
  end
end
