jQuery ($) ->
  describe 'InField', ->
    describe '::setup', ->
      it 'should return false if element is not supported', ->
        expect($.InField.setup($('<article />'))).toBeFalsy()

        expect($.InField.setup($('<input />'))).toBeTruthy()
        