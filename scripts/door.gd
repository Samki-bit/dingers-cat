extends StaticBody2D

var player = null
var is_open = false

func _ready():
	# Find the player directly — no signals needed
	player = get_parent().get_node_or_null("Player")
	
	if player == null:
		print("ERROR: Player node not found! Check it is named 'Player'")
	else:
		print("Door ready, player found!")

func _process(delta):
	if is_open or player == null:
		return
	
	# Check distance between door and player every frame
	var distance = global_position.distance_to(player.global_position)
	
	if distance < 15:  # player is close to door
		if player.has_key == true:
			print("Has key! Opening door...")
			open_door()
		else:
			print("No key! Door is locked.")

func open_door():
	is_open = true
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
