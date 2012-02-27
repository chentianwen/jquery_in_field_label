
/*
 * jQuery in-field label v0.9
 * @summary for input box 
 * @source_code https://github.com/chentianwen/jquery_in_field_label
 * 
 * @copyright 2011, Tianwen Chen
 * @website https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
*/

(function() {

  jQuery(function($) {
    $.InFieldLabel = (function() {

      InFieldLabel.plugin_name = 'jQuery in-field label';

      InFieldLabel.version = 'v0.9';

      function InFieldLabel(input, global_options) {
        this.input = input;
        this.global_options = global_options;
      }

      InFieldLabel.default_options = {
        align: 'left',
        padding: 2,
        opacity: 0.4,
        opacity_min: 0,
        opacity_max: 0.7,
        tag_class: 'in_field_label_class'
      };

      InFieldLabel.valid_types = ['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week'];

      InFieldLabel.option_keys = $.map(InFieldLabel.default_options, function(v, k) {
        return k;
      });

      InFieldLabel.valid_selectors = $.map(InFieldLabel.valid_types, function(v) {
        return "[type=" + v + "]";
      }).join(',');

      InFieldLabel.is_blank = function(obj) {
        return !obj || obj.length === 0 || $.trim(obj).length === 0;
      };

      InFieldLabel.find_data_options_for = function($input) {
        var data_options;
        data_options = {};
        $.each(InFieldLabel.option_keys, function(v, k) {
          return $input.data(k) && (data_options[k] = $input.data(k));
        });
        return data_options;
      };

      InFieldLabel.append_input_after_label = function($input, $label) {
        var id;
        if (InFieldLabel.is_blank($input.attr('id'))) {
          id = "in_field_label_" + (parseInt(new Date().getTime() * Math.random()));
          $input.attr('id', id);
          $label.attr('for', id);
        }
        return $label.after($input);
      };

      InFieldLabel.$_find_associated_label_for = function($input) {
        var $label, id;
        $label = $input.parents('label:first');
        if (!InFieldLabel.is_blank($label)) {
          return InFieldLabel.append_input_after_label($input, $label);
        }
        id = $input.attr('id');
        if (!InFieldLabel.is_blank(id)) return $("label[for='" + id + "']");
      };

      InFieldLabel.reposition_label_to_front_of_input = function($label, $input, options) {
        var x, y;
        $label.css({
          'position': 'absolute',
          'cursor': 'text'
        });
        if (options.align === 'left') {
          x = $input.offset().left + parseInt($input.css('padding-left')) + options.padding;
        } else if (options.align === 'right') {
          x = $input.offset().left + $input.outerWidth() - $label.outerWidth() - parseInt($input.css('padding-right')) - options.padding;
        }
        y = $input.offset().top + ($input.outerHeight() - $label.outerHeight()) / 2;
        return $label.css({
          'left': "" + x + "px",
          'top': "" + y + "px"
        });
      };

      InFieldLabel.prototype.setup = function() {
        var $input, $label, options;
        $input = $(this.input);
        $label = InFieldLabel.$_find_associated_label_for($input);
        if (InFieldLabel.is_blank($label)) return;
        $input.unbind('keyup.in_field_label');
        $input.unbind('focus.in_field_label');
        $input.unbind('blur.in_field_label');
        options = $.extend({}, InFieldLabel.default_options, InFieldLabel.find_data_options_for($input), this.global_options);
        InFieldLabel.reposition_label_to_front_of_input($label, $input, options);
        $input.bind('keyup.in_field_label', function(e) {
          if ($input.val().length > 0 || ($input.val().length === 0 && e && e.keyCode > 31)) {
            return $label.css({
              'opacity': options.opacity_min
            });
          } else {
            return $label.css({
              'opacity': options.opacity
            });
          }
        });
        $input.bind('focus.in_field_label', function(e) {
          if ($input.val().length === 0) {
            return $label.css({
              'opacity': options.opacity
            });
          }
        });
        $input.bind('blur.in_field_label', function(e) {
          if ($input.val().length === 0) {
            return $label.css({
              'opacity': options.opacity_max
            });
          }
        });
        if ($input.val().length > 0) {
          $label.css({
            'opacity': options.opacity_min
          });
        } else {
          $label.css({
            'opacity': options.opacity_max
          });
        }
        $input.data('in_field_label_status', 'all_set');
        $input.addClass(options.tag_class);
        return $label.addClass(options.tag_class);
      };

      return InFieldLabel;

    })();
    $.fn.in_field_label = function(opts) {
      if (opts == null) opts = {};
      return this.filter($.InFieldLabel.valid_selectors).each(function() {
        return new $.InFieldLabel(this, opts).setup();
      });
    };
    return $('input.in_field_label').in_field_label();
  });

}).call(this);
