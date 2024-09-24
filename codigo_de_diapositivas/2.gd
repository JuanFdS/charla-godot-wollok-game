@tool
extends Control

@onready var izquierda = $Izquierda
@onready var medio = $Medio
@onready var derecha = $Derecha
@onready var flechas = [izquierda, medio, derecha]

func _ready():
	hacer_todas_las_flechas_invisibles()

func accion_primaria():
	hacer_visible_unicamente_flecha(izquierda)

func accion_secundaria():
	hacer_visible_unicamente_flecha(medio)

func accion_terciaria():
	hacer_visible_unicamente_flecha(derecha)

func hacer_visible_unicamente_flecha(flecha):
	hacer_todas_las_flechas_invisibles()
	flecha.visible = true

func hacer_todas_las_flechas_invisibles():
	for una_flecha in flechas:
		una_flecha.visible = false
