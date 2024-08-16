extends OmniLight3D

@onready var counter : float = 0
@export var enabled : bool = true
@export var colors : Array[Color] = []

func _ready():
	set_process(enabled)

func _process(delta):
	counter -= delta
	if counter <= 0:
		light_color = colors[randi_range(0, colors.size() - 1)]
		counter = randf_range(1.0, 3.0)
