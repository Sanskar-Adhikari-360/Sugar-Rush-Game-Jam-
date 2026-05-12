extends Node2D
@onready var player = $LevelRoot/Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _setup_level() -> void:
	var food = $LevelRoot.get_node_or_null("Food")
	if food:
		for pudding in food.get_children():
			if pudding.has_signal("collected"):
				pudding.collected.connect(_on_food_collected)

func message() -> void:
	print("Pudding found")

func _on_food_collected(effect_type: String, sugar: int) -> void:
	player.apply_effect(effect_type, sugar)
