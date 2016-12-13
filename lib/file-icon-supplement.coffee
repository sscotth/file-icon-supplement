FileIconSupplementView = require './file-icon-supplement-view'

module.exports =

  config:
    treeViewIcons:
      type: 'boolean'
      default: true
    tabIcons:
      type: 'boolean'
      default: true
    fuzzyFinderIcons:
      type: 'boolean'
      default: true
    findAndReplaceIcons:
      type: 'boolean'
      default: true
    grammarStatusIcons:
      type: 'boolean'
      default: true
    grammarSelectorIcons:
      type: 'boolean'
      default: true
    someSettingC:
      type: 'array'
      default: [1, 2, 3]
      items:
        type: 'integer'
        minimum: 1.5
        maximum: 11.5
    iconStyle:
      title: 'Icon Styles'
      description: 'This will affect all icons. If Selecting "Single Color", then each icon\'s color will take effect'
      type: 'string'
      default: 'Single Color'
      enum: ['No Color', 'Single Color', 'Multi-Color']
      order: 4
    vcsColors:
      title: 'VCS Color Override'
      description: 'Checking this option will force the VCS colors to only affect the text, not the icons. Does not affect Multi-Colored Icons.'
      type: 'boolean'
      default: 'true'
      order: 5

    goLangIcon:
      title: 'Go Language'
      type: 'string'
      default: 'go'
      enum: ['go', 'go-fill', 'go-fill-half']
      order: 6
    goLangIconColor:
      title: 'Icon Color'
      type: 'color'
      default: '#abcdef'
      order: 7

    cssLangIcon:
      title: 'CSS Language'
      type: 'string'
      default: 'fill'
      enum: ['fill', 'no-fill', 'go-fill-nope']
      order: 8
    cssLangIconColor:
      title: 'Icon Color'
      type: 'color'
      default: '#12fde3'
      order: 9

    jsLangIcon:
      title: 'JavaScript Language'
      type: 'string'
      default: 'fill'
      enum: ['fill', 'no-fill', 'go-fill-nope']
      order: 10
    jsLangIconColor:
      title: 'Icon Color'
      type: 'color'
      default: '#a21fee'
      order: 11

    lessLangIcon:
      title: 'less Language'
      type: 'string'
      default: 'fill'
      enum: ['fill', 'no-fill', 'go-fill-nope']
      order: 12
    lessLangIconColor:
      title: 'Icon Color'
      type: 'color'
      default: '#ab2d11'
      order: 13

  fileIconSupplementView: null

  activate: (state) ->
    atom.packages.onDidActivateInitialPackages () =>
      # settingsMenu = document.getElementById('file-icon-supplement.iconStyle').closest('.section-body')

      @fileIconSupplementView =
        new FileIconSupplementView state.fileIconSupplementViewState
      # @fileIconSupplementView.appendTo(settingsMenu)

  deactivate: ->
    @fileIconSupplementView.destroy()

  serialize: ->
    fileIconSupplementViewState: @fileIconSupplementView.serialize()
