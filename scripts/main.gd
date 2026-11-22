extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var tile_map_layer: TileMapLayer = $TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
			await get_tree().create_timer(.5).timeout
			if tile_dat.get_custom_data("Health") <= 0:
				tile_map_layer.erase_cell(tile_pos)
			
