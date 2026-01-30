extends Node2D

var can_click := true

func change_can_click(boolean):
	can_click = boolean

func _can_click():
	return can_click

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BG.visible = true
	$Clouds.visible = true
	
	$Plane/Plane/AnimationPlayer.play("flying")
	$Title/AnimationPlayer.play("Idle")
	$Click/AnimationPlayer.play("move")
