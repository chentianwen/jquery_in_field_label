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
    @plugin_name: 'jQuery in-field label'
    @version: 'v0.9'
    constructor: (@input, @global_options) ->

    ## constants
    @default_options:
      align: 'left'
      padding: 2
      opacity: 0.4
      opacity_min: 0
      opacity_max: 0.7
      tag_class: 'in_field_label_class'
    
    @valid_types: [
      'text', 'password', 'color', 'date', 'datetime'
      'datetime-local', 'email', 'month', 'number', 'range'
      'search', 'tel', 'time', 'url', 'week'
    ]
    
    @option_keys: $.map(@default_options, (v, k) -> k)
    
    @valid_selectors: $.map(@valid_types, (v) -> "[type=#{v}]").join(',')
    
    ## helpers
    @is_blank: (obj) -> ! obj || obj.length == 0 || $.trim(obj).length == 0
    
    @find_data_options_for: ($input) ->
      data_options = {} 
      $.each InFieldLabel.option_keys, (v, k) -> $input.data(k) && data_options[k] = $input.data(k)
      data_options

    @append_input_after_label: ($input, $label) ->
      if InFieldLabel.is_blank $input.attr('id') # setup id for input
        id = "in_field_label_#{parseInt(new Date().getTime() * Math.random())}"
        $input.attr 'id', id
        $label.attr 'for', id
      $label.after $input

    @$_find_associated_label_for: ($input) ->
      # 1. look up from its parents
      $label = $input.parents 'label:first'
      return InFieldLabel.append_input_after_label $input, $label unless InFieldLabel.is_blank $label
      # 2. look up by the id
      id = $input.attr 'id'
      $("label[for='#{id}']") unless InFieldLabel.is_blank id

    @reposition_label_to_front_of_input: ($label, $input, options)->
      $label.css 'position': 'absolute', 'cursor': 'text'
      if options.align == 'left'
        x = $input.offset().left + parseInt($input.css('padding-left')) + options.padding
      else if options.align == 'right'
        x = $input.offset().left + $input.outerWidth() - $label.outerWidth() - parseInt($input.css('padding-right')) - options.padding
      y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2
      $label.css 'left': "#{x}px", 'top': "#{y}px"

    setup: ->
      $input = $ @input
      $label = InFieldLabel.$_find_associated_label_for $input
      return if InFieldLabel.is_blank $label # do nothing if $label is not found
      
      # clean up
      $input.unbind 'keyup.in_field_label'
      $input.unbind 'focus.in_field_label'
      $input.unbind 'blur.in_field_label'
      
      # setup now
      options = $.extend {}, InFieldLabel.default_options, InFieldLabel.find_data_options_for($input), @global_options
      InFieldLabel.reposition_label_to_front_of_input $label, $input, options

      $(window).bind "resize.in_field_label.#{$input.attr 'id'}", (e) ->
        InFieldLabel.reposition_label_to_front_of_input $label, $input, options

      $input.bind 'keyup.in_field_label', (e) ->
        if $input.val().length > 0 || \ # have text
        ($input.val().length == 0 && e && e.keyCode > 31) # still typing
          $label.css 'opacity': options.opacity_min
        else
          $label.css 'opacity': options.opacity
      
      $input.bind 'focus.in_field_label', (e) ->
        $label.css 'opacity': options.opacity if $input.val().length == 0
      $input.bind 'blur.in_field_label',  (e) ->
        $label.css 'opacity': options.opacity_max if $input.val().length == 0
      
      # init
      if $input.val().length > 0
        $label.css {'opacity': options.opacity_min}
      else
        $label.css {'opacity': options.opacity_max}

      $input.data 'in_field_label_status', 'all_set'
      $input.addClass options.tag_class
      $label.addClass options.tag_class

  $.fn.in_field_label = (opts = {}) ->
    this.filter($.InFieldLabel.valid_selectors).each ->
      new $.InFieldLabel(this, opts).setup()
      
  # auto setup for input elements that has in_field_label
  $(document.body).append("<script type='text/javascript'>jQuery(function($){ $('input.in_field_label').in_field_label() })</script>")