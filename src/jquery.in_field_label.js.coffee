###
 * jQuery in-field label v0.9
 * @summary for input box 
 * @source_code https://github.com/chentianwen/jquery_in_field_label
 * 
 * @copyright 2011, Tianwen Chen
 * @website https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
###
jQuery ($) ->
  class $.InFieldLabel
    constructor: (input, @options) ->
      @$input = $(input)

    ## constants
    @default_options:
      align: 'left'
      padding: 4
      opacity: 0.4
      opacity_min: 0
      opacity_max: 0.7
      animate_duration: 200
    
    @valid_types: [
      'text', 'password', 'color', 'date', 'datetime'
      'datetime-local', 'email', 'month', 'number', 'range'
      'search', 'tel', 'time', 'url', 'week'
    ]
    
    @option_keys: \
    $.map(@default_options, (v, k) -> k)
    
    @valid_selectors: \
    $.map(@valid_types, (v) -> "[type=#{v}]").join(',')
    
    ## helpers
    @$_is_blank: ($obj) ->
      ! $obj || $obj.length == 0
    
    @is_blank: (obj) ->
      ! obj || obj == ''
    
    @find_data_options_for: ($input) ->
      opts = {} 
      $.each @option_keys, (v, k) -> opts[k] = $input.data(k)
      opts

    @append_input_after_label: ($input, $label) ->
      if @is_blank $input.attr('id') # setup id for input
        id = "in_field_label_#{parseInt(new Date().getTime() * Math.random())}"
        $input.attr 'id', id
        $label.attr 'for', id
      $label.after $input

    @$_find_associated_label_for: ($input) ->
      # 1. look up from its parents
      $label = $input.parents 'label:first'
      return @append_input_after_label $input, $label unless @$_is_blank $label
      # 2. look up by the id
      id = $input.attr 'id'
      $("label[for='#{id}']") unless @is_blank id

    ## methods
    _reposition_label_to_front_of_input: ->
      @$label.css 'position': 'absolute', 'cursor': 'text'
      if @options.align == 'left'
        x = @$input.offset().left + parseInt(@$input.css('padding-left')) + @options.padding
      else if @options.align == 'right'
        x = @$input.offset().left + @$input.outerWidth() - @$label.outerWidth() - parseInt(@$input.css('padding-right')) - @options.padding
      y = @$input.offset().top + (@$input.outerHeight() - @$label.outerHeight()) / 2
      @$label.css 'left': "#{x}px", 'top': "#{y}px"

    setup: ->
      @$label = @$_find_associated_label_for @$input
      return if @$_is_blank @$label # do nothing if $label is not found
      
      @options = $.extend {}, @default_options, @find_data_options_for(@$input), @options
  
      @_reposition_label_to_front_of_input
      
      @$input.bind 'keyup.in_field_label', (e) ->
        if @$input.val().length > 0 || \ # have text
        (@$input.val().length == 0 && e && e.keyCode > 31) # still typing
          @$label.clearQueue().animate {'opacity': @options.opacity_min}, @options.animate_duration
        else
          @$label.clearQueue().animate {'opacity': @options.opacity}, @options.animate_duration
      
      @$input.bind 'focus.in_field_label', (e) ->
        @$label.clearQueue().animate {'opacity': @options.opacity}, @options.animate_duration
      @$input.bind 'blur.in_field_label', (e) ->
        @$label.clearQueue().animate {'opacity': @options.opacity_max}, @options.animate_duration
      
      # init
      if @$input.val().length > 0
        @$label.css {'opacity': @options.opacity_min}
      else
        @$label.css {'opacity': @options.opacity_max}
  $.fn.in_field_label = (opts = {}) ->
    this.filter(new $.InFieldLabel.valid_selectors).each ->
      new $.InFieldLabel(this, opts).setup()
      
  # auto setup for input elements that has in_field_label
  $('input.in_field_label').in_field_label()