extends CharacterBody2D

@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var dash_timer: Timer = $DashTimer

# ── Base stats (never modify these directly — multiplier handles scaling) ──
const BASE_SPEED          : float = 300.0
const BASE_DASH_SPEED     : float = BASE_SPEED + 550
const BASE_JUMP_VELOCITY  : float = -600.0

var GRAVITY      := 2000
var FALL_GRAVITY := 4500

var is_dashing : bool = false
var can_dash   : bool = false

# ── Temporary powerup bonuses ──────────────────────────────────────────────
var speed_bonus : float = 0.0
var jump_bonus  : float = 0.0  # positive value → stronger jump (added to negative base)

# ── Sugar engine config ────────────────────────────────────────────────────
const SUGAR_THRESHOLD : float = 100.0
const MAX_EXCESS      : float = 100.0
const MULT_AT_ZERO    : float = 0.5
const MULT_AT_PEAK    : float = 1.5
const MULT_FLOOR      : float = 0.2
const MAX_PENALTY_TIME: float = 10.0

# ── Runtime state ──────────────────────────────────────────────────────────
var sugar_level   : float = 0.0
var penalty_timer : float = 0.0
var is_penalized  : bool  = false

# ── Player state ───────────────────────────────────────────────────────────
var PlayerState = { idle = true, running = false }


# ── Sugar formulas ─────────────────────────────────────────────────────────

func get_ability_multiplier() -> float:
	if sugar_level <= SUGAR_THRESHOLD:
		var t := sugar_level / SUGAR_THRESHOLD
		return lerp(MULT_AT_ZERO, MULT_AT_PEAK, t)
	else:
		var excess := sugar_level - SUGAR_THRESHOLD
		var t:= clampf(excess / MAX_EXCESS, 0.0, 1.0)
		return maxf(MULT_FLOOR, lerp(MULT_AT_PEAK, MULT_FLOOR, t))

func get_penalty_duration() -> float:
	var excess := maxf(0.0, sugar_level - SUGAR_THRESHOLD)
	return clampf(excess / 10.0, 0.0, MAX_PENALTY_TIME)

func get_speed() -> float:
	return (BASE_SPEED + speed_bonus) * get_ability_multiplier()

func get_jump_velocity() -> float:
	return (BASE_JUMP_VELOCITY - jump_bonus) * get_ability_multiplier()


# ── Sugar intake ───────────────────────────────────────────────────────────

func consume_sugar(amount: float) -> void:
	sugar_level += amount
	if sugar_level > SUGAR_THRESHOLD and not is_penalized:
		is_penalized  = true
		penalty_timer = get_penalty_duration()
		print("⚠ Sugar overload! Penalty: %.1fs" % penalty_timer)


# ── Physics ────────────────────────────────────────────────────────────────

func get_gravityy(vel: Vector2) -> int:
	return GRAVITY if vel.y < 0 else FALL_GRAVITY

func _physics_process(delta: float) -> void:

	# FIX 1: tick the penalty timer down every frame
	if is_penalized:
		penalty_timer -= delta
		if penalty_timer <= 0.0:
			is_penalized  = false
			penalty_timer = 0.0
			sugar_level   = SUGAR_THRESHOLD  # bleed back to safe threshold
			print("✓ Penalty lifted")

	var speed : float = get_speed()
	var jump  : float = get_jump_velocity()

	if not is_on_floor():
		velocity.y += get_gravityy(velocity) * delta

	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = jump / 4

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump
		jump_sound.play()

	# FIX 2: use get_dash_speed() so dash is also penalised
	var current_speed := BASE_DASH_SPEED if is_dashing else speed

	if Input.is_action_just_pressed("Dash") and can_dash and not is_dashing:
		apply_effect("dash")

	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	PlayerState.idle    = velocity.x > -1 and velocity.x < 1
	PlayerState.running = not PlayerState.idle

	animate.play("idle" if PlayerState.idle else "move")

	if direction == 1.0:
		animate.flip_h = false
	elif direction == -1.0:
		animate.flip_h = true

	move_and_slide()


# ── Effects ────────────────────────────────────────────────────────────────

func apply_effect(effect_type: String, sugar: float = 0.0) -> void:
	match effect_type:
		"speed":
			consume_sugar(sugar)
			speed_bonus = 150.0
			print("Speed boost active! Sugar: ", sugar_level)
			await get_tree().create_timer(5.0).timeout
			speed_bonus = 0.0
			print("Speed boost ended")

		"jump":
			consume_sugar(sugar)
			jump_bonus = 250.0
			print("Jump boost active! Sugar: ", sugar_level)
			await get_tree().create_timer(5.0).timeout
			jump_bonus = 0.0
			print("Jump boost ended")

		"dash":
			consume_sugar(sugar if sugar > 0.0 else 20.0)
			can_dash = true
			start_dash()
			print("Dash active! Sugar: ", sugar_level)
			await get_tree().create_timer(5.0).timeout
			can_dash = false
			print("Dash ended")


func start_dash() -> void:
	is_dashing = true
	$DashTimer.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
