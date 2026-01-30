extends HSlider



func _on_value_changed(value: float) -> void:
	match value:
		0.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal1".visible = true
		1.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal2".visible = true
		2.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal3".visible = true
		3.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal4".visible = true
		4.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal5".visible = true
		5.0:
			for child in $"../Journal".get_children():
				child.visible = false
			
			$"../Journal/Journal6".visible = true
