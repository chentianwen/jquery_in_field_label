##
jQuery ($) ->
  $.fn.in_field_label = (opts = {}) ->
    ## extend default options
    opts = $.extend { left_offset: 6, opacity: 0.5, animate_duration: 300 }, opts
    
    ## common functions
    $_is_blank = ($obj) -> ! $obj || $obj.length == 0
    
    is_blank = (obj) -> ! obj || obj == ''
    
    $_find_label_for = ($input) ->
      $parent_label = $input.parents('label:first').data 'is_parent', true
      return $parent_label unless $_is_blank $parent_label # input field is inside a label
      id = $input.attr 'id'
      $("label[for='#{id}']").data 'is_parent', false unless is_blank id
    
    position_non_parent_label = ($label, $input) ->
      $label.css 'position': 'absolute'
      x = $input.offset().left + opts.left_offset;
      y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2
      $label.css 'left': "#{x}px", 'top': "#{y}px"
    
    position_input_field = ($label, $input) -> $input
    
    this.each ->
      $this = $(this)
      $label = $_find_label_for $this
      return if $_is_blank $label # do nothing if $label is not found
      
      if $label.data 'is_parent'
        reposition_parent_label $label, $this
      else
        reposition_non_parent_label $label, $this
        
      toggle_label = (e) ->
        if $this.val().length > 0 || \ # have text
        ($this.val().length == 0 && e && e.keyCode > 31) # going to have text
          $label.animate {'opacity': 0}, opts.animate_duration
        else
          $label.animate {'opacity': opts.opacity}, opts.animate_duration
      
      $this.bind 'keyup.in_field_label', toggle_label
      $this.bind 'focus.in_field_label', toggle_label
      $this.bind 'blur.in_field_label', toggle_label
      toggle_label()