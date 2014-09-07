{View} = require 'atom'

module.exports =
class FileIconSupplementView extends View

  @content: ->
    @div class: 'fis'

  initialize: (serializeState) ->
    atom.workspaceView.command 'file-icon-supplement:addTabClass',
      => @addTabClass()
    atom.workspaceView.command 'file-icon-supplement:removeTabClass',
      => @removeTabClass()
    atom.workspaceView.command 'file-icon-supplement:toggleTabClass',
      => @toggleClass 'tabIcons'
    atom.workspaceView.command 'file-icon-supplement:addTreeViewClass',
      => @addTreeViewClass()
    atom.workspaceView.command 'file-icon-supplement:removeTreeViewClass',
      => @removeTreeViewClass()
    atom.workspaceView.command 'file-icon-supplement:toggleTreeViewClass',
      => @toggleClass 'treeViewIcons'
    atom.workspaceView.command 'file-icon-supplement:addFuzzyFinderClass',
      => @addFuzzyFinderClass()
    atom.workspaceView.command 'file-icon-supplement:removeFuzzyFinderClass',
      => @removeFuzzyFinderClass()
    atom.workspaceView.command 'file-icon-supplement:toggleFuzzyFinderClass',
      => @toggleClass 'fuzzyFinderIcons'
    atom.workspaceView.command 'file-icon-supplement:addFindAndReplaceClass',
      => @addFindAndReplaceClass()
    atom.workspaceView.command 'file-icon-supplement:removeFindAndReplaceClass',
      => @removeFindAndReplaceClass()
    atom.workspaceView.command 'file-icon-supplement:toggleFindAndReplaceClass',
      => @toggleClass 'findAndReplaceIcons'
    atom.workspaceView.command 'file-icon-supplement:addGrammarClass',
      => @addGrammarClass()
    atom.workspaceView.command 'file-icon-supplement:removeGrammarClass',
      => @removeGrammarClass()
    atom.workspaceView.command 'file-icon-supplement:toggleGrammarClass',
      => @toggleClass 'grammarIcons'
    atom.workspaceView.command 'file-icon-supplement:removeAllClass',
      => @removeAllClass()
    atom.workspaceView.command 'file-icon-supplement:toggleAllClass',
      => @toggleClass()

    @subscribe atom.config.observe 'file-icon-supplement.tabIcons',
      => @loadTabSettings()
    @subscribe atom.config.observe 'file-icon-supplement.treeViewIcons',
      => @loadTreeViewSettings()
    @subscribe atom.config.observe 'file-icon-supplement.fuzzyFinderIcons',
      => @loadFuzzyFinderSettings()
    @subscribe atom.config.observe 'file-icon-supplement.findAndReplaceIcons',
      => @loadFindAndReplaceSettings()
    @subscribe atom.config.observe 'file-icon-supplement.grammarIcons',
      => @loadGrammarSettings()
    @subscribe atom.workspaceView.statusBar, 'active-buffer-changed',
      => @updateGrammarTitle()


  serialize: ->

  destroy: -> @detach()

  addTabClass: ->
    target = atom.workspaceView.find 'ul.tab-bar li.tab .title:not(.hide-icon)'
    target.addClass 'fis fis-tab'

  removeTabClass: ->
    target = atom.workspaceView.find '.fis.fis-tab'
    target.removeClass 'fis fis-tab'

  loadTabSettings: ->
    if atom.config.get 'file-icon-supplement.tabIcons'
      @addTabClass()
    else
      @removeTabClass()

  addTreeViewClass: ->
    target = atom.workspaceView.find 'ol.tree-view span.name.icon'
    target.addClass 'fis fis-tree'

  removeTreeViewClass: ->
    target = atom.workspaceView.find '.fis.fis-tree'
    target.removeClass 'fis fis-tree'

  loadTreeViewSettings: ->
    if atom.config.get 'file-icon-supplement.treeViewIcons'
      @addTreeViewClass()
    else
      @removeTreeViewClass()

  addFuzzyFinderClass: ->
    target = atom.workspaceView.find '.fuzzy-finder .file.icon'
    target.addClass 'fis fis-fuzzy'

  removeFuzzyFinderClass: ->
    target = atom.workspaceView.find '.fis.fis-fuzzy'
    target.removeClass 'fis fis-fuzzy'

  toggleFuzzyFinderClass: ->
    current = atom.config.get 'file-icon-supplement.FuzzyFinderIcons'
    atom.config.set 'file-icon-supplement.FuzzyFinderIcons', !current

  loadFuzzyFinderSettings: ->
    if atom.config.get 'file-icon-supplement.fuzzyFinderIcons'
      @addFuzzyFinderClass()
    else
      @removeFuzzyFinderClass()

  addFindAndReplaceClass: ->
    target = atom.workspaceView.find '.results-view span.icon'
    target.addClass 'fis fis-find'

  removeFindAndReplaceClass: ->
    target = atom.workspaceView.find '.fis.fis-find'
    target.removeClass 'fis fis-find'

  loadFindAndReplaceSettings: ->
    if atom.config.get 'file-icon-supplement.findAndReplaceIcons'
      @addFindAndReplaceClass()
    else
      @removeFindAndReplaceClass()

  addGrammarClass: ->
    target = atom.workspaceView.find '.status-bar-right > a:first-of-type'
    target.addClass 'fis fis-grammar'
    @updateGrammarTitle()

  updateGrammarTitle: ->
    target = atom.workspaceView.find '.status-bar-right > a:first-of-type'
    activeGrammar = target.text()
    target.attr 'title', activeGrammar

  removeGrammarClass: ->
    target = atom.workspaceView.find '.fis.fis-grammar'
    target.removeClass 'fis fis-grammar'

  loadGrammarSettings: ->
    if atom.config.get 'file-icon-supplement.grammarIcons'
      @addGrammarClass()
    else
      @removeGrammarClass()

  removeAllClass: ->
    target = atom.workspaceView.find '.fis'
    target.removeClass 'fis fis-tree fis-tab fis-fuzzy fis-find fis-grammar'

  loadAllSettings: ->
    @loadTabSettings()
    @loadTreeViewSettings()
    @loadFuzzyFinderSettings()
    @loadFindAndReplaceSettings()
    @loadGrammarSettings()

  toggleClass: (area) ->
    if area
      setting = 'file-icon-supplement.' + area
      value = atom.config.get setting
      atom.config.set setting, !value
    else if @isToggledOn()
      @setToggleClassCache()
      @disableAllSettings()
    else
      @recoverToggleClassCache()

  isToggledOn: ->
    atom.config.get('file-icon-supplement.tabIcons') or
    atom.config.get('file-icon-supplement.treeViewIcons') or
    atom.config.get('file-icon-supplement.fuzzyFinderIcons') or
    atom.config.get('file-icon-supplement.findAndReplaceIcons') or
    atom.config.get('file-icon-supplement.grammarIcons')

  toggleClassCache: {}

  setToggleClassCache: ->
    @toggleClassCache =
      tabIcons: atom.config.get 'file-icon-supplement.tabIcons'
      treeViewIcons: atom.config.get 'file-icon-supplement.treeViewIcons'
      fuzzyFinder: atom.config.get 'file-icon-supplement.fuzzyFinderIcons'
      findAndReplace: atom.config.get 'file-icon-supplement.findAndReplaceIcons'
      grammarIcons: atom.config.get 'file-icon-supplement.grammarIcons'

  recoverToggleClassCache: ->
    for key, value of @toggleClassCache
      atom.config.set 'file-icon-supplement.' + key, value

  disableAllSettings: ->
    atom.config.set 'file-icon-supplement.tabIcons', false
    atom.config.set 'file-icon-supplement.treeViewIcons', false
    atom.config.set 'file-icon-supplement.fuzzyFinderIcons', false
    atom.config.set 'file-icon-supplement.findAndReplaceIcons', false
    atom.config.set 'file-icon-supplement.grammarIcons', false
