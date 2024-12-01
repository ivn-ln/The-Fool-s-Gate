extends Node2D

@export var dialogue: DialogueResource
@onready var anim_plr: AnimationPlayer = $AnimationPlayer
@onready var fate_container: VBoxContainer = $Background/Layer0/Panel/Dialogue/FateContainer
@onready var person_sprite: TextureRect = $Background/Layer1/CurrentPerson/Person
@onready var mask: TextureRect = $Background/Layer1/CurrentPerson/Mask
var masks: Array = [preload("res://Sprites/tarot_mask.png"), preload("res://Sprites/tarot_sun.PNG"), preload("res://Sprites/tarot_moon.PNG"), preload("res://Sprites/tarot_crow.PNG")]
var people: Array = [preload("res://Resources/People/jester.tres"), preload("res://Resources/People/noble.tres"), preload("res://Resources/People/mistress.tres"), preload("res://Resources/People/general.tres"), preload("res://Resources/People/queen.tres")]
var people1: Array = [preload("res://Resources/People/jester.tres"), preload("res://Resources/People/noble.tres"), preload("res://Resources/People/mistress.tres"), preload("res://Resources/People/general.tres"), preload("res://Resources/People/queen.tres"), preload("res://Resources/People/masks.tres"), preload("res://Resources/People/masks.tres")]
var people2: Array = [preload("res://Resources/People/jester.tres"), preload("res://Resources/People/noble.tres"), preload("res://Resources/People/mistress.tres"), preload("res://Resources/People/general.tres"), preload("res://Resources/People/queen.tres"), preload("res://Resources/People/masks.tres"), preload("res://Resources/People/masks.tres"), preload("res://Resources/People/masks.tres"), preload("res://Resources/People/masks.tres")]
var color_palette: Array = ["111111"]
var fate_label_packed: PackedScene = preload("res://Scenes/FateLabel/fate_label.tscn")
var current_cards: Array[CardRes] = []
var last_drawn_card: int = 0
var current_person: Person = null
var current_card_idx: int = 0
var baloon: Node
var first_balloon: bool = false

func _ready() -> void:
	Signals.accepted.connect(anim_plr.play.bind("person_accepted"))
	Signals.denied.connect(anim_plr.play.bind("person_denied"))
	Signals.card_revealed.connect(reveal_fate)
	Signals.shatter.connect(func() -> void: $Background/Layer0/Shatter.visible = true; $Shatter.play(); fate_container.hide())
	Audio.play(Audio.Tracks.DAY1)
	$DayLayer/ColorRect/DayLabel.text = "Day " + str(Globals.day)
	if Globals.day == 1:
		people = people1
	elif Globals.day == 2:
		people = people2
	if Globals.day == 3:
		Audio.play(Audio.Tracks.DAY2)

func next_day() -> void:
	get_next_person()

func play_dialogue() -> void:
	if baloon:
		baloon.queue_free()
	baloon = DialogueManager.show_dialogue_balloon(dialogue, current_person.dialogue + str(Globals.day))
	if first_balloon:
		return
	for c in baloon.get_children():
		if not "modulate" in c: continue
		c.modulate = Color.TRANSPARENT
		create_tween().tween_property(c, "modulate", Color.WHITE, 0.2)
	first_balloon = true

func get_next_person() -> void:
	randomize()
	var person: Person = people.pick_random()
	if person.person_name == "masks":
		mask.show()
		mask.texture = masks.pick_random()
		masks.erase(mask.texture)
	people.erase(person)
	current_person = person
	current_card_idx = 0
	person_sprite.texture = person.sprite
	if Globals.day == 3:
		person_sprite.texture = person.sprite_corrupted
	anim_plr.play("person_appear")

func reveal_fate(idx: int = -1) -> void:
	if idx == -1:
		for c: RichTextLabelEx in fate_container.get_children():
			var tween: Tween = create_tween()
			tween.tween_method(c.material.set_shader_parameter.bind("dissolve_value"), 0, 1, 1)
	elif idx < fate_container.get_child_count():
		var tween: Tween = create_tween()
		var dissolve: float = 0
		tween.tween_property(fate_container.get_child(idx).material, "shader_parameter/dissolve_value", 1, 1)

func draw_card() -> CardRes:
	if current_person.fate1 == null:
		return null
	if current_card_idx == current_person.get("fate" + str(Globals.day)).cards.size():
		return null
	var fate: Fate = current_person.get("fate" + str(Globals.day))
	var fate_str: String = ""
	if fate.text_pieces.size() != fate.cards.size():
		printerr("Fate %s is invalid. Text amount unequal to cards amount" % fate.resource_path)
	var cards_folder: String = "res://Resources/Cards/"
	var current_palette: Array = color_palette.duplicate()
	current_cards.clear()
	last_drawn_card = 0
	var fate_label: RichTextLabelEx = fate_label_packed.instantiate()
	var text_color: String = current_palette.pick_random()
	current_palette.erase(text_color) 
	# Cards mayber should go to another label
	fate_str += "[center][color=#%s]%s[img][/img][/color]\n" % [text_color, fate.text_pieces[current_card_idx]]#, fate.cards[i].card_sprite.resource_path]
	fate_label.text = "[center][color=#%s]%s[/color][img][/img][/center]\n" % [text_color, fate.text_pieces[current_card_idx]]#, fate.cards[i].card_sprite.resource_path]
	fate_label.bbcode_enabled_deferred = true
	fate_container.add_child(fate_label)
	fate_label.material.set_shader_parameter("dissolve_value", -0.5)
	create_tween().call_deferred("tween_property" ,fate_label.material, "shader_parameter/dissolve_value", -0.15, 1)
	current_cards.append(fate.cards[current_card_idx])
	if last_drawn_card < current_cards.size():
		current_card_idx += 1
		var card: CardRes = current_cards[last_drawn_card]
		last_drawn_card += 1
		return card
	return null
	# var rand_card := load(cards_folder + DirAccess.get_files_at(cards_folder)[randi_range(0, DirAccess.get_files_at(cards_folder).size() - 1)])
	# return rand_card

func _on_rope_pressed() -> void:
	if baloon:
		baloon.queue_free()
	baloon = DialogueManager.show_dialogue_balloon(dialogue, "accepted")
	if not current_person.person_name == "masks":
		Globals.ending_status[current_person.person_name][Globals.day] = true
	flush_person()
	await get_tree().create_timer(0.5).timeout
	Signals.accepted.emit()

func _on_bell_button_pressed() -> void:
	if baloon:
		baloon.queue_free()
	Signals.denied.emit()
	baloon = DialogueManager.show_dialogue_balloon(dialogue, "denied")
	if not current_person.person_name == "masks":
		Globals.ending_status[current_person.person_name][Globals.day] = false
	flush_person()
	$Bell.play()
	await get_tree().create_timer(0.5).timeout
	$Bell.stop()
	
func flush_person() -> void:
	if not current_person:
		return
	if people.size() == 0:
		await get_tree().create_timer(3.0).timeout
		switch_day()
		return
	await anim_plr.animation_finished
	for c in fate_container.get_children():
		create_tween().call_deferred("tween_property" ,c.material, "shader_parameter/dissolve_value", -1, 1)
	$Foreground/Layer1/Table/MarginContainer/CardsContainer.flush_cards()
	await get_tree().create_timer(1.0).timeout
	for c in fate_container.get_children():
		c.queue_free()
	await get_tree().create_timer(1.0).timeout
	mask.hide()
	get_next_person()
	
func switch_day() -> void:
	Globals.day += 1
	if baloon:
		baloon.queue_free()
	if Globals.day == 4:
		SceneTransitioner.change_scene_to_file("res://Scenes/Ending/ending.tscn")
	SceneTransitioner.reload_current_scene()
