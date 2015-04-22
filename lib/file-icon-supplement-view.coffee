{CompositeDisposable, Directory} = require 'atom'
{$, View} = require 'atom-space-pen-views'

module.exports =
class FileIconSupplementView extends View

  @content: ->
    @div class: 'fis'

  initialize: (serializeState) ->
    @subscriptions = new CompositeDisposable
    @handleEvents()

  serialize: ->

  handleEvents: ->
    @subscriptions.add atom.commands.add 'atom-workspace',
      'file-icon-supplement:addTabClass': => @addTabClass()
      'file-icon-supplement:removeTabClass': => @removeTabClass()
      'file-icon-supplement:toggleTabClass': => @toggleClass 'tabIcons'
      'file-icon-supplement:addTreeViewClass': => @addTreeViewClass()
      'file-icon-supplement:removeTreeViewClass': => @removeTreeViewClass()
      'file-icon-supplement:toggleTreeViewClass': => @toggleClass 'treeViewIcons'
      'file-icon-supplement:addFuzzyFinderClass': => @addFuzzyFinderClass()
      'file-icon-supplement:removeFuzzyFinderClass': => @removeFuzzyFinderClass()
      'file-icon-supplement:toggleFuzzyFinderClass': => @toggleClass 'fuzzyFinderIcons'
      'file-icon-supplement:addFindAndReplaceClass': => @addFindAndReplaceClass()
      'file-icon-supplement:removeFindAndReplaceClass': => @removeFindAndReplaceClass()
      'file-icon-supplement:toggleFindAndReplaceClass': => @toggleClass 'findAndReplaceIcons'
      'file-icon-supplement:addGrammarStatusClass': => @addGrammarStatusClass()
      'file-icon-supplement:removeGrammarStatusClass': => @removeGrammarStatusClass()
      'file-icon-supplement:toggleGrammarStatusClass': => @toggleClass 'grammarStatusIcons'
      'file-icon-supplement:addGrammarSelectorClass': => @addGrammarSelectorClass()
      'file-icon-supplement:removeGrammarSelectorClass': => @removeGrammarSelectorClass()
      'file-icon-supplement:toggleGrammarSelectorClass': => @toggleClass 'grammarSelectorIcons'
      'file-icon-supplement:removeAllClass': => @removeAllClass()
      'file-icon-supplement:toggleAllClass': => @toggleClass()

    @subscriptions.add atom.config.observe,
      'file-icon-supplement.tabIcons': => @loadTabSettings()
      'file-icon-supplement.treeViewIcons': => @loadTreeViewSettings()
      'file-icon-supplement.fuzzyFinderIcons': => @loadFuzzyFinderSettings()
      'file-icon-supplement.findAndReplaceIcons': => @loadFindAndReplaceSettings()
      'file-icon-supplement.grammarStatusIcons': => @loadGrammarStatusSettings()

      'tabs.showIcons': => @loadTabSettings()
      'tree-view.hideVcsIgnoredFiles': => @loadTreeViewSettings()
      'tree-view.hideIgnoredNames': => @loadTreeViewSettings()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'project-find:show': => @addFindAndReplaceEvent()
      'fuzzy-finder:toggle-file-finder': => @loadFuzzyFinderSettings()
      'grammar-selector:show': => @loadGrammarSelectorSettings()

    @subscriptions.add atom.workspace.onDidChangeActivePaneItem,
      => @addTabClass()

    atom.project.getPaths().forEach (projectPath) =>
      path = new Directory(projectPath)
      path.onDidChange @addTreeViewClass

  destroy: -> @detach()

  addTabClass: ->
    $('ul.tab-bar li.tab .title:not(.hide-icon)').addClass 'fis fis-tab'
    @reloadStyleSheets()

  removeTabClass: ->
    $('.fis.fis-tab').removeClass 'fis fis-tab'

  loadTabSettings: ->
    if atom.config.get 'file-icon-supplement.tabIcons'
      @addTabClass()
    else
      @removeTabClass()

  addTreeViewClass: =>
    $('ol.tree-view span.name.icon').addClass 'fis fis-tree'
    @reloadStyleSheets()

  removeTreeViewClass: ->
    $('.fis.fis-tree').removeClass 'fis fis-tree'

  loadTreeViewSettings: ->
    if atom.config.get 'file-icon-supplement.treeViewIcons'
      @addTreeViewClass()
    else
      @removeTreeViewClass()

  addFuzzyFinderClass: ->
    $('.fuzzy-finder .file.icon').addClass 'fis fis-fuzzy'
    @reloadStyleSheets()

  removeFuzzyFinderClass: ->
    $('.fis.fis-fuzzy').removeClass 'fis fis-fuzzy'

  toggleFuzzyFinderClass: ->
    current = atom.config.get 'file-icon-supplement.FuzzyFinderIcons'
    atom.config.set 'file-icon-supplement.fuzzyFinderIcons', !current

  loadFuzzyFinderSettings: ->
    if atom.config.get 'file-icon-supplement.fuzzyFinderIcons'
      @addFuzzyFinderClass()
    else
      @removeFuzzyFinderClass()

  addFindAndReplaceClass: ->
    $('.results-view span.icon').addClass 'fis fis-find'
    @reloadStyleSheets()

  removeFindAndReplaceClass: ->
    atom.workspace.eachEditor ->
      $('.fis.fis-find').removeClass 'fis fis-find'

  loadFindAndReplaceSettings: ->
    if atom.config.get 'file-icon-supplement.findAndReplaceIcons'
      @addFindAndReplaceClass()
    else
      @removeFindAndReplaceClass()
      @removeFindAndReplaceEvent()

  subscriptions = {}

  addFindAndReplaceEvent: ->
    if atom.packages.loadedPackages['find-and-replace'] and
    atom.config.get 'file-icon-supplement.findAndReplaceIcons'
      subscriptions.findAndReplace = atom.packages
        .loadedPackages['find-and-replace'].mainModule.resultsModel
        .onDidFinishSearching => @addFindAndReplaceClass()
      atom.commands.add 'atom-workspace', 'core:cancel',
        => @removeFindAndReplaceEvent()

  removeFindAndReplaceEvent: ->
    subscriptions.findAndReplace.dispose()

  addGrammarStatusClass: ->
    $('.grammar-status a').addClass 'fis fis-grammar-status'
    @reloadStyleSheets()

  removeGrammarStatusClass: ->
    $('.fis.fis-grammar-status').removeClass 'fis fis-grammar-status'

  loadGrammarStatusSettings: ->
    if atom.config.get 'file-icon-supplement.grammarStatusIcons'
      @addGrammarStatusClass()
    else
      @removeGrammarStatusClass()

  addGrammarSelectorClass: ->
    $('.grammar-selector li').addClass 'fis fis-grammar-selector'
    @reloadStyleSheets()

  removeGrammarSelectorClass: ->
    $('.fis.fis-grammar-selector').removeClass 'fis fis-grammar-selector'

  loadGrammarSelectorSettings: ->
    if atom.config.get 'file-icon-supplement.grammarSelectorIcons'
      @addGrammarSelectorClass()
    else
      @removeGrammarSelectorClass()

  removeAllClass: ->
    $('.fis').removeClass 'fis fis-tree fis-tab fis-fuzzy fis-find fis-grammar-status fis-grammar-selector'

  loadAllSettings: ->
    @loadTabSettings()
    @loadTreeViewSettings()
    @loadFuzzyFinderSettings()
    @loadFindAndReplaceSettings()
    @loadGrammarStatusSettings()
    @loadGrammarSelectorSettings()

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
    atom.config.get('file-icon-supplement.grammarStatusIcons') or
    atom.config.get('file-icon-supplement.grammarSelectorIcons')

  toggleClassCache: {}

  setToggleClassCache: ->
    @toggleClassCache =
      tabIcons: atom.config.get 'file-icon-supplement.tabIcons'
      treeViewIcons: atom.config.get 'file-icon-supplement.treeViewIcons'
      fuzzyFinderIcons: atom.config.get 'file-icon-supplement.fuzzyFinderIcons'
      findAndReplaceIcons: atom.config.get(
        'file-icon-supplement.findAndReplaceIcons')
      grammarStatusIcons: atom.config.get 'file-icon-supplement.grammarStatusIcons'
      grammarSelectorIcons: atom.config.get 'file-icon-supplement.grammarSelectorIcons'

  recoverToggleClassCache: ->
    for key, value of @toggleClassCache
      atom.config.set 'file-icon-supplement.' + key, value

  disableAllSettings: ->
    atom.config.set 'file-icon-supplement.tabIcons', false
    atom.config.set 'file-icon-supplement.treeViewIcons', false
    atom.config.set 'file-icon-supplement.fuzzyFinderIcons', false
    atom.config.set 'file-icon-supplement.findAndReplaceIcons', false
    atom.config.set 'file-icon-supplement.grammarStatusIcons', false
    atom.config.set 'file-icon-supplement.grammarSelectorIcons', false

  reloadStyleSheets: ->
    atom.themes.reloadBaseStylesheets()
