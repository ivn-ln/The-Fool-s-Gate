extends Control

@export var bg_pan_speed: float = 10.0

func _ready() -> void:
	Audio.play(Audio.Tracks.MENU)

func _process(delta: float) -> void:
	$TarotBg.position.x += bg_pan_speed * delta

func _on_play_pressed() -> void:
	Audio.stop()
	SceneTransitioner.change_scene_to_file("res://Scenes/Test/test.tscn")

func _on_h_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
