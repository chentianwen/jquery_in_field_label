(function() {

  jQuery(function($) {
    $('#input1').in_field_label({
      align: 'right'
    });
    return $('input:not([id])').in_field_label();
  });

}).call(this);
