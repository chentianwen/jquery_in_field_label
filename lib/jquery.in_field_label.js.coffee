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
      label_class:
        show: 'show'
        hide: 'hide'
    version: '0.9.1'
    name: 'JQuery In-field Label'
    # include HTML5 elements INPUT and TEXTAREA
    klass: 'in_field'
    support_types: 'input[type=text], input[type=password], input[type=color], input[type=date], input[type=datetime], input[type=datetime-local], input[type=email], input[type=month], input[type=number], input[type=range], input[type=search], input[type=tel], input[type=time], input[type=url], input[type=week], textarea'
    events:
      keyup:  'keyup.jquery_in_field_label'
      focus:  'focus.jquery_in_field_label'
      blur:   'blur.jquery_in_field_label'
      resize: 'resize.jquery_in_field_label'

  class $.InField
    @init: ($input, options, $label) ->
      return unless @validate_input $input
      return unless $label = @find_and_validate_label $input, $label
      @link $input, $label
      @wrap $input, $label
      @mark_as_toggled $input # ready to go!

    @validate_input: ($input) ->
      unless $input.is($.in_field.support_types)
        return console && console.log("Not supported for #{ $input[0].tagName }")
      true

    @find_and_validate_label: ($input, $label) ->
      unless $label && $label.length == 1 && $label.is('label')
        $label = @find_label_for $input
      if $label && $label.length == 1
        $label
      else
        console && console.log("No label found")

    @find_label_for: ($input) ->
      $label = $input.parents('label:first')
      $label = $("label[for='#{ $input.attr('id') }']") if $label.length == 0
      $label if $label.length == 1

    @link: ($input, $label) ->
      id = $input.attr('id')
      $input.attr('id', (id = "jquery_in_field_label_#{ new Date().getTime() }")) unless id
      $label.attr('for', id)

    @wrap: ($input, $label) ->
      $wrapper = if $input.parents('label:first')[0] == $label[0] # inside the label
        $label.wrap('<div />').parent().append($input)
      else # outside the label
        $input.wrap('<div />').parent().prepend($label)
      $wrapper.addClass($.in_field.klass)

    @mark_as_toggled: ($input) ->
      $input.attr('data-toggle', $.in_field.klass)

    @handle_keyup: (input) ->
    @show: (input) ->
    @hide: (input) ->

  $('body').on $.in_field.events.keyup, $.in_field.support_types, (e) ->
    $.InField.handle_keyup $(e.target)

  $('body').on $.in_field.events.focus, $.in_field.support_types, (e) ->
    $.InField.handle_keyup $(e.target)

  $('body').on $.in_field.events.blur, $.in_field.support_types, (e) ->
    $.InField.handle_keyup $(e.target)

