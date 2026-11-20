extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DIGGING_RANGE = 75.0

var is_digging
signal digging

func _physics_process(delta: float) -> void:
	
	if is_digging:
		if position.distance_to(get_global_mouse_position()) < DIGGING_RANGE:
			digging.emit(get_global_mouse_position())
	
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "idle"
	else:
		animated_sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		is_digging = true
		get_viewport().set_input_as_handled()
	
	if event.is_action_released("action"):
		is_digging = false
		get_viewport().set_input_as_handled()
