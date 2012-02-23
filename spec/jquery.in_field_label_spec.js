(function() {

  jQuery(function($) {
    return describe("in-field label", function() {
      return it("default_options", function() {
        return expect($.InFieldLabel.option_keys[0]).toEqual('align');
      });
    });
  });

}).call(this);
