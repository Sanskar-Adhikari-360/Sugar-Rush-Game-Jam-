extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

# Player states defined
var PlayerState = {
	idle = true,
	running = false
}

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

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
			print("Speed increased")
		"jump":
			print("jump boosted")
