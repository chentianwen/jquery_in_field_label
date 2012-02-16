(function() {

  jQuery(function($) {
    return $.fn.in_field_label = function(opts) {
      var $_find_label_for, $_is_blank, is_blank, position_input_field, position_non_parent_label;
      if (opts == null) opts = {};
      opts = $.extend({
        left_offset: 6,
        opacity: 0.5,
        animate_duration: 300
      }, opts);
      $_is_blank = function($obj) {
        return !$obj || $obj.length === 0;
      };
      is_blank = function(obj) {
        return !obj || obj === '';
      };
      $_find_label_for = function($input) {
        var $parent_label, id;
        $parent_label = $input.parents('label:first').data('is_parent', true);
        if (!$_is_blank($parent_label)) return $parent_label;
        id = $input.attr('id');
        if (!is_blank(id)) {
          return $("label[for='" + id + "']").data('is_parent', false);
        }
      };
      position_non_parent_label = function($label, $input) {
        var x, y;
        $label.css({
          'position': 'absolute'
        });
        x = $input.offset().left + opts.left_offset;
        y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2;
        return $label.css({
          'left': "" + x + "px",
          'top': "" + y + "px"
        });
      };
      position_input_field = function($label, $input) {
        return $input;
      };
      return this.each(function() {
        var $label, $this, toggle_label;
        $this = $(this);
        $label = $_find_label_for($this);
        if ($_is_blank($label)) return;
        if ($label.data('is_parent')) {
          reposition_parent_label($label, $this);
        } else {
          reposition_non_parent_label($label, $this);
        }
        toggle_label = function(e) {
          if ($this.val().length > 0 || ($this.val().length === 0 && e && e.keyCode > 31)) {
            return $label.animate({
              'opacity': 0
            }, opts.animate_duration);
          } else {
            return $label.animate({
              'opacity': opts.opacity
            }, opts.animate_duration);
          }
        };
        $this.bind('keyup.in_field_label', toggle_label);
        $this.bind('focus.in_field_label', toggle_label);
        $this.bind('blur.in_field_label', toggle_label);
        return toggle_label();
      });
    };
  });

}).call(this);
