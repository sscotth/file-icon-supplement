{WorkspaceView} = require 'atom'

describe "Test Suite", ->
  it "has some expectations that should pass", ->
    expect(true).toBe true
    expect("apples").toEqual "apples"
    expect("oranges").not.toEqual "apples"

describe 'activation', ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    waitsForPromise ->
      atom.packages.activatePackage 'status-bar'

    runs ->
      activationPromise = atom.packages.activatePackage 'file-icon-supplement'

  it 'it is disabled by default', ->
    expect(activationPromise.isFulfilled()).not.toBeTruthy()
    expect(atom.packages.isPackageActive 'file-icon-supplement').toBe false

  it 'it enables with event', ->
    atom.workspaceView.trigger 'editor:display-updated'

    waitsForPromise ->
      activationPromise

    runs ->
      expect(atom.packages.isPackageActive 'file-icon-supplement').toBe true

describe 'file-icon-supplement base-ui', ->

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    waitsForPromise ->
      atom.packages.activatePackage 'tabs'
    waitsForPromise ->
      atom.packages.activatePackage 'tree-view'
    waitsForPromise ->
      atom.packages.activatePackage 'status-bar'
    waitsForPromise ->
      atom.packages.activatePackage 'grammar-selector'
    waitsForPromise ->
      atom.workspace.open()

  it 'it automatically adds base-ui classes on open', ->
    waitsForPromise ->
      atom.packages.activatePackage 'file-icon-supplement'

    atom.packages.emit 'activated'

    runs ->
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

  it 'it adds only the classes that are specificed in the config on open', ->
    atom.config.set 'file-icon-supplement.treeViewIcons', false
    atom.config.set 'file-icon-supplement.tabIcons', false
    atom.config.set 'file-icon-supplement.grammarIcons', false

    waitsForPromise ->
      atom.packages.activatePackage 'file-icon-supplement'

    atom.packages.emit 'activated'

    runs ->
      expect(atom.workspaceView.find '.fis-tree').not.toExist()
      expect(atom.workspaceView.find '.fis-tab').not.toExist()
      expect(atom.workspaceView.find '.fis-grammar').not.toExist()

  it 'it responds to changes in the config after open', ->
    waitsForPromise ->
      atom.packages.activatePackage 'file-icon-supplement'

    atom.packages.emit 'activated'

    runs ->
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

      atom.config.set 'file-icon-supplement.treeViewIcons', false
      atom.config.set 'file-icon-supplement.tabIcons', false
      atom.config.set 'file-icon-supplement.grammarIcons', false

      expect(atom.workspaceView.find '.fis-tree').not.toExist()
      expect(atom.workspaceView.find '.fis-tab').not.toExist()
      expect(atom.workspaceView.find '.fis-grammar').not.toExist()

describe 'file-icon-supplement:toggles', ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView
    waitsForPromise ->
      atom.packages.activatePackage 'language-javascript'
    waitsForPromise ->
      atom.packages.activatePackage 'tabs'
    waitsForPromise ->
      atom.packages.activatePackage 'tree-view'
    waitsForPromise ->
      atom.packages.activatePackage 'status-bar'
    waitsForPromise ->
      atom.packages.activatePackage 'grammar-selector'
    waitsForPromise ->
      atom.workspace.open 'example.js'
    waitsForPromise ->
      atom.packages.activatePackage 'file-icon-supplement'
    runs ->
      atom.packages.emit 'activated'

  describe 'file-icon-supplement:toggleTreeViewClass', ->
    it 'it can trigger a tree-view toggle', ->
      atom.workspaceView.trigger 'file-icon-supplement:toggleTreeViewClass'
      expect(atom.workspaceView.find '.fis-tree').not.toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()
      atom.workspaceView.trigger 'file-icon-supplement:toggleTreeViewClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

  describe 'file-icon-supplement:toggleTabClass', ->
    it 'it can trigger a tab toggle', ->
      atom.workspaceView.trigger 'file-icon-supplement:toggleTabClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').not.toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()
      atom.workspaceView.trigger 'file-icon-supplement:toggleTabClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

  describe 'file-icon-supplement:toggleGrammarClass', ->
    it 'it can trigger a grammar toggle', ->
      atom.workspaceView.trigger 'file-icon-supplement:toggleGrammarClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').not.toExist()
      atom.workspaceView.trigger 'file-icon-supplement:toggleGrammarClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

  describe 'file-icon-supplement:toggleAllClass', ->
    it 'it toggles all off on first trigger', ->
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()
      atom.workspaceView.trigger 'file-icon-supplement:toggleAllClass'
      expect(atom.workspaceView.find '.fis-tree').not.toExist()
      expect(atom.workspaceView.find '.fis-tab').not.toExist()
      expect(atom.workspaceView.find '.fis-grammar').not.toExist()
      atom.workspaceView.trigger 'file-icon-supplement:toggleAllClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()

    it 'it only enables previously enabled areas on second trigger', ->
      atom.workspaceView.trigger 'file-icon-supplement:toggleTabClass'
      atom.workspaceView.trigger 'file-icon-supplement:toggleAllClass'
      atom.workspaceView.trigger 'file-icon-supplement:toggleAllClass'
      expect(atom.workspaceView.find '.fis-tree').toExist()
      expect(atom.workspaceView.find '.fis-tab').not.toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()
      expect(Object.keys(atom.config.get 'file-icon-supplement').length).toBe 5

  describe 'file-icon-supplement:grammar', ->
    it 'it adds a title attribute when opening a file', ->
      expect(atom.workspaceView.find('.fis-grammar').attr 'title')
        .toBe 'JavaScript'

    it 'it changes title when opening a file of a different type', ->
      waitsForPromise ->
        atom.workspace.open 'example.txt'

      runs ->
        atom.workspaceView.statusBar.trigger 'active-buffer-changed'
        expect(atom.workspaceView.find('.fis-grammar').attr 'title')
          .toBe 'Plain Text'

    it 'it changes title when grammar changes', ->
      waitsForPromise ->
        atom.packages.activatePackage('language-coffee-script')

      runs ->
        expect(atom.workspaceView.getActivePaneItem().getGrammar().name)
          .toBe 'JavaScript'
        coffeeGrammar = atom.syntax.grammarForScopeName('source.coffee')
        atom.workspace.getActiveEditor().setGrammar(coffeeGrammar)
        expect(atom.workspaceView.getActivePaneItem().getGrammar().name)
          .toBe 'CoffeeScript'
        atom.workspace.getActiveEditor().emit 'grammar-changed'
        expect(atom.workspaceView.find('.fis-grammar').attr 'title')
          .toBe 'CoffeeScript'
