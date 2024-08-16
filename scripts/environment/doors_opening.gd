extends Node3D

@export var callback : GameScriptEvent

func _on_area_3d_body_entered(_body):
	$AnimationPlayer.play("opening")
	if callback != null:
		callback.execute()
