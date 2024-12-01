extends HBoxContainer

@onready var card_packed: PackedScene = preload("res://Scenes/Card/card.tscn")
@onready var deck: Control = $Deck
@onready var deck_visual: SpriteStack = $Deck/SpriteStack
@export var max_cards_amt: int = 7
@export var draw_engine: Node2D
@export var canvas: CanvasLayer
var cards: Array[Card] = []

func add_card(card_name: String = "", card_sprite: Texture = null, card_description: String = "", reversed: bool = false) -> void:
	$Deal.pitch_scale = randf_range(0.9, 1.1)
	$Deal.play()
	if cards.size() == max_cards_amt:
		return
	var card: Card = card_packed.instantiate()
	cards.append(card)
	add_child(card)
	move_child(card, cards.size() - 1)
	card.global_position = deck.global_position
	if card_sprite:
		card.set_card_sprite(card_sprite)
	card.description = card_description
	card.display_name = card_name
	print(reversed)
	print.call_deferred(card.scale)
	deck_visual.layers -= 1
	if reversed:
		card.get_node("TextureRect").scale.y = -1

func _on_deck_pressed() -> void:
	var card: CardRes = draw_engine.draw_card()
	if card != null:
		add_card(card.card_display_name, card.card_sprite, card.card_description, card.reversed)
	else:
		pass

func flush_cards() -> void:
	for c in cards:
		create_tween().tween_property(c, "modulate", Color(1, 1, 1, 0), 0.5)
	await get_tree().create_timer(0.5).timeout
	for c in cards:
		c.queue_free()
	cards.clear()