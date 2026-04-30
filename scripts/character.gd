extends CharacterBody2D

const SPEED: int = 50
const DASH_SPEED: int = 200
var direction: Vector2
var x: int = 0
var is_dashing = false

@onready var dash_timer: Timer = $DashTimer
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not is_dashing:
		start_dash()
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if is_dashing:
		velocity = direction * DASH_SPEED  if direction != Vector2(0,0) else velocity
	else:
			velocity = direction * SPEED
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer.start()

func _on_dash_timer_timeout():
	is_dashing = false
