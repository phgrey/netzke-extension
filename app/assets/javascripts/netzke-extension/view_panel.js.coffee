# Here we'll create mixin to override some functions
# defined in Basepack.GridPanel

Ext.define 'Netzke.mixins.Netzke.Extension.ViewPanel', {
  override: 'Netzke.classes.Netzke.Extension.ViewPanel',
  initComponent: (options)->
    Ext.define(@id, {
      extend: 'Ext.data.Model',
      idProperty: @pri, # Primary key
      fields: @columns.map((col)->name:col.name, type:col.attrType)
    })
    delete @pri
    delete @fields
    @items = [Ext.apply({
      xtype:'dataview'
      store:@buildStore()
#      listeners:{
#        itemclick: ->
#          console.log arguments
#      }
    }, this.dataView)]

    # Toolbar
    @dockedItems ||= [];
    if @enablePagination
      @dockedItems.push({
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        store: @store,
        items: @bbar && ["-"].concat(this.bbar) # append the passed bbar
      });
    else if @bbar
      this.dockedItems.push({
        xtype: 'toolbar',
        dock: 'bottom',
        items: @bbar
      });
    delete @bbar

    @callParent arguments
    @view = @down('dataview')
    @getSelectionModel().on 'selectionchange', (selModel)=>
      @actions.del.setDisabled(!selModel.hasSelection() || @prohibitDelete) if (@actions.del)
      @actions.edit.setDisabled(selModel.getCount() != 1 || @prohibitUpdate) if (@actions.edit)



  getSelectionModel: ->
    @view.getSelectionModel()
  buildStore: ->
    @store = Ext.create('Ext.data.Store', Ext.apply({
        model: @id,
        proxy: @buildProxy(),
        pruneModifiedRecords: true,
        remoteSort: true,
        pageSize: @rowsPerPage,
        autoLoad: !@loadInlineData,
      }, this.dataStore))
    @store.loadRawData @inlineData if @inlineData
    @store.remoteFilter = true
    @store
  buildProxy: ->
    # DirectProxy that uses our Ext.direct provider
    Ext.create('Ext.data.proxy.Direct', {
      directFn: Netzke.providers[this.id].getData,
      reader: this.buildReader(),
      listeners: {
#        exception: this.loadExceptionHandler,
        load: (proxy, response, operation)->
          # besides getting data into the store, we may also get commands to execute
          response = response.result;
          if (response)  # or did we have an exception?
            Ext.each(['data', 'total', 'success'], (property)->delete response[property])
            this.netzkeBulkExecute(response)
      }
    })
  buildReader: ->
   Ext.create 'Ext.data.reader.Array', {root: 'data', totalProperty: 'total'}
}