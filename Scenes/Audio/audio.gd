extends Node

enum Tracks{
	MENU,
	DAY1,
	DAY2,
	ENDING
}

var current_track: AudioStreamPlayer = null

func play(track: Tracks) -> void:
	if current_track != null:
		current_track.stop()
	current_track = get_child(track)
	current_track.play()

func stop() -> void:
	current_track.stop()