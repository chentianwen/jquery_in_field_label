(function() {

  beforeEach(function() {
    return this.addMatchers({
      toBeDummy: function(expected) {
        return this.actual === expected;
      }
    });
  });

}).call(this);
