jQuery ($) ->
  $.fn.inFieldLabel = (opts = {}) ->
    opts = $.extend { left_offset: 6, opacity: 0.5, animate_duration: 300 }, opts
    
    $_is_blank = ($obj) -> ! $obj || $obj.length == 0
    
    is_blank = (obj) -> ! obj || obj == ''
    
    $_find_label_for = ($input) ->
      $parent_label = $input.parents('label:first').data 'is_parent', true
      return $parent_label unless $_is_blank $parent_label # input field is inside a label
      # TODO: move the input field out of the label
      id = $input.attr 'id'
      $("label[for=#{id}]").data 'is_parent', false unless is_blank id
    
    position_non_parent_label = ($label, $input) ->  
      $label.css 'position': 'absolute'
      x = $input.offset().left + opts.left_offset;
      y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2
      $label.css 'left': "#{x}px", 'top': "#{y}px"
    
    position_input_field = ($label, $input) -> $input
    
    this.each ->
      $this = $(this)
      $label = $_find_label_for $this
      return if $_is_blank $label
      
      unless $label.data 'is_parent'
        position_non_parent_label $label, $this
      else
        position_input_field $label, $this
        
      toggle_label = (e) ->
        if $this.val().length > 0 || \ # have text
        ($this.val().length == 0 && e && e.keyCode > 31) # going to have text
          $label.animate {'opacity': 0}, opts.animate_duration
        else
          $label.animate {'opacity': opts.opacity}, opts.animate_duration
      
      $this.bind 'keyup.inFieldLabel', toggle_label
      $this.bind 'focus.inFieldLabel', toggle_label
      $this.bind 'blur.inFieldLabel', toggle_label
      toggle_label()