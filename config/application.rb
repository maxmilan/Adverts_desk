require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module AdvertsDesk
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine :slim
    end
  end
end
