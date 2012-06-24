###
 * jQuery in-field label v0.9
 * @summary display the label inlined with input box
 * @source_code https://github.com/chentianwen/jquery_in_field_label
 * 
 * @copyright 2011, Tianwen Chen
 * @website https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
###

###
 * Requirement: jQuery v1.7 and above
###
"use_strict"
jQuery ($) ->

  # options
  $.in_field =
    defaults:
      opacity: 0.4
      opacity_min: 0.0
      opacity_max: 0.7
    version: '0.9.1'
    name: 'JQuery In-field Label'
    support_types: 'text, password, color, date, datetime, datetime-local, email, month, number, range, search, tel, time, url, week'
    events:
      keyup:  'keyup.jquery_in_field_label'
      focus:  'focus.jquery_in_field_label'
      blur:   'blue.jquery_in_field_label'
      resize: 'resize.jquery_in_field_label'

  class $.InField
    init: (label, input, options) ->
    handle_keyup: (input) ->
    fade_in: (input) ->
    fade_out: (input) ->

  $('body').on $.in_field.events.keyup, $.in_field.support_types, (e) ->
    $target = $(e.target)
    return unless $(e.target).is('[data-toggle=in_field]')
