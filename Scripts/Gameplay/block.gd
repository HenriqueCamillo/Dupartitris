class_name Block
extends Node2D

var _grid_position: Vector2i

func set_relative_grid_position(base_grid_position: Vector2i, relative_grid_position: Vector2i) -> void:
	_grid_position = base_grid_position + relative_grid_position
	position = relative_grid_position * GridSettings.BLOCK_SIZE
	
func update_position_to_new_parent(parent_grid_position: Vector2i) -> void:
	var relative_grid_position = _grid_position - parent_grid_position
	set_relative_grid_position(parent_grid_position, relative_grid_position)
