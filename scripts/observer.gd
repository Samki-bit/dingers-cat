extends Node2D

@export var starting_countdown := 30.0
@export var countdown_decrease := 15.0
@export var minimum_countdown := 30.0

@export var observer_stay_time := 15.0
@export var descend_duration := 1.0

var player

var current_countdown: float
var time_left: int

var warning_active := false

func _ready():
	player = get_tree().get_first_node_in_group("character")

	current_countdown = starting_countdown

	start_countdown_cycle()

func start_countdown_cycle():
	time_left = int(current_countdown)

	visible = false

	$Timer.wait_time = current_countdown
	$Timer.start()

	$CountdownUpdateTimer.start()

func _on_timer_timeout():
	arrive()

func arrive():
	# place observer above screen first
	$Sprite2D.position.y = -300

	visible = true

	var tween = create_tween()

	tween.tween_property(
		$Sprite2D,
		"position",
		Vector2($Sprite2D.position.x, -40),
		descend_duration
	)

	if player:
		player.can_switch_mode = false

	$CountdownUpdateTimer.stop()

	# observer stays visible
	await get_tree().create_timer(observer_stay_time).timeout

	leave()

func leave():
	var tween = create_tween()

	tween.tween_property(
		$Sprite2D,
		"position",
		Vector2($Sprite2D.position.x, -300),
		2.0
	)

	if player:
		player.can_switch_mode = true

	await tween.finished

	warning_active = false

	visible = false

	# reduce next countdown
	current_countdown -= countdown_decrease

	# prevent countdown becoming too small
	current_countdown = max(current_countdown, minimum_countdown)

	# restart cycle
	start_countdown_cycle()

func _on_countdown_update_timer_timeout() -> void:
	time_left -= 1

	# warning starts at 5 seconds
	if time_left == 5:
		warning_active = true
		start_warning_effects()

func start_warning_effects():
	var camera = get_viewport().get_camera_2d()

	if camera:
		var original_offset = camera.offset

		while warning_active:

			camera.offset = Vector2(
				randf_range(-8, 8),
				randf_range(-8, 8)
			)

			# horror flicker
			if randi() % 2 == 0:
				modulate = Color(0.5, 0.5, 0.5)
			else:
				modulate = Color(1, 1, 1)

			await get_tree().create_timer(0.08).timeout

		camera.offset = original_offset

	modulate = Color(1, 1, 1)
