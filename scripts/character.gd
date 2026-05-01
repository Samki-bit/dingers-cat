extends CharacterBody2D
enum PlayerState {
	ALIVE,
	DEAD
}
#ALIVE 
const ALIVE_SPEED: int = 50
const DASH_SPEED: int = 200
#DEAD 
const DEAD_SPEED: int = 70

#PLAYING
var player_state = PlayerState.ALIVE
var speed: int = ALIVE_SPEED
var direction: Vector2
var x: int = 0
var is_dashing: bool = false
var is_walking: bool = false
var is_transitioning: bool = false  

@onready var dash_timer: Timer = $DashTimer
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if is_transitioning:
		velocity = Vector2.ZERO
		move_and_slide()

	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()
	if Input.is_action_just_pressed("switch"):
		switch_state()
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if is_dashing:
		velocity = direction * DASH_SPEED if direction != Vector2(0,0) else velocity
	else:
		velocity = direction * speed
	handle_animation()
	move_and_slide()

func handle_animation() -> void:
	if is_transitioning:
		if animation.animation == "transition_to_dead" or animation.animation == "transition_to_alive":
			if animation.frame == animation.sprite_frames.get_frame_count(animation.animation) - 1:
				is_transitioning = false
				if player_state == PlayerState.ALIVE:
					player_state = PlayerState.DEAD
					enter_dead_state()
				else:
					player_state = PlayerState.ALIVE
					enter_real_state()
		return 
	if player_state == PlayerState.ALIVE:
		handle_state_animaiton("alive")
	else:
		handle_state_animaiton("dead")


func handle_state_animaiton(state):
	animation.flip_v = direction.y < 0

	if direction.x != 0:
		animation.flip_h = direction.x < 0
	if direction.y != 0:
		animation.flip_v = direction.y > 0

	if is_dashing:
		if direction == Vector2.LEFT or direction == Vector2.RIGHT:
			animation.play(state + "_dash_sideways")
		else:
			animation.play(state + "_dash_updown")
	elif direction == Vector2.ZERO:
		animation.play(state + "_idle")
	elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
		animation.play(state + "_walk_sideways")
	else:
		animation.play(state + "_walk_updown")
	
func switch_state():
	if is_transitioning:
		return
	is_transitioning = true
	if player_state == PlayerState.ALIVE:
		animation.play("transition_to_dead")
	else:
		animation.play("transition_to_alive")

func start_dash():
	is_dashing = true
	dash_timer.start()

func _on_dash_timer_timeout():
	is_dashing = false

func enter_dead_state():
	speed = DEAD_SPEED

func enter_real_state():
	speed = ALIVE_SPEED
