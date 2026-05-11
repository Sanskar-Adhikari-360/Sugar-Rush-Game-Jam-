extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var dash_timer: Timer = $DashTimer

var SPEED = 300.0
const DASH_SPEED = 1000.0
var JUMP_VELOCITY = -800.0
var is_dashing = false
var can_dash = false # only active when player collects the dash poweup
var GRAVITY := 2000
var  FALL_GRAVITY := 4500

# Player states defined
var PlayerState = {
	idle = true,
	running = false
}

func get_gravityy(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY 
	return FALL_GRAVITY


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravityy(velocity) * delta
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	# Handle dash
	var SPEED = DASH_SPEED if is_dashing else SPEED
	if Input.is_action_just_pressed("Dash") and can_dash and not is_dashing:
		apply_effect("dash")

		


		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# State declaration
	if velocity.x > 1 or velocity.x < -1:
		PlayerState.idle = false
		PlayerState.running = true
	else:
		PlayerState.idle = true
		PlayerState.running = false
	
	# Add animation
	if PlayerState.idle:
		animate.play("idle")
	
	if PlayerState.running:
		animate.play("move")
	
	# To flip the animation
	if direction == 1.0:
		animate.flip_h = false
	elif direction == -1.0:
		animate.flip_h = true
		
	move_and_slide()
	
	
	# applying effect
	
func apply_effect(effect_type: String) -> void:
	match effect_type:
		"speed":
			SPEED += 200
			await get_tree().create_timer(5.0).timeout
			SPEED -= 200
		"jump":
			JUMP_VELOCITY -= 200
			await get_tree().create_timer(5.0).timeout
			JUMP_VELOCITY += 200
			print("big jump")
		"dash":
			print("Dash powerup collected!")
			can_dash = true
			start_dash()
			# Powerup lasts 5 seconds
			await get_tree().create_timer(5.0).timeout
			can_dash = false
			print("Dash powerup ended")

func start_dash():
	is_dashing = true
	$DashTimer.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
