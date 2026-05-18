extends Control
@onready var label: Label = $Label


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Label, "theme_override_colors/font_color", Color.RED, 2.0)
	tween.tween_property($Label2, "theme_override_colors/font_color", Color.WHITE, 2.5)
	await tween.finished
	_wait_for_input()

func _wait_for_input() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_anything_pressed():
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			return
