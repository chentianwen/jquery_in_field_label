(function() {

  jQuery(function($) {
    var interval_id;
    $('h1.title').text($.in_field.name + ' ' + $.in_field.version);
    prettyPrint();
    return interval_id = setInterval(function() {
      var build_status;
      build_status = $('#spec').contents().find('body').attr('data-build-status');
      return $('#jasmine-build-status').removeClass('passed failed').addClass(build_status);
    }, 1000);
  });

}).call(this);
