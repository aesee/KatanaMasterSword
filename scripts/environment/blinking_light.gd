extends OmniLight3D

@onready var counter : float = 0
@export var enabled : bool = true

func _ready():
	set_process(enabled)

func _process(delta):
	counter -= delta
	if counter <= 0:
		visible = !visible
		counter = randf_range(0.1, 1.0)
