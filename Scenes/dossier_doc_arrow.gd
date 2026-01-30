extends Sprite2D

@export var side = "right"
var mouse_in := false

func _ready() -> void:
	match side:
		"right":
			side = 1
		"left":
			side = -1
	
	if side == 1:
		await get_tree().create_timer(1).timeout
	
	$AnimationPlayer.play("pointing")

func _process(delta: float) -> void:
	if mouse_in and Input.is_action_just_pressed("click") and get_node("/root/Main")._can_click() == true:
		get_node("/root/Main").change_can_click(false)
		
		if $"../Camera2D".position.x == 4000 and side == -1:
			$"../FR".visible = true
			$"../DossierDocArrow2_right".visible = true
			$"../DossierDocArrow2_left".visible = true
		
		if $"../Camera2D".position.x == 0:
			visible = false
			$"../DossierDocArrow2_right".visible = true
			$"../DossierDocArrow2_left".visible = true
			$"../FR".visible = true
		
		if $"../Camera2D".position.x == 2000:
			$"../DossierDocArrow1".visible = true
			get_node("/root/Main/DossierDocArrow2_right").visible = false
			get_node("/root/Main/DossierDocArrow2_left").visible = false
			$"../FR".visible = false
			if side == -1:
				var tween := create_tween()
				tween.tween_property($"../Camera2D/Darken", "modulate", Color(1.0, 1.0, 1.0, 0), 1.0)
		else:
			var tween := create_tween()
			
			tween.parallel().tween_property($"../Camera2D/Darken", "modulate", Color(1.0, 1.0, 1.0, 0.698), 1.0)

		var tween1 := create_tween()

		tween1.tween_property($"../Camera2D", "position:x",
			$"../Camera2D".position.x + 2000 * side, 1.0)

		tween1.parallel().tween_property($"../Plane", "position:x",
			$"../Plane".position.x + 2000 * side, 1.0)
			

		await get_tree().create_timer(1).timeout
			
		get_node("/root/Main").change_can_click(true)


func _on_control_mouse_entered() -> void:
	mouse_in = true
func _on_control_mouse_exited() -> void:
	mouse_in = false
