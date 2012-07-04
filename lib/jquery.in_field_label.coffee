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
    version: '0.9.1'
    name: 'JQuery In-field Label'
    klass: 'in_field'
    # support HTML5 elements INPUT and TEXTAREA
    support_types: 'input[type=text], input[type=password], input[type=color], input[type=date], input[type=datetime], input[type=datetime-local], input[type=email], input[type=month], input[type=number], input[type=range], input[type=search], input[type=tel], input[type=time], input[type=url], input[type=week], textarea'
    mark: '[data-toggle=in_field]'
    events:
      keyup:  'keyup.jquery_in_field_label'
      focus:  'focus.jquery_in_field_label'
      blur:   'blur.jquery_in_field_label'

  class $.InField
    # helper
    @present: (obj) ->
      obj && obj instanceof $ && obj.length == 1

    @init: ($input, $label) ->
      # validations
      @validate_input $input
      $label = @find_and_validate_label $input, $label

      @link $input, $label
      @wrap $input, $label
      @mark_as_toggled $input # ready to go!
      @render 'normal', $input

    # @private
    @validate_input: ($element) ->
      throw new Error('Element not supported.') unless $element.is($.in_field.support_types)

    @find_and_validate_label: ($input, $label) ->
      $label = @find_label_for $input unless @present($label) && $label.is('label')
      return $label if @present($label)
      throw new Error('Label not found.')

    @find_label_for: ($input) ->
      $label = $input.parents('label:first')
      $label = $("label[for='#{ $input.attr('id') }']") unless @present($label)
      $label if @present($label)

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

    @has_value: (event) ->
      value = $(event.target).val()
      (value && value.length > 0) || (value == '' && event.keyCode > 31)

    @render: (status, $input) ->
      switch status
        when 'blur'   then $input.parent().addClass('blur').removeClass('normal focus')
        when 'focus'  then $input.parent().addClass('focus').removeClass('normal blur')
        when 'normal' then $input.parent().addClass('normal').removeClass('focus blur')
      
    @handle_keyup: (event) ->
      unless @has_value(event)
        @render 'focus', $(event.target)
      else
        @render 'blur', $(event.target)

    @handle_focus: (event) ->
      @render 'focus', $(event.target) unless @has_value(event)

    @handle_blur: (event) ->
      @render 'normal', $(event.target) unless @has_value(event)

  $('body').on $.in_field.events.keyup, $.in_field.mark, $.proxy($.InField.handle_keyup, $.InField)
  $('body').on $.in_field.events.focus, $.in_field.mark, $.proxy($.InField.handle_focus, $.InField)
  $('body').on $.in_field.events.blur,  $.in_field.mark, $.proxy($.InField.handle_blur, $.InField)

  $.fn.in_field = ($label) ->
    $(@).each -> $.InField.init($(@), $label)

  $($.in_field.support_types).filter($.in_field.mark).in_field()
