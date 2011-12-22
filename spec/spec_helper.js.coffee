beforeEach ->
  this.addMatchers toBeDummy: (expected) ->
    this.actual == expected
    