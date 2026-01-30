extends HSlider



func _on_value_changed(value: float) -> void:
	match value:
		0.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR1".visible = true
		1.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR2".visible = true
		2.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR3".visible = true
		3.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR4".visible = true
		4.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR5".visible = true
		5.0:
			for child in $"../FR".get_children():
				child.visible = false
			
			$"../FR/FR6".visible = true
