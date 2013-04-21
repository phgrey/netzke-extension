Ext.define 'Ext.ux.SelectionColumn', {
  extend: 'Ext.ux.CheckColumn'
  alias: 'widget.selectioncol'
  constructor:(opts)->
    opts.afterRender = ->
      selModel = this.up('gridpanel').view.selModel
      selModel.allowSelection = false
      selModel.on 'beforeselect', (sm, record, index, opts)-> sm.allowSelection
      selModel.on 'beforedeselect', (sm, record, index, opts)-> sm.allowSelection
      selModel.setSelectionMode('MULTI')
      selModel.allowedSelect = (fn)->
        this.allowSelection = true
        try
          fn.apply this
        finally
          this.allowSelection = false
    @callParent [opts]
  processEvent: (type, view, cell, recordIndex, cellIndex, e, record, row)->
    key = type == 'keydown' && e.getKey()
    mousedown = type == 'mousedown'
    e.stopEvent() if mousedown
    if mousedown || (key == e.ENTER || key == e.SPACE)
      view.selModel.allowedSelect ->
        if this.selected.items.indexOf(record) == -1
          this.select record, true
        else this.deselect record
        view.refreshNode recordIndex
      false
    else @callParent arguments
  renderer: (value, metaData, record, rowIndex, colIndex, store, view)->
    @callParent [view.selModel.selected.items.indexOf(record) != -1]
}