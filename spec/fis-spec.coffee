{WorkspaceView} = require 'atom'

describe "Test Suite", ->
  it "has some expectations that should pass", ->
    expect(true).toBe true
    expect("apples").toEqual "apples"
    expect("oranges").not.toEqual "apples"

describe 'activation', ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView()

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

    atom.packages.emit('activated')

    runs ->
      expect(atom.workspaceView.find '.fis-tab').toExist()
      expect(atom.workspaceView.find '.fis-tree.').toExist()
      expect(atom.workspaceView.find '.fis-grammar').toExist()
