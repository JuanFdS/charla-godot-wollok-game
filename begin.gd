@tool
extends Node2D

func _ready():
	visibility_changed.connect(func():
		if(visible):
			var parent = get_parent()
			parent.cambiar_diapositiva(parent.get_child_count() - 2)
	)
