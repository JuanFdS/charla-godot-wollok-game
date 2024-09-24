@tool
extends Control

const DIAPOSITIVAS = preload("res://diapositivas.tscn")

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
