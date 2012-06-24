(function() {

  jQuery(function($) {
    return describe('InField', function() {
      return describe('::setup', function() {
        return it('should return false if element is not supported', function() {
          expect($.InField.setup($('<article />'))).toBeFalsy();
          return expect($.InField.setup($('<input />'))).toBeTruthy();
        });
      });
    });
  });

}).call(this);
