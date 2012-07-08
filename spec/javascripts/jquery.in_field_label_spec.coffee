jQuery ($) ->
  # fixtures
  set_fixtures_for_not_linking_input_and_label = ->
    setFixtures '<label>Last Name</label><input type="text" name="first_name" />'
    [ $('input', $('#jasmine-fixtures')), $('label', $('#jasmine-fixtures')) ]

  set_fixtures_for_linking_input_and_parent_label = ->
    setFixtures '<label>First Name <input type="text" name="first_name" /></label>'
    [ $('input', $('#jasmine-fixtures')), $('label', $('#jasmine-fixtures')) ]

  set_fixtures_for_linking_input_and_non_parent_label = set_fixtures_for_empty_input_and_label = ->
    setFixtures '<label for="first_name">First Name</label><input id="first_name" type="text" />'
    [ $('input', $('#jasmine-fixtures')), $('label', $('#jasmine-fixtures')) ]

  set_fixtures_for_non_empty_input_and_label = ->
    setFixtures '<label for="first_name">First Name</label><input id="first_name" type="text" value="Tian" />'
    [ $('input', $('#jasmine-fixtures')), $('label', $('#jasmine-fixtures')) ]

  # test cases
  describe 'InField', ->
    describe '::present', ->
      it 'must return true if the object is presented as not empty jQuery', ->
        expect($.InField.present($('body'))).toBeTruthy()

      it 'must return not true if the object is not presented', ->
        expect($.InField.present(undefined)).not.toBeTruthy()
        expect($.InField.present({})).not.toBeTruthy()
        expect($.InField.present([])).not.toBeTruthy()
        expect($.InField.present([ 1 ])).not.toBeTruthy()
        expect($.InField.present($('something'))).not.toBeTruthy()

    describe '::validate_input', ->
      it 'must return not true if the input element is not supported', ->
        expect($.InField.validate_input($('<article />'))).not.toBeTruthy()
        expect($.InField.validate_input($('<input type="unknown" />'))).not.toBeTruthy()

      it 'must return true if the input element is supported', ->
        expect($.InField.validate_input($('<input type="text" />'))).toBeTruthy()

    describe '::find_and_validate_label', ->
      it 'must return not true if the label element associated with the input element is not found', ->
        [ $input, $label ] = set_fixtures_for_not_linking_input_and_label()
        expect($.InField.find_and_validate_label($input, $('<table></table>'))).not.toBeTruthy()

      it 'must return the label jQuery object if the label element is found outside wrapping the input element', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_parent_label()
        $result = $.InField.find_and_validate_label($input, $('<table></table>'))
        expect($result[0]).toEqual($label[0])
        expect($result instanceof jQuery).toBeTruthy()
        expect($result).toBe('label')

      it 'must return the label jQuery object if the label element is found for the input element', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_non_parent_label()
        $result = $.InField.find_and_validate_label($input, $('<table></table>'))
        expect($result[0]).toEqual($label[0])
        expect($result instanceof jQuery).toBeTruthy()
        expect($result).toBe('label')

    describe '::find_label_for', ->
      it 'must return undefined when there is no label associated with the input element', ->
        [ $input, $label ] = set_fixtures_for_not_linking_input_and_label()
        expect($.InField.find_label_for($input)).toBeUndefined()

      it 'must return the label jQuery object when there is one in the parents of the input element', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_parent_label()
        $result = $.InField.find_label_for($input)
        expect($result[0]).toEqual($label[0])
        expect($result instanceof jQuery).toBeTruthy()
        expect($result).toBe('label')
        
      it 'must return the label jQuery object when there is one associated with the input element', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_non_parent_label()
        $result = $.InField.find_label_for($input)
        expect($result[0]).toEqual($label[0])
        expect($result instanceof jQuery).toBeTruthy()
        expect($result).toBe('label')
        
    describe '::link', ->
      it 'must generate the id for the input element and the label element', ->
        $input = $ '<input type="text" />'
        $label = $ '<label>label_text</label>'
        $.InField.link($input, $label)
        expect($label.attr('for')).not.toBeUndefined()
        expect($label.attr('for')).toMatch(/^jquery_in_field_label_\d+$/i)
        expect($label.attr('for')).toEqual($input.attr('id'))

      it 'must set the id for the input element and the label element', ->
        $input = $ '<input id="input1" type="text" />'
        $label = $ '<label>label_text</label>'
        $.InField.link($input, $label)
        expect($label.attr('for')).not.toBeUndefined()
        expect($label.attr('for')).toEqual($input.attr('id'))
        expect($label.attr('for')).toEqual('input1')

    describe '::wrap', ->
      it 'must wrap the label and input element in a div when the input is inside the label', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_parent_label()
        $.InField.wrap($input, $label)
        expect($input.parent()).toBe("div.#{ $.in_field.klass }")
        expect($input.parent().find('label:first')[0]).toEqual($label[0])
        expect($input.prev()).toBe('label')

      it 'must wrap the label and input element in a div when the input is outside the label', ->
        [ $input, $label ] = set_fixtures_for_linking_input_and_non_parent_label()
        $.InField.wrap($input, $label)
        expect($input.parent()).toBe("div.#{ $.in_field.klass }")
        expect($input.parent().find('label:first')[0]).toEqual($label[0])
        expect($input.prev()).toBe('label')

    describe '::mark_as_toggled', ->
      it 'must set the data-toggle for the input', ->
        $input = $ '<input type="text" />'
        $.InField.mark_as_toggled($input)
        expect($input.attr('data-toggle')).toEqual($.in_field.klass)

    describe '::has_value', ->
      it 'must return true if input has value', ->
        e = { keyCode: 32, target: '<input type="text" value="something" />' }
        expect($.InField.has_value(e)).toBeTruthy()

      it 'must return true if input has no value but user starts to type', ->
        e = { keyCode: 32, target: '<input type="text" />' }
        expect($.InField.has_value(e)).toBeTruthy()

      it 'must return not true if input has no value and user is not typing', ->
        e = { keyCode: 31, target: '<input type="text" />' }
        $input = $ '<input type="text" />'
        expect($.InField.has_value(e)).not.toBeTruthy()
        e = { target: '<input type="text" />' }
        expect($.InField.has_value(e)).not.toBeTruthy()

    describe '::render', ->
      it 'must add focus to the target element', ->
        expect(1).toEqual 0
