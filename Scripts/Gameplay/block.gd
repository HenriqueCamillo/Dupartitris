extends Node2D
class_name Block

var grid_position: Vector2i

func set_relative_grid_position(base_grid_position: Vector2i, relative_grid_position: Vector2i) -> void:
	grid_position = base_grid_position + relative_grid_position
	position = relative_grid_position * GridSettings.BLOCK_SIZE
	
@warning_ignore("shadowed_variable")
func set_grid_position(grid_position: Vector2i) -> void:
	set_relative_grid_position(Vector2i.ZERO, grid_position)
