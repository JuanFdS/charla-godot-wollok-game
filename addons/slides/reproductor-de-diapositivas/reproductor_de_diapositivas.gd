@tool
class_name ReproductorDeDiapositivas extends Control

const DIAPOSITIVAS = preload("res://addons/slides/diapositivas.tscn")

var diapositivas
var diapositiva_actual: int :
	set(nueva_diapositiva_actual):
		diapositiva_actual = nueva_diapositiva_actual
		if(diapositivas):
			diapositivas.diapositiva_actual = nueva_diapositiva_actual
	get():
		if(diapositivas):
			return diapositivas.diapositiva_actual
		else:
			return 0

func _ready():
	diapositivas = DIAPOSITIVAS.instantiate()
	diapositivas.diapositiva_actual = diapositiva_actual
	var diapositivas_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	diapositivas.z_index = 150
	#diapositivas.scale.x = DisplayServer.screen_get_size(0).x / diapositivas_size.x
	#diapositivas.scale.y = DisplayServer.screen_get_size(0).y / diapositivas_size.y
	#diapositivas.size = DisplayServer.screen_get_size(0)
	add_child(diapositivas)

func is_action_pressed(action):
	return InputMap.has_action(action) and Input.is_action_just_pressed(action)

func _process(delta):
	if is_action_pressed("avanzar"):
		diapositivas.avanzar()
	if is_action_pressed("retroceder"):
		diapositivas.retroceder()
	if is_action_pressed("accion_primaria"):
		diapositivas.accion_primaria()
	if is_action_pressed("accion_secundaria"):
		diapositivas.accion_secundaria()
	if is_action_pressed("accion_terciaria"):
		diapositivas.accion_terciaria()
