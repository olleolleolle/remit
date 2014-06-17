#= require helpers/spec_helper
#= require helpers/fake_app
#= require angular/directives/nav_link

describe "Directive: navLink", ->

  fakeLocation = {}
  beforeEach ->
    provide "$location", fakeLocation

  $compile = $rootScope = undefined
  beforeEach inject (_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $rootScope = _$rootScope_

  it "adds class=current is the path ", ->
    FluidApp.running = true
    element = compile "<a href='google' fluid-app-link>banan</a>"
    expect(element.attr("target")).toBeUndefined()

  it "adds target=_blank if FluidApp.running is false", ->
    FluidApp.running = false
    element = compile "<a href='google' fluid-app-link>banan</a>"
    expect(element.attr("target")).toBe("_blank")


  compile = (html) ->
    element = $compile(html)($rootScope)
    $rootScope.$digest()
    element
