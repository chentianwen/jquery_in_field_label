jQuery ($) ->
	# debugger
	describe "in-field label", ->
		it "default_options", ->
			expect($.InFieldLabel.option_keys[0]).toEqual 'align'