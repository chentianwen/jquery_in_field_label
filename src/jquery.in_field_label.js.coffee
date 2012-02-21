###
###
jQuery ($) ->
  $.in_field_label = default_options: { align: 'left', padding: 4, opacity: 0.5, animate_duration: 200 }
  
  $_is_blank = ($obj) -> ! $obj || $obj.length == 0
  is_blank = (obj) -> ! obj || obj == ''
  
  find_options_for = ($input) ->
    opts = {}
    $.each ['align', 'padding', 'opacity', 'animate_duration'], (name) ->
      opt_value = $input.data(name)
      unless is_blank opt_value
        opts[name] = opt_value
    debugger
    opts
  
  append_input_after_label = ($label, $input) ->
    if is_blank $input.attr('id') # setup id for input
      id = "in_field_label_#{new Date().getTime() * Math.random()}"
      $input.attr 'id', id
      $label.attr 'for', id
    $label.after $input
  
  $_find_label_for = ($input) ->
    # 1. look up from its parents
    $label = $input.parents 'label:first'
    return append_input_after_label $label, $input unless $_is_blank $label
    # 2. look up by the id
    id = $input.attr 'id'
    $("label[for='#{id}']") unless is_blank id
  
  reposition_label_to_front_of_input = ($label, $input, opts) ->
    $label.css 'position': 'absolute', 'cursor': 'text'
    if opts.align == 'left'
      x = $input.offset().left + parseInt($input.css('padding-left')) + opts.padding
      $label.css 'left': "#{x}px"
    if opts.align == 'right'
      x = $input.offset().right - parseInt($input.css('padding-right')) - opts.padding
      $label.css 'right': "#{x}px"
    y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2
    $label.css 'left': "#{x}px", 'top': "#{y}px"
  
  $.fn.in_field_label = (opts = {}) ->
    # support html 4 & 5 types
    valid_selectors = $.map(['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week'], (v) ->
      "[type=#{v}]" 
    ).join(',')
    this.filter(valid_selectors).each ->
      $this = $ this # this does look like typo
      $label = $_find_label_for $this
      return if $_is_blank $label # do nothing if $label is not found
      
      self_opts = $.extend $.in_field_label.default_options, find_options_for($this), opts
        
      # 1. reposition
      reposition_label_to_front_of_input $label.css({'opacity': 0}), $this, self_opts
      
      # 2. setup event
      toggle_label = (e) ->
        if $this.val().length > 0 || \ # have text
        ($this.val().length == 0 && e && e.keyCode > 31) # still typing
          $label.animate {'opacity': 0}, self_opts.animate_duration
        else
          $label.animate {'opacity': self_opts.opacity}, self_opts.animate_duration

      $this.bind 'keyup.in_field_label', toggle_label
      $this.bind 'focus.in_field_label', toggle_label
      $this.bind 'blur.in_field_label', toggle_label
      # 3. initial trigger
      toggle_label()
      
  # auto setup for input elements that has in_field_label
  $('input.in_field_label').in_field_label()