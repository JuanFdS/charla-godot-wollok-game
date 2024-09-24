@tool
extends EditorPlugin

const DIAPOSITIVAS = preload("res://diapositivas.tscn")
const CONTROLES_DE_PRESENTADOR = preload("res://addons/slides/controles-de-presentador/controles_de_presentador.tscn")

var controles_de_presentador

func _enter_tree():
	controles_de_presentador = CONTROLES_DE_PRESENTADOR.instantiate()
	add_control_to_container(
		EditorPlugin.CONTAINER_TOOLBAR,
		controles_de_presentador
	)
	InputMap.add_action("avanzar")
	var input_map = {
		"avanzar": KEY_KP_6,
		"retroceder": KEY_KP_4,
		"toggle_diapositivas": KEY_KP_5,
		"accion_primaria": KEY_KP_7,
		"accion_secundaria": KEY_KP_8,
		"accion_terciaria": KEY_KP_9,
	}
	for action in input_map.keys():
		var key = input_map[action]
		var input_event = InputEventKey.new()
		input_event.echo = false
		input_event.keycode = key
		input_event.ctrl_pressed = true
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		InputMap.action_add_event(action, input_event)
	var full_screen_event = InputEventKey.new()
	full_screen_event.echo = false
	full_screen_event.keycode = KEY_ENTER
	full_screen_event.alt_pressed = true
	var full_screen_action_name = "toggle_fullscreen"
	if not InputMap.has_action(full_screen_action_name):
		InputMap.add_action(full_screen_action_name)
	InputMap.action_add_event(full_screen_action_name, full_screen_event)



func _exit_tree():
	if(controles_de_presentador):
		remove_control_from_container(
			EditorPlugin.CONTAINER_TOOLBAR,
			controles_de_presentador
		)
		controles_de_presentador.queue_free()
	[
		"avanzar",
		"retroceder",
		"toggle_diapositivas",
		"accion_primaria",
		"accion_secundaria",
		"accion_terciaria"
	].map(func(accion):
		if InputMap.has_action(accion):
			InputMap.erase_action(accion)
	)
