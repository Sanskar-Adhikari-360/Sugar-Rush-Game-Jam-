extends Node2D


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
			pudding.collected.connect(message)

func message() -> void:
	print("Pudding found")
