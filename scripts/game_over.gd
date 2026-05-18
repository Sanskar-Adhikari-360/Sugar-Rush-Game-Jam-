extends Control
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Label, "theme_override_colors/font_color", Color.RED, 2.0)
	tween.tween_property($Label2, "theme_override_colors/font_color", Color.WHITE, 2.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
