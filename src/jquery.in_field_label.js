
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

      function InFieldLabel(input, options) {
        this.options = options;
        this.$input = $(input);
      }

      InFieldLabel.default_options = {
        align: 'left',
        padding: 4,
        opacity: 0.4,
        opacity_min: 0,
        opacity_max: 0.7,
        animate_duration: 200
      };

      InFieldLabel.valid_types = ['text', 'password', 'color', 'date', 'datetime', 'datetime-local', 'email', 'month', 'number', 'range', 'search', 'tel', 'time', 'url', 'week'];

      InFieldLabel.option_keys = $.map(InFieldLabel.default_options, function(v, k) {
        return k;
      });

      InFieldLabel.valid_selectors = $.map(InFieldLabel.valid_types, function(v) {
        return "[type=" + v + "]";
      }).join(',');

      InFieldLabel.$_is_blank = function($obj) {
        return !$obj || $obj.length === 0;
      };

      InFieldLabel.is_blank = function(obj) {
        return !obj || obj === '';
      };

      InFieldLabel.find_data_options_for = function($input) {
        var opts;
        opts = {};
        $.each(this.option_keys, function(v, k) {
          return opts[k] = $input.data(k);
        });
        return opts;
      };

      InFieldLabel.append_input_after_label = function($input, $label) {
        var id;
        if (this.is_blank($input.attr('id'))) {
          id = "in_field_label_" + (parseInt(new Date().getTime() * Math.random()));
          $input.attr('id', id);
          $label.attr('for', id);
        }
        return $label.after($input);
      };

      InFieldLabel.$_find_associated_label_for = function($input) {
        var $label, id;
        $label = $input.parents('label:first');
        if (!this.$_is_blank($label)) {
          return this.append_input_after_label($input, $label);
        }
        id = $input.attr('id');
        if (!this.is_blank(id)) return $("label[for='" + id + "']");
      };

      InFieldLabel.prototype._reposition_label_to_front_of_input = function() {
        var x, y;
        this.$label.css({
          'position': 'absolute',
          'cursor': 'text'
        });
        if (this.options.align === 'left') {
          x = this.$input.offset().left + parseInt(this.$input.css('padding-left')) + this.options.padding;
        } else if (this.options.align === 'right') {
          x = this.$input.offset().left + this.$input.outerWidth() - this.$label.outerWidth() - parseInt(this.$input.css('padding-right')) - this.options.padding;
        }
        y = this.$input.offset().top + (this.$input.outerHeight() - this.$label.outerHeight()) / 2;
        return this.$label.css({
          'left': "" + x + "px",
          'top': "" + y + "px"
        });
      };

      InFieldLabel.prototype.setup = function() {
        this.$label = this.$_find_associated_label_for(this.$input);
        if (this.$_is_blank(this.$label)) return;
        this.options = $.extend({}, this.default_options, this.find_data_options_for(this.$input), this.options);
        this._reposition_label_to_front_of_input;
        this.$input.bind('keyup.in_field_label', function(e) {
          if (this.$input.val().length > 0 || (this.$input.val().length === 0 && e && e.keyCode > 31)) {
            return this.$label.clearQueue().animate({
              'opacity': this.options.opacity_min
            }, this.options.animate_duration);
          } else {
            return this.$label.clearQueue().animate({
              'opacity': this.options.opacity
            }, this.options.animate_duration);
          }
        });
        this.$input.bind('focus.in_field_label', function(e) {
          return this.$label.clearQueue().animate({
            'opacity': this.options.opacity
          }, this.options.animate_duration);
        });
        this.$input.bind('blur.in_field_label', function(e) {
          return this.$label.clearQueue().animate({
            'opacity': this.options.opacity_max
          }, this.options.animate_duration);
        });
        if (this.$input.val().length > 0) {
          return this.$label.css({
            'opacity': this.options.opacity_min
          });
        } else {
          return this.$label.css({
            'opacity': this.options.opacity_max
          });
        }
      };

      return InFieldLabel;

    })();
    $.fn.in_field_label = function(opts) {
      if (opts == null) opts = {};
      return this.filter(new $.InFieldLabel.valid_selectors).each(function() {
        return new $.InFieldLabel(this, opts).setup();
      });
    };
    return $('input.in_field_label').in_field_label();
  });

}).call(this);
