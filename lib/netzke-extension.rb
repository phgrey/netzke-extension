require "netzke-extension/version"

require 'active_support/dependencies'

# Make components auto-loadable
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

module Netzke
  module Extension
    #Make assets auto-loadable
    class Engine < Rails::Engine; end  if defined? ::Rails

    def self.version_string
      "Version is #{Netzke::Extension::VERSION}"
    end
  end
end
