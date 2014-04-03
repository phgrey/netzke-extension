require 'netzke-core'
require 'netzke/basepack/attr_config'
require 'netzke/basepack/columns'
require 'netzke/basepack/data_accessor'
require 'netzke/basepack/grid'

class Netzke::Extension::TreeGridPanel < Netzke::Basepack::Grid

  self.column_filters_available = false
  self.advanced_search_available = false
  self.edit_in_form_available = false
  self.edit_inline_available = false

  js_configure do |c|
    grid_js_path = Netzke::Extension.grid_js_path
    c.extend = "Ext.tree.Panel"
    c.mixin grid_js_path + 'grid.js'
    c.mixin  grid_js_path + 'event_handling.js'
    #this works strange - need to look closer

    c.properties[:mixins] = ['Netzke.classes.Core.Mixin']
  end

  def js_configure c
    c.root_visible ||= false
    super
    c.pri = config.pri if config.pri != data_class.primary_key
  end


  def configure(c)
    c.pri = (c.pri || data_class.primary_key)#.to_s.camelize(:lower)
    c.columns = [c.column.merge(:flex => 1,:xtype => 'treecolumn')] if c.columns.nil?
    #we'll remove this columns on client before configuring the tree. they'll be sent to model only
    c.columns += [
        {:name=> 'leaf', :type => 'boolean', :getter => ->(r){ leaf? r }, :extra => true },
        {:name => 'expanded', :type => 'boolean', :getter => ->(r){ expanded? r }, :extra => true}
    ]
    c.columns << {:name => c.pri, :type => 'string', :getter => ->(r){ send(c.pri.to_s, r) }, :extra => true} if c.pri != data_class.primary_key

    c.load_inline_data = false
    c.enable_edit_in_form ||= false
    c.enable_edit_inline ||= false
    c.enable_extended_search ||= false
    c.enable_column_filters = false
    c.enable_pagination = false

    super

  end

  def leaf? r
    false
  end

  def expanded? r
    false
  end


end