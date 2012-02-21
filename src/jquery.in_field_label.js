
/*
*/

(function() {

  jQuery(function($) {
    var $_find_label_for, $_is_blank, append_input_after_label, find_options_for, is_blank, reposition_label_to_front_of_input;
    $.in_field_label = {
      default_options: {
        align: 'left',
        padding: 4,
        opacity: 0.5,
        animate_duration: 200
      }
    };
    $_is_blank = function($obj) {
      return !$obj || $obj.length === 0;
    };
    is_blank = function(obj) {
      return !obj || obj === '';
    };
    find_options_for = function($input) {
      var opts;
      opts = {};
      $.each(['align', 'padding', 'opacity', 'animate_duration'], function(name) {
        var opt_value;
        opt_value = $input.data(name);
        if (!is_blank(opt_value)) return opts[name] = opt_value;
      });
      debugger;
      return opts;
    };
    append_input_after_label = function($label, $input) {
      var id;
      if (is_blank($input.attr('id'))) {
        id = "in_field_label_" + (new Date().getTime() * Math.random());
        $input.attr('id', id);
        $label.attr('for', id);
      }
      return $label.after($input);
    };
    $_find_label_for = function($input) {
      var $label, id;
      $label = $input.parents('label:first');
      if (!$_is_blank($label)) return append_input_after_label($label, $input);
      id = $input.attr('id');
      if (!is_blank(id)) return $("label[for='" + id + "']");
    };
    reposition_label_to_front_of_input = function($label, $input, opts) {
      var x, y;
      $label.css({
        'position': 'absolute',
        'cursor': 'text'
      });
      if (opts.align === 'left') {
        x = $input.offset().left + parseInt($input.css('padding-left')) + opts.padding;
        $label.css({
          'left': "" + x + "px"
        });
      }
      if (opts.align === 'right') {
        x = $input.offset().right - parseInt($input.css('padding-right')) - opts.padding;
        $label.css({
          'right': "" + x + "px"
        });
      }
      y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2;
      return $label.css({
        'left': "" + x + "px",
        'top': "" + y + "px"
      });
    };
    $.fn.in_field_label = function(opts) {
      var valid_selectors;
      if (opts == null) opts = {};
      valid_selectors = $.map(['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week'], function(v) {
        return "[type=" + v + "]";
      }).join(',');
      return this.filter(valid_selectors).each(function() {
        var $label, $this, self_opts, toggle_label;
        $this = $(this);
        $label = $_find_label_for($this);
        if ($_is_blank($label)) return;
        self_opts = $.extend($.in_field_label.default_options, find_options_for($this), opts);
        reposition_label_to_front_of_input($label.css({
          'opacity': 0
        }), $this, self_opts);
        toggle_label = function(e) {
          if ($this.val().length > 0 || ($this.val().length === 0 && e && e.keyCode > 31)) {
            return $label.animate({
              'opacity': 0
            }, self_opts.animate_duration);
          } else {
            return $label.animate({
              'opacity': self_opts.opacity
            }, self_opts.animate_duration);
          }
        };
        $this.bind('keyup.in_field_label', toggle_label);
        $this.bind('focus.in_field_label', toggle_label);
        $this.bind('blur.in_field_label', toggle_label);
        return toggle_label();
      });
    };
    return $('input.in_field_label').in_field_label();
  });

}).call(this);
