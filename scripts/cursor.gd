class_name Cursor
extends CharacterBody3D

enum TYPE {
	DEFAULT,
	ROTATING
}

@export var type : TYPE

enum {
	IDLE,
	WANDER
}

@export var mesh : MeshInstance3D
@export var characterCollision : CollisionShape3D
@onready var capsuleCollision : CapsuleShape3D = characterCollision.shape
@onready var characterSize : Vector2 = Vector2(capsuleCollision.radius, capsuleCollision.height / 2)

var state = IDLE
var idle_counter : float = 0.0

@onready var ACCELERATION = GameSettings.difficulty * 0.8
const TOLERANCE = 0.5

@onready var start_local_position : Vector3 = Vector3(0, 0, 1)
@onready var target_position : Vector3 = position

func update_target_position():
	var x = randf_range(-characterSize.x, characterSize.x)
	var y = randf_range(-characterSize.y, characterSize.y)
	var target_vector = Vector3(x, y, 0)
	if type == TYPE.ROTATING:
		target_vector *= 0.75
	target_position = start_local_position + target_vector

func is_at_target_position(): 
	return (target_position - position).length() < TOLERANCE

func _ready():
	if mesh != null:
		mesh.material_override.albedo_color = Color.GREEN
	set_physics_process(false)

func start():
	if mesh != null:
		mesh.material_override.albedo_color = Color.GREEN
	set_physics_process(true)

func _physics_process(delta):
	match state:
		IDLE:
			idle_counter += delta
			if (idle_counter > 0):
				state = WANDER
				update_target_position()
	
		WANDER:
			accelerate_to_point(target_position, ACCELERATION * delta)
			if is_at_target_position():
				state = IDLE
				idle_counter = randf_range(-0.1, 0)
				
	move_and_slide()	

func accelerate_to_point(point, acceleration_scalar):
	var direction = (point - position).normalized()
	position += direction * acceleration_scalar
	if type == TYPE.ROTATING:
		rotate_z(acceleration_scalar)

func change_state(cooldown : float):
	if mesh != null:
		mesh.material_override.albedo_color = Color.RED
	set_physics_process(false)
	await get_tree().create_timer(cooldown).timeout
	start()
