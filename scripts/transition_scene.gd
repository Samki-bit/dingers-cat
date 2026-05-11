extends CanvasLayer

@onready var overlay = $ColorRect
@onready var label = $ColorRect/Label
@onready var cat_sprite: AnimatedSprite2D = $ColorRect/AnimatedSprite2D
var cat_move_x := false
var cat_move_y := false


func _ready():
	overlay.modulate.a = 0
	label.visible = false
	cat_sprite.visible = false
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE



func _process(delta):
	
	# Move cat across screen while loading
	if cat_sprite.visible:
		if cat_move_x:
			cat_sprite.position.x += 150 * delta
			# Loop cat back to left when it goes off screen
			if cat_sprite.position.x > 1350:
				cat_sprite.position.x = -100
		if cat_move_y:
			cat_sprite.position.y -= 150 * delta
			# Loop cat back to left when it goes off screen
			if cat_sprite.position.y > 1350:
				cat_sprite.position.y = -100
			if cat_sprite.position.y < -100:
				cat_sprite.position.y = 1350

func transition_to(path: String):
	# Show cat and start walking animation
	cat_move_x = true
	cat_sprite.visible = true
	cat_sprite.play("alive_walk_right")
	
	label.visible = true
	if label.visible:
		var dots = ".".repeat(int(Time.get_ticks_msec() / 300) % 4)
		label.text = "Mad sceintist has got you good!
		escape the box" + dots
	# Fade to black
	await fade_in()
	await get_tree().create_timer(2.0).timeout
	
	# Change scene
	get_tree().change_scene_to_file(path)
	
	# Fade back out
	await fade_out()
	
	# Hide everything
	label.visible = false
	cat_sprite.visible = false

func transition_to_next_level(path: String):
	# Show cat and start walking animation
	cat_move_x = true
	cat_sprite.visible = true
	cat_sprite.play("alive_walk_right")
	
	label.visible = true
	if label.visible:
		var dots = ".".repeat(int(Time.get_ticks_msec() / 300) % 4)
		label.text = "Meow Meow" + dots
	# Fade to black
	await fade_in()
	await get_tree().create_timer(2.0).timeout
	
	# Change scene
	get_tree().change_scene_to_file(path)
	
	# Fade back out
	await fade_out()
	
	# Hide everything
	label.visible = false
	cat_sprite.visible = false
	
func death_reset():
	# Show cat and start walking animation
	cat_move_y = true
	cat_move_x = false
	cat_sprite.visible = true
	cat_sprite.play("transition_to_dead")
	$Sprite2D.visible = true
	
	await observer_scare()
	label.visible = true
	label.text = "Foolish Cat"
	
	# Fade to black
	overlay.color = Color(0.15, 0, 0)
	await fade_in_death()
	await get_tree().create_timer(2.0).timeout
	$Sprite2D.visible = false
	# Change scene
	get_tree().reload_current_scene()
	
	# Fade back out
	await fade_out_death()
	
	# Hide everything
	label.visible = false
	cat_sprite.visible = false
	
	
func observer_scare():

	$Sprite2D.position.y = -300

	var tween = create_tween()

	tween.tween_property(
		$Sprite2D,
		"position:y",
		-20,
		0.9
	)

	tween.tween_property(
		$Sprite2D,
		"position:y",
		-40,
		0.15
	)

	await tween.finished

func fade_in_death():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 2.5)
	await tween.finished

func fade_out_death():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 2.5)
	await tween.finished
	
func fade_in():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 1.2)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 1.2)
	await tween.finished
