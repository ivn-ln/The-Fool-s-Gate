extends Sprite2D

signal pressed

@export var disabled: bool = false

func _on_button_pressed() -> void:
	if disabled: return
	$AnimationPlayer.play("press")
	pressed.emit()
