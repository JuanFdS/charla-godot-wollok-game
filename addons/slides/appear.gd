@tool
extends Control

func accion_primaria():
	var se_hizo = await $AppearAnimation.hacer()
	print(se_hizo)
	if(not se_hizo):
		$AnimationPlayer.play("new_animation_2")

func accion_secundaria():
	if(position.y != 0):
		$AnimationPlayer.play_backwards("new_animation_2")
	else:
		await $AppearAnimation.deshacer()
