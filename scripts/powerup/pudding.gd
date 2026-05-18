extends Area2D
@onready var FoodAnimate: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export_enum("speed", "jump", "dash")
var effect_type: String
@export var sugar_amount: int = 10
var is_collected: bool = false

signal collected(effect_type,sugar_amount)

var orignal_position: Vector2

func _ready() -> void:
	orignal_position = global_position

func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return
	is_collected = true
	emit_signal("collected", effect_type,sugar_amount)
	collected_sound.play()
	FoodAnimate.play("collected")
	call_deferred("_disable_collision")

func _disable_collison() -> void:
		collision_shape.disabled = true


func _on_animated_sprite_2d_animation_looped() -> void:
	if FoodAnimate.animation == "collected":
		FoodAnimate.stop()
		hide()
		_start_respawn_timer()

func _start_respawn_timer() -> void:
	await get_tree().create_timer(7.0).timeout
	respawn()

func respawn() -> void:
	is_collected = false
	global_position = orignal_position
	collision_shape.disabled = false
	FoodAnimate.play("default")
	show()
