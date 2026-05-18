extends Node2D
@onready var player = $LevelRoot/Player
@onready var label: Label = $TimerContainer/TimePanel/Label

var level: int = 1
var current_level_root: Node = null

var elapsed_time: float = 0.0
var timer_running: bool = false

func _process(delta: float) -> void:
	if timer_running:
		elapsed_time += delta
		var minutes := int(elapsed_time) / 60
		var seconds := int(elapsed_time) % 60
		var milliseconds := int(fmod(elapsed_time, 1.0) * 100)
		label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup the level
	current_level_root = get_node("LevelRoot")
	load_level(level)

func load_level(level_number:int) -> void:
	if current_level_root:
		current_level_root.queue_free()
	#change the level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	# update player reference
	player = current_level_root.get_node("Player")
	_setup_level(current_level_root)

func _setup_level(level_root: Node) -> void:
	elapsed_time = 0.0   # reset for each new level
	timer_running = true  # start counting
	# connect exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	# connect food
	var food = level_root.get_node_or_null("Food")
	if food:
		for pudding in food.get_children():
			if pudding.has_signal("collected"):
				pudding.collected.connect(_on_food_collected)

func message() -> void:
	print("Pudding found")

func _on_food_collected(effect_type: String, sugar: int) -> void:
	player.apply_effect(effect_type, sugar)

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		timer_running = false  # stop the clock
		level += 1
		body.can_move = false
		call_deferred("load_level", level)
