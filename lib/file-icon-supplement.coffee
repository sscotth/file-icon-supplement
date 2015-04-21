FileIconSupplementView = require './file-icon-supplement-view'

module.exports =

  config:
    treeViewIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'
    tabIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'
    fuzzyFinderIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'
    findAndReplaceIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'
    grammarStatusIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'
    grammarSelectorIcons:
      type: 'boolean'
      default: true
      title: 'Title'
      description: 'Description'

  fileIconSupplementView: null

  activate: (state) ->
    @fileIconSupplementView =
      new FileIconSupplementView state.fileIconSupplementViewState
    atom.packages.once "activated", =>
      @fileIconSupplementView.loadAllSettings()

  deactivate: ->
    @fileIconSupplementView.destroy()

  serialize: ->
    fileIconSupplementViewState: @fileIconSupplementView.serialize()
