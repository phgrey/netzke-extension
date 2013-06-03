require 'active_support/dependencies'
# Make components auto-loadable
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

require 'netzke/extension'

module Netzke
  module Extension
    #Make assets auto-loadable
    class Engine < Rails::Engine; end  if defined? ::Rails

  end
end
