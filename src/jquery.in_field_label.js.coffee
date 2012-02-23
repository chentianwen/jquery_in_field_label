###
 * jQuery in-field label v0.9
 * https://github.com/chentianwen/jquery_in_field_label
 * 
 * Copyright 2011, Tianwen Chen
 * https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
###
jQuery ($) ->
  $.in_field_label = {
    default_options: { align: 'left', padding: 4, opacity: 0.4, opacity_min: 0, opacity_max: 0.7, animate_duration: 200 }
    option_keys: -> $.map this.default_options, (v, k) -> k

    valid_types: ['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week']
    valid_selectors: -> $.map(this.valid_types, (v) -> "[type=#{v}]").join ','

    $_is_blank: ($obj) -> ! $obj || $obj.length == 0
    is_blank: (obj) -> ! obj || obj == ''

    find_self_options_for: ($input) ->
      opts = {}
      $.each this.option_keys, (v, k) -> opts[k] = $input.data(k)
      opts

    append_input_after_label: ($label, $input) ->
      if is_blank $input.attr('id') # setup id for input
        id = "in_field_label_#{parseInt(new Date().getTime() * Math.random())}"
        $input.attr 'id', id
        $label.attr 'for', id
      $label.after $input

    $_find_label_for: ($input) ->
      # 1. look up from its parents
      $label = $input.parents 'label:first'
      return append_input_after_label $label, $input unless this.$_is_blank $label
      # 2. look up by the id
      id = $input.attr 'id'
      $("label[for='#{id}']") unless this.is_blank id
  
    reposition_label_to_front_of_input: ($label, $input, opts) ->
      $label.css 'position': 'absolute', 'cursor': 'text'
      if opts.align == 'left'
        x = $input.offset().left + parseInt($input.css('padding-left')) + opts.padding
      else if opts.align == 'right'
        x = $input.offset().left + $input.outerWidth() - $label.outerWidth() - parseInt($input.css('padding-right')) - opts.padding
      y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2
      $label.css 'left': "#{x}px", 'top': "#{y}px"

    setup: ($input, opts) ->
      $label = $_find_label_for $input
      return if $_is_blank $label # do nothing if $label is not found
      
      options = $.extend {}, $.in_field_label.default_options, find_self_options_for($this), opts

      reposition_label_to_front_of_input $label.css('opacity': 0), $this, options
      
      $this.bind 'keyup.in_field_label', (e) ->
        if $this.val().length > 0 || \ # have text
        ($this.val().length == 0 && e && e.keyCode > 31) # still typing
          $label.clearQueue().animate {'opacity': options.opacity_min}, options.animate_duration
        else
          $label.clearQueue().animate {'opacity': options.opacity}, options.animate_duration
      
      $this.bind 'focus.in_field_label', (e) ->
        $label.clearQueue().animate {'opacity': options.opacity}, options.animate_duration
      $this.bind 'blur.in_field_label', (e) ->
        $label.clearQueue().animate {'opacity': options.opacity_max}, options.animate_duration
      
      # init
      if $this.val().length > 0
        $label.css {'opacity': options.opacity_min}
      else
        $label.css {'opacity': options.opacity_max}
  }

  $.fn.in_field_label = (opts = {}) ->
    this.filter($.in_field_label.valid_selectors).each ->
      
  # auto setup for input elements that has in_field_label
  $('input.in_field_label').in_field_label()