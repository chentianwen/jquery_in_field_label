(function() {

  jQuery(function($) {
    $('h1.title').text($.in_field.name + ' ' + $.in_field.version);
    return prettyPrint();
  });

}).call(this);
