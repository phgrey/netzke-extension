require "netzke-extension/version"



module Netzke
  module Extension
    if defined? ::Rails
      class Engine < Rails::Engine; end
    end
  end
end

=begin
#!TODO: in fact we did not overwtite the base. fixit
  require 'netzke/core/view_ext'

  ActiveSupport.on_load(:action_view) do
    include Netzke::Core::ViewExt
  end
=end



