(function() {

  describe($.in_field_label, function() {
    return describe("#is_blank", function() {
      return context("blank", function() {
        return specify(function() {
          return is_blank(null).should(be_true);
        });
      });
    });
  });

}).call(this);
