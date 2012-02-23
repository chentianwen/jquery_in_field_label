describe $.in_field_label, ->
	describe "#is_blank", ->
		context "blank", ->
			specify ->
				is_blank(null).should be_true