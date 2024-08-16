class_name Opponent
extends CharacterBody3D

@export var healthBar : ProgressBar
@export var cursors : Array[CharacterBody3D]
@export var initialHealth : float = 5
var health : float
var meshes : Array[MeshInstance3D]
@onready var tween : Tween
@export var power : float = 20

signal defeated

func _ready():
	_collect_meshes()	
	set_shader_value(0.0)
	health = initialHealth
	update_health_bar()

func start():
	for cursor in cursors:
		cursor.start()

func damage(amount : float):
	if GameSettings.one_hit_mode:
		amount = 99999
	animate_damage_receiving()
	health -= amount
	update_health_bar()
	if (health <= 0):
		lose_the_fight()

func lose_the_fight():
	for cursor in cursors:
		cursor.queue_free()
	defeated.emit()

func update_health_bar():
	var tw = get_tree().create_tween()
	var newHealthBarValue = health / (initialHealth * 0.01)
	tw.tween_property(healthBar, "value", newHealthBarValue, 0.25)

func animate_damage_receiving():
	if tween != null:
		return
	
	tween = get_tree().create_tween()
	var current_position = global_position
	tween.tween_property(self, "global_position", global_position - transform.basis.z * 0.15 + transform.basis.y * 0.05, 0.1)
	tween.chain().tween_property(self, "global_position", current_position, 0.05)
	await tween.finished
	tween.kill()
	tween = null

func animate_death():
	healthBar.visible = false
	var tw = get_tree().create_tween()
	tw.tween_method(set_shader_value, 0.0, 1.0, 2.0)
	return tw.finished
	
func set_shader_value(value: float):
	for mesh in meshes:
		mesh.material_override.set_shader_parameter("dissolve_amount", value);

func _collect_meshes():
	for child in get_children(true):
		if child is MeshesCollector:
			meshes.append_array(child.meshes)
