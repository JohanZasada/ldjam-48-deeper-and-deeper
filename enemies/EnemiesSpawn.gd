extends Spatial

export var freq_max = 12.0
export var freq_min = 5.0
export var freq_step = 0.2

export var nb_min = 1.0
export var nb_max = 13.0
export var nb_step = 0.2

var current_freq = 0.0
var current_nb = 0.0

onready var _Enemy = preload("res://enemies/Enemy.tscn")
onready var _Timer = $Timer
onready var _EnemiesContainer = get_tree().get_root().get_node("Main")
onready var _Positions = $Positions.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	current_freq = freq_max
	current_nb = nb_min

	_Timer.start(current_freq)

func spawn():
	for i in range(round(current_nb)):
		var en = _Enemy.instance()
		_EnemiesContainer.add_child(en)
		en.global_transform.origin = global_transform.origin + _Positions[i % _Positions.size()].translation
	
	current_freq -= freq_step
	if current_freq < freq_min:
		current_freq = freq_min

	current_nb += nb_step
	if current_nb > nb_max:
		current_nb = nb_max
	
	_Timer.start(current_freq)


func _on_Timer_timeout():
	spawn()
