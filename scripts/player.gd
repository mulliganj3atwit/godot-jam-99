extends CharacterBody2D

@export var drill: PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_mount: Marker2D = $WeaponMount

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DIGGING_RANGE = 75.0
const DRILL_OFFSET = 15.0

var is_digging: bool = false
var current_drill: Node2D = null
signal digging(target_pos: Vector2)

func _physics_process(delta: float) -> void:
	
	if is_digging and current_drill != null:
		var mouse_pos := get_global_mouse_position()
		var dir := global_position.direction_to(mouse_pos)
		
		weapon_mount.position = dir * DRILL_OFFSET
		weapon_mount.rotation = dir.angle()
		
		current_drill.scale.y = -1.0 if get_global_mouse_position().x < global_position.x else 1.0
		
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
		_equip_drill(drill)
		get_viewport().set_input_as_handled()
	
	if event.is_action_released("action"):
		is_digging = false
		_unequip_drill()
		get_viewport().set_input_as_handled()
		

func _equip_drill(new_drill: PackedScene = drill) -> void:
	if new_drill == null or current_drill != null:
		return
	current_drill = new_drill.instantiate()
	weapon_mount.add_child(current_drill)
	
func _unequip_drill() -> void:
	if current_drill != null:
		current_drill.queue_free()
		current_drill = null
