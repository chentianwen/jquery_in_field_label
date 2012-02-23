
/*
 * jQuery in-field label v0.9
 * https://github.com/chentianwen/jquery_in_field_label
 * 
 * Copyright 2011, Tianwen Chen
 * https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
*/

(function() {

  jQuery(function($) {
    $.in_field_label = {
      default_options: {
        align: 'left',
        padding: 4,
        opacity: 0.4,
        opacity_min: 0,
        opacity_max: 0.7,
        animate_duration: 200
      },
      option_keys: function() {
        return $.map(this.default_options, function(v, k) {
          return k;
        });
      },
      valid_types: ['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week'],
      valid_selectors: function() {
        return $.map(this.valid_types, function(v) {
          return "[type=" + v + "]";
        }).join(',');
      },
      $_is_blank: function($obj) {
        return !$obj || $obj.length === 0;
      },
      is_blank: function(obj) {
        return !obj || obj === '';
      },
      find_self_options_for: function($input) {
        var opts;
        opts = {};
        $.each(this.option_keys, function(v, k) {
          return opts[k] = $input.data(k);
        });
        return opts;
      },
      append_input_after_label: function($label, $input) {
        var id;
        if (is_blank($input.attr('id'))) {
          id = "in_field_label_" + (parseInt(new Date().getTime() * Math.random()));
          $input.attr('id', id);
          $label.attr('for', id);
        }
        return $label.after($input);
      },
      $_find_label_for: function($input) {
        var $label, id;
        $label = $input.parents('label:first');
        if (!this.$_is_blank($label)) {
          return append_input_after_label($label, $input);
        }
        id = $input.attr('id');
        if (!this.is_blank(id)) return $("label[for='" + id + "']");
      },
      reposition_label_to_front_of_input: function($label, $input, opts) {
        var x, y;
        $label.css({
          'position': 'absolute',
          'cursor': 'text'
        });
        if (opts.align === 'left') {
          x = $input.offset().left + parseInt($input.css('padding-left')) + opts.padding;
        } else if (opts.align === 'right') {
          x = $input.offset().left + $input.outerWidth() - $label.outerWidth() - parseInt($input.css('padding-right')) - opts.padding;
        }
        y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2;
        return $label.css({
          'left': "" + x + "px",
          'top': "" + y + "px"
        });
      },
      setup: function($input, opts) {
        var $label, options;
        $label = $_find_label_for($input);
        if ($_is_blank($label)) return;
        options = $.extend({}, $.in_field_label.default_options, find_self_options_for($this), opts);
        reposition_label_to_front_of_input($label.css({
          'opacity': 0
        }), $this, options);
        $this.bind('keyup.in_field_label', function(e) {
          if ($this.val().length > 0 || ($this.val().length === 0 && e && e.keyCode > 31)) {
            return $label.clearQueue().animate({
              'opacity': options.opacity_min
            }, options.animate_duration);
          } else {
            return $label.clearQueue().animate({
              'opacity': options.opacity
            }, options.animate_duration);
          }
        });
        $this.bind('focus.in_field_label', function(e) {
          return $label.clearQueue().animate({
            'opacity': options.opacity
          }, options.animate_duration);
        });
        $this.bind('blur.in_field_label', function(e) {
          return $label.clearQueue().animate({
            'opacity': options.opacity_max
          }, options.animate_duration);
        });
        if ($this.val().length > 0) {
          return $label.css({
            'opacity': options.opacity_min
          });
        } else {
          return $label.css({
            'opacity': options.opacity_max
          });
        }
      }
    };
    $.fn.in_field_label = function(opts) {
      if (opts == null) opts = {};
      return this.filter($.in_field_label.valid_selectors).each(function() {});
    };
    return $('input.in_field_label').in_field_label();
  });

}).call(this);
