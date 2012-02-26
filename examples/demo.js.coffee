jQuery ($) ->
  $('h1.title').text($.InFieldLabel.plugin_name + ' ' + $.InFieldLabel.version)
  $('#input1').in_field_label(align: 'right')
  $('input:not([id])').in_field_label()