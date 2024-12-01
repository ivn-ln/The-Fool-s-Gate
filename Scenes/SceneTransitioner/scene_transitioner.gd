extends Node


signal trans_finished


var current_scene: Node
var current_scene_path: String
var next_scene: Node
@onready var scene_container_1: Node2D = $SceneContainer1
@onready var scene_container_2: Node2D = $SceneContainer2
@onready var canvas_layer_1: CanvasLayer = $SceneContainer1/CanvasLayer
@onready var canvas_layer_2: CanvasLayer = $SceneContainer2/CanvasLayer
@onready var curtain: ColorRect = $CanvasLayer/Curtain
var transition_in_process: bool = false


func _ready() -> void:
	var starting_scene: Node = get_tree().current_scene
	if starting_scene != null:
		starting_scene.get_parent().call_deferred("remove_child", starting_scene)
		await starting_scene.tree_exited
		if starting_scene is Control:
			canvas_layer_1.add_child(starting_scene)
		else:
			scene_container_1.add_child(starting_scene)
		current_scene = starting_scene
		current_scene_path = current_scene.scene_file_path


func change_scene_to_file(path: String) -> void:
	if transition_in_process:
		return
		await trans_finished
	transition_in_process = true
	get_tree().paused = true
	print("path =", path)
	next_scene = load(path).instantiate()
	current_scene_path = path
	transition()


func reload_current_scene() -> void:
	if current_scene_path != "":
		change_scene_to_file(current_scene_path)


func add_new_scene() -> void:
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	if next_scene is Control:
		canvas_layer_1.add_child(next_scene)
	else:
		scene_container_1.add_child(next_scene)
	current_scene = next_scene
	next_scene = null
	

func transition() -> void:
	var animation_tween: Tween = create_tween()
	var animation_duration: float = 1.0
	curtain.modulate = Color.TRANSPARENT
	animation_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	animation_tween.tween_property(curtain, "modulate", Color.WHITE, animation_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await animation_tween.finished
	add_new_scene()
	var second_tween: Tween = create_tween()
	second_tween.tween_property(curtain, "modulate", Color.TRANSPARENT, animation_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(animation_duration-0.5).timeout
	get_tree().paused = false
	transition_in_process = false
	trans_finished.emit()