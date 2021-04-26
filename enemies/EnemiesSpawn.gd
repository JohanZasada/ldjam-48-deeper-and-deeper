extends Spatial

export var delay = 5.0

export var freq_max = 12.0
export var freq_min = 5.0
export var freq_step = 0.2

export var nb_min = 2.0
export var nb_max = 13.0
export var nb_step = 0.2

export var autostart = true
export var autorestart = true

var current_freq = 0.0
var current_nb = 0.0

const MAX_ENEMIES = 150

onready var _Enemy = preload("res://enemies/Enemy.tscn")
onready var _Timer = $Timer
onready var _EnemiesContainer = get_tree().get_root().get_node("Main/Enemies")
onready var _Positions = $Positions.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	current_freq = freq_max
	current_nb = nb_min

	if autostart:
		_Timer.start(delay)

func spawn():
	var rest_enemies = max(MAX_ENEMIES - _EnemiesContainer.get_child_count(), 0)
	var spawn_nb = round(current_nb)
	if spawn_nb > rest_enemies:
		spawn_nb = rest_enemies

	for i in range(spawn_nb):
		var en = _Enemy.instance()
		_EnemiesContainer.add_child(en)
		en.global_transform.origin = global_transform.origin + _Positions[i % _Positions.size()].translation
	
	current_freq -= freq_step
	if current_freq < freq_min:
		current_freq = freq_min

	current_nb += nb_step
	if current_nb > nb_max:
		current_nb = nb_max
	
	if autorestart:
		_Timer.start(current_freq)


func _on_Timer_timeout():
	spawn()
