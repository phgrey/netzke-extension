require "netzke/extension/version"


if defined? ActiveRecord
  require 'netzke/basepack/data_adapters/active_record_adapter'
  require 'netzke/extension/active_record'
  Netzke::Basepack::DataAdapters::ActiveRecordAdapter.send :include, ::Netzke::Extension::ActiveRecord


end

module Netzke
  module Extension

  end
end