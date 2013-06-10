require "netzke/extension/version"


if defined? ActiveRecord
  require 'netzke/basepack/data_adapters/active_record_adapter'
  require 'netzke/extension/active_record_adapter'
  #require 'netzke/extension/active_record'
  #Netzke::Basepack::DataAdapters::ActiveRecordAdapter.send :include, ::Netzke::Extension::ActiveRecord
  Netzke::Basepack::DataAdapters::AbstractAdapter.instance_eval do
    def adapter_class(model_class)
      Netzke::Extension::ActiveRecordAdapter
    end
  end


end

module Netzke
  module Extension
    def self.grid_js_path
      Gem::Specification.find_by_name("netzke-basepack").gem_dir + '/lib/netzke/basepack/grid/javascripts/'
    end
  end
end