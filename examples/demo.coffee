jQuery ($) ->
  $('h1.title').text($.in_field.name + ' ' + $.in_field.version)
  prettyPrint()

  #interval_id = setInterval ->
  #  build_status = $('#spec').contents().find('body').attr('data-build-status')
  #  $('#jasmine-build-status').removeClass('passed failed').addClass build_status
  #, 1000
