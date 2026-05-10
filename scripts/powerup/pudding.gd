extends Area2D
@onready var FoodAnimate: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal collected


func _on_body_entered(_body: Node2D) -> void:
	FoodAnimate.play("collected")
	collected_sound.play()
	collected.emit()
	call_deferred("_disable_collison")
	
func _disable_collison() -> void:
		collision_shape.disabled = true


func _on_animated_sprite_2d_animation_looped() -> void:
	if FoodAnimate.animation == "collected":
		queue_free()
