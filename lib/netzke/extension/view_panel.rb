require 'netzke-core'
require 'netzke/basepack/attr_config'
require 'netzke/basepack/columns'
require 'netzke/basepack/data_accessor'
require 'netzke/basepack/grid'

module Netzke::Extension
  class ViewPanel < Netzke::Basepack::Grid

    self.column_filters_available = false
    self.advanced_search_available = false
    self.edit_inline_available = false
    self.remember_selection_available = false

    js_configure do |c|
      grid_js_path = Netzke::Extension.grid_js_path
      c.extend = "Ext.panel.Panel"
      c.properties[:mixins] = ['Netzke.classes.Core.Mixin']
      c.mixin grid_js_path + 'edit_in_form.js' if edit_in_form_available
      c.mixin grid_js_path + 'event_handling.js'
    end

    def js_configure c
      super
    end

    #def bbar
    #  [:add_in_form, :edit_in_form]
    #end

    def configure(c)

      c.layout = :fit

      c.load_inline_data ||= true
      c.enable_edit_in_form ||= true
      c.enable_edit_inline = false
      c.enable_extended_search = false
      c.enable_column_filters = false
      c.enable_pagination ||= true

      super

    end


  end
end