# Here we'll create mixin to override some functions
# defined in Basepack.GridPanel

Ext.define 'Netzke.mixins.Netzke.Extension.TreeGridPanel', {
  override: 'Netzke.classes.Netzke.Extension.TreeGridPanel',
# This function has to be overwritten bc of store type changing
  buildStore: ->
     Ext.create('Ext.data.TreeStore', Ext.apply({
        model: @id,
        proxy: @buildProxy(),
        autoLoad: !@loadInlineData,
        root: @inlineData || {title:'root', id:null, leaf:false, expanded: true }
      }, this.dataStore))
# This function is overwritten bc we do want do not to show some columns to processColumns
# another solution is to use extraFields
  processColumns: ->
    fields = []
    columnsToreturn = []
    for col in @columns.slice(0)
      if col.extra
        @columnsOrder = Ext.Array.filter @columnsOrder, (x)-> x.name != col.name
        @fields = [{name: col.name, type: col.type}]
      else
        columnsToreturn.push col
        @columns = [col]
        @callParent arguments
      fields = Ext.Array.merge fields, @fields
    @fields = fields
    @columns = columnsToreturn
}