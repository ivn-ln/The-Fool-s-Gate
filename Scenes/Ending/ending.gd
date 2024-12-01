extends Control

var dialog: DialogueResource = preload("res://Dialogues/ending.dialogue")
var balloon_packed: PackedScene = preload("res://Scenes/EndingBalloon/example_balloon.tscn")

func _ready() -> void:
	DialogueManager.show_dialogue_balloon_scene(balloon_packed, dialog, "ending")
	Audio.play(Audio.Tracks.ENDING)
	Signals.next_person.connect(func() -> void: create_tween().tween_property($TarotPaperTrans/ColorRect/Characters, "global_position", $TarotPaperTrans/ColorRect/Characters.global_position + Vector2(424, 0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD))

func _process(delta: float) -> void:
	$BG.position.x += 10 * delta