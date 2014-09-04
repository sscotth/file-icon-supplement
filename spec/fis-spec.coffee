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

    waitsForPromise ->
      atom.packages.activatePackage('tree-view')

    runs ->
      activationPromise = atom.packages.activatePackage('file-icon-supplement')

  it 'it is disabled by default', ->
    expect(activationPromise.isFulfilled()).not.toBeTruthy()
    expect(atom.packages.isPackageActive('file-icon-supplement')).toBe false

  it 'it enables with event', ->
    atom.workspaceView.trigger 'editor:display-updated'

    waitsForPromise ->
      activationPromise

    runs ->
      expect(atom.packages.isPackageActive('file-icon-supplement')).toBe true
      expect(atom.workspaceView.find('.fis-tree')).toExist()
