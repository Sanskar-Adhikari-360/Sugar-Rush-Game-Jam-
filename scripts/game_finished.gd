extends Control
@onready var image_1: TextureRect = $Image1


@onready var game_finished_2: Label = $GameFinished2

var level1Time: String = "00:00:00"
var level2Time: String = "00:00:00"
var level3Time: String = "00:00:00"

func _ready() -> void:
	#game = get_tree().get_first_node_in_group("game")
	var tween = create_tween()
	tween.tween_property($Image1,"modulate:a",0.0,2.0)
	displayData()

func displayData() -> void:
	level1Time = Global.get_time(1)
	level2Time = Global.get_time(2)
	level3Time = Global.get_time(3)
	game_finished_2.text = "Level 1: " + str(level1Time) + "\nLevel 2: " + str(level2Time) + "\nLevel 3: " + str(level3Time)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
