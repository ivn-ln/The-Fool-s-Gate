class_name Card
extends Control

@onready var tip: Control = $Tip
@onready var sprite: TextureRect = $TextureRect
@onready var card_back: TextureRect = $CardBack
var display_name: String = "Unknow Card":
	set(value):
		$Tip/PanelContainer/MarginContainer/VBoxContainer/Name.text = value
var description: String = "There is no description for this card. Oops!":
	set(value):
		$Tip/PanelContainer/MarginContainer/VBoxContainer/Description.text = value

func set_card_sprite(sprite_: CompressedTexture2D) -> void:
	sprite.texture = sprite_

func _on_mouse_exited() -> void:
	create_tween().tween_property(tip, "modulate", Color(1, 1, 1, 0), 0.1)

func _on_mouse_entered() -> void:
	create_tween().tween_property(tip, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_rotate_pressed() -> void:
	if Globals.flips <= 0:
		return
	Globals.flips -= 1
	$Rotate.disabled = true
	$Move.pitch_scale = randf_range(0.9, 1.1)
	$Move.play()
	sprite.pivot_offset = sprite.size / 2
	card_back.pivot_offset = sprite.size / 2
	create_tween().tween_property(sprite, "rotation_degrees", 90, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	Signals.card_revealed.emit(get_index())

func _ready() -> void:
	modulate = Color.TRANSPARENT
	create_tween().tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	sprite.pivot_offset = sprite.size / 2
	card_back.pivot_offset = sprite.size / 2
	pivot_offset = size / 2
	var tween: Tween = create_tween()
	# scale = Vector2(0, 1)
	tween.tween_property(self, "custom_minimum_size", Vector2(75, 105), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# tween.parallel().tween_property(self, "scale", Vector2(1, 1), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# tween.tween_property(card_back, "scale", Vector2(0, 1), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(0.01).timeout
	tween.parallel().tween_property(sprite, "scale", Vector2(1, sprite.scale.y), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)