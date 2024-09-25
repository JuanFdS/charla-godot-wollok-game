@tool
class_name AppearAnimation extends Control

@export var diapositivas: Node

var node_being_animated: CanvasItem
var current_tween: Tween
@export var appear_time: float = 0.2
@export var disappear_time: float = 0.2	

func _ready():
	if diapositivas.get_parent() is ReproductorDeDiapositivas:
		get_children().map(func(x):
			x.visible = false
		)

func hacer():
	var invisible_children = get_children().filter(func(x):
		return not x.visible
	)
	if node_being_animated:
		node_being_animated.modulate.a = 1.0
		node_being_animated.visible = true
		current_tween.kill()
		node_being_animated = null
		current_tween = null
		return true
	elif invisible_children.is_empty():
		return false
	else:
		var child = invisible_children.front()
		child.visible = true
		child.modulate.a = 0.0
		node_being_animated = child
		current_tween = create_tween()
		await current_tween.tween_property(child, "modulate:a", 1.0, appear_time).finished
		current_tween = null
		node_being_animated = null
		return true

func deshacer():
	var visible_children = get_children().filter(func(x):
		return x.visible
	)
	if node_being_animated:
		node_being_animated.modulate.a = 0.0
		node_being_animated.visible = false
		current_tween.kill()
		node_being_animated = null
		current_tween = null
		return true
	elif visible_children.is_empty():
		return false
	else:
		var child = visible_children.back()
		node_being_animated = child
		current_tween = create_tween()
		await current_tween.tween_property(child, "modulate:a", 0.0, disappear_time).finished
		current_tween = null
		child.visible = false
		node_being_animated = null
		return true
