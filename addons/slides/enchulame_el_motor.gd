@tool
extends Control

@onready var label = $Label

func entrar():
	label.rotation = 0.0
	label.position.y = -1000
	create_tween().tween_property(
		label,
		"position:y",
		0.0,
		2.0
	).from(-1000).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	create_tween().tween_property(
		label,
		"rotation",
		PI / 20,
		0.5
	).set_delay(1.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
