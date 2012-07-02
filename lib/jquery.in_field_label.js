
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
      defaults: {
        label_hide: {
          hide: 'hide'
        }
      },
      version: '0.9.1',
      name: 'JQuery In-field Label',
      klass: 'in_field',
      support_types: 'input[type=text], input[type=password], input[type=color], input[type=date], input[type=datetime], input[type=datetime-local], input[type=email], input[type=month], input[type=number], input[type=range], input[type=search], input[type=tel], input[type=time], input[type=url], input[type=week], textarea',
      events: {
        keyup: 'keyup.jquery_in_field_label',
        focus: 'focus.jquery_in_field_label',
        blur: 'blur.jquery_in_field_label'
      }
    };
    $.InField = (function() {

      function InField() {}

      InField.init = function($input, options, $label) {
        this.validate_input($input);
        $label = this.find_and_validate_label($input, $label);
        this.link($input, $label);
        this.wrap($input, $label);
        return this.mark_as_toggled($input);
      };

      InField.validate_input = function($element) {
        if (!$element.is($.in_field.support_types)) {
          throw new Error('Element not supported.');
        }
      };

      InField.find_and_validate_label = function($input, $label) {
        if (!($label && $label.length === 1 && $label.is('label'))) {
          $label = this.find_label_for($input);
        }
        if ($label && $label.length === 1) {
          return $label;
        } else {
          throw new Error('Label not found.');
        }
      };

      InField.find_label_for = function($input) {
        var $label;
        $label = $input.parents('label:first');
        if ($label.length === 0) {
          $label = $("label[for='" + ($input.attr('id')) + "']");
        }
        if ($label.length === 1) {
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

      InField.validate_event_target = function($target) {
        if ($target.is("[data-toggle=" + $.in_field.klass + "]")) {
          return true;
        }
      };

      InField.has_value = function(event) {
        var value;
        value = $(event.target).val();
        return value !== '' || value === '' && event.keyCode > 31;
      };

      InField.render = function(status, $input) {
        switch (status) {
          case 'hide':
            break;
          case 'focus':
            break;
          case 'normal':
        }
      };

      InField.handle_keyup = function(event) {
        if (this.has_value(event)) {
          return this.render('hide');
        } else {
          return this.render('focus');
        }
      };

      InField.handle_focue = function(event) {
        if (!this.has_value(event)) {
          return this.render('focus');
        }
      };

      InField.handle_blur = function(event) {
        if (!this.has_value(event)) {
          return this.render('normal');
        }
      };

      return InField;

    })();
    $('body').on($.in_field.events.keyup, $.in_field.support_types, $.InField.handle_keyup);
    $('body').on($.in_field.events.focus, $.in_field.support_types, $.InField.handle_focus);
    return $('body').on($.in_field.events.blur, $.in_field.support_types, $.InField.handle_blur);
  });

}).call(this);
