extends CanvasLayer

@onready var overlay = $ColorRect
@onready var label = $ColorRect/Label
@onready var cat = $ColorRect/character

# Get the AnimatedSprite2D from inside the character scene
var cat_sprite: AnimatedSprite2D = null

func _ready():
	overlay.modulate.a = 0
	label.visible = false
	cat.visible = false
	
	# Find the AnimatedSprite2D inside the character scene
	cat_sprite = cat.get_node_or_null("AnimatedSprite2D")
	if cat_sprite == null:
		print("ERROR: Could not find AnimatedSprite2D inside character scene!")

func _process(delta):
	# Animate loading dots
	if label.visible:
		var dots = ".".repeat(int(Time.get_ticks_msec() / 300) % 4)
		label.text = "Loading" + dots
	
	# Move cat across screen while loading
	if cat.visible:
		cat.position.x += 150 * delta  # walking speed
		# Loop cat back to left when it goes off screen
		if cat.position.x > 1350:
			cat.position.x = -100

func transition_to(path: String):
	# Show cat and start animation
	cat.visible = true
	if cat_sprite:
		cat_sprite.play("alive_walk_right")
	
	# Disable any physics/AI on the cat so it doesn't fall or move weirdly
	cat.set_physics_process(false)
	cat.set_process(false)
	
	label.visible = true
	
	# Fade to black
	await fade_in()
	await get_tree().create_timer(2.0).timeout
	
	# Change scene
	get_tree().change_scene_to_file(path)
	
	# Fade back out
	await fade_out()
	
	# Hide everything
	label.visible = false
	cat.visible = false
	cat.set_physics_process(true)
	cat.set_process(true)

func fade_in():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 1.2)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 1.2)
	await tween.finished
