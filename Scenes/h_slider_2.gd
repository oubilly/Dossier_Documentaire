extends HSlider



func _on_value_changed(value: float) -> void:
	match value:
		0.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ1".visible = true
		1.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ2".visible = true
		2.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ3".visible = true
		3.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ4".visible = true
		4.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ5".visible = true
		5.0:
			for child in $"../CCQ".get_children():
				child.visible = false
			
			$"../CCQ/CCQ6".visible = true
