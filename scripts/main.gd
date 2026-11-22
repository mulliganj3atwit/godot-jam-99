extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var timer_text: Label = $Player/UI/Control/TimerPanel/TimerText
@onready var timer: Timer = $Player/Timer

var time_left: int = 0
var start_time: int = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_left = start_time
	timer.timeout.connect(_on_timer_timeout)
	_update_label()
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_digging(mouse_pos: Vector2):
	var tile_pos = tile_map_layer.local_to_map(tile_map_layer.to_local(mouse_pos))
	var tile_dat = tile_map_layer.get_cell_tile_data(tile_pos)
	
	if tile_dat:
		if tile_dat.get_custom_data("Digable"):
			print("Digging ", tile_pos)
			var health = tile_dat.get_custom_data("Health")
			tile_dat.set_custom_data("Health", health - 1)
			await get_tree().create_timer(1.5).timeout
			if tile_dat.get_custom_data("Health") <= 0:
				tile_map_layer.erase_cell(tile_pos)

func _update_label() -> void:
	var total_secs: int = max(time_left, 0)
	var minutes: int = total_secs / 60
	var seconds: int = total_secs % 60
	timer_text.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	time_left -= 1
	_update_label()
	
	if time_left <= 0:
		timer.stop()
		_on_countdown_finished()
		
func _on_countdown_finished() -> void:
	pass
