
/*
 * jQuery in-field label v0.9
 * @summary display the label inlined with input box
 * @source_code https://github.com/chentianwen/jquery_in_field_label
 * 
 * @copyright 2011, Tianwen Chen
 * @website https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
*/


/*
 * Requirement: jQuery v1.7 and above
*/


(function() {
  "use_strict";

  jQuery(function($) {
    $.in_field = {
      version: '0.9.1',
      name: 'JQuery In-field Label',
      klass: 'in_field',
      support_types: 'input[type=text], input[type=password], input[type=color], input[type=date], input[type=datetime], input[type=datetime-local], input[type=email], input[type=month], input[type=number], input[type=range], input[type=search], input[type=tel], input[type=time], input[type=url], input[type=week], textarea',
      mark: '[data-toggle=in_field]',
      events: {
        keyup: 'keyup.jquery_in_field_label',
        focus: 'focus.jquery_in_field_label',
        blur: 'blur.jquery_in_field_label'
      }
    };
    $.InField = (function() {

      function InField() {}

      InField.present = function(obj) {
        return obj && obj instanceof $ && obj.length === 1;
      };

      InField.init = function($input, $label) {
        this.validate_input($input);
        $label = this.find_and_validate_label($input, $label);
        this.link($input, $label);
        this.wrap($input, $label);
        this.mark_as_toggled($input);
        return this.render('normal', $input);
      };

      InField.validate_input = function($element) {
        if (!$element.is($.in_field.support_types)) {
          throw new Error('Element not supported.');
        }
      };

      InField.find_and_validate_label = function($input, $label) {
        if (!(this.present($label) && $label.is('label'))) {
          $label = this.find_label_for($input);
        }
        if (this.present($label)) {
          return $label;
        }
        throw new Error('Label not found.');
      };

      InField.find_label_for = function($input) {
        var $label;
        $label = $input.parents('label:first');
        if (!this.present($label)) {
          $label = $("label[for='" + ($input.attr('id')) + "']");
        }
        if (this.present($label)) {
          return $label;
        }
      };

      InField.link = function($input, $label) {
        var id;
        id = $input.attr('id');
        if (!id) {
          $input.attr('id', (id = "jquery_in_field_label_" + (new Date().getTime())));
        }
        return $label.attr('for', id);
      };

      InField.wrap = function($input, $label) {
        var $wrapper;
        $wrapper = $input.parents('label:first')[0] === $label[0] ? $label.wrap('<div />').parent().append($input) : $input.wrap('<div />').parent().prepend($label);
        return $wrapper.addClass($.in_field.klass);
      };

      InField.mark_as_toggled = function($input) {
        return $input.attr('data-toggle', $.in_field.klass);
      };

      InField.has_value = function(event) {
        var value;
        value = $(event.target).val();
        return (value && value.length > 0) || (value === '' && event.keyCode > 31);
      };

      InField.render = function(status, $input) {
        switch (status) {
          case 'blur':
            return $input.parent().addClass('blur').removeClass('normal focus');
          case 'focus':
            return $input.parent().addClass('focus').removeClass('normal blur');
          case 'normal':
            return $input.parent().addClass('normal').removeClass('focus blur');
        }
      };

      InField.handle_keyup = function(event) {
        if (!this.has_value(event)) {
          return this.render('focus', $(event.target));
        } else {
          return this.render('blur', $(event.target));
        }
      };

      InField.handle_focus = function(event) {
        if (!this.has_value(event)) {
          return this.render('focus', $(event.target));
        }
      };

      InField.handle_blur = function(event) {
        if (!this.has_value(event)) {
          return this.render('normal', $(event.target));
        }
      };

      return InField;

    })();
    $('body').on($.in_field.events.keyup, $.in_field.mark, $.proxy($.InField.handle_keyup, $.InField));
    $('body').on($.in_field.events.focus, $.in_field.mark, $.proxy($.InField.handle_focus, $.InField));
    $('body').on($.in_field.events.blur, $.in_field.mark, $.proxy($.InField.handle_blur, $.InField));
    $.fn.in_field = function($label) {
      return $(this).each(function() {
        return $.InField.init($(this), $label);
      });
    };
    return $($.in_field.support_types).filter($.in_field.mark).in_field();
  });

}).call(this);
