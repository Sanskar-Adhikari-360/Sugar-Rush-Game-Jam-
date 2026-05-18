extends Area2D
@onready var player: CharacterBody2D = $"../Player"

@onready var timer: Timer = $Timer



func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	player.take_damage()
	timer.start()


func _on_timer_timeout() -> void:
	if player.HP <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		player.respawn()      
		print("NOT DEAD YET")
