extends Node2D
class_name TGrid

var grid: Array[Block]
		
func _ready() -> void:
	var size = GridSettings.GRID_SIZE
	var number_of_positions = size.x * size.y
	grid.resize(number_of_positions)
		
@warning_ignore("shadowed_variable_base_class")
func array_index(position: Vector2i) -> int:
	return position.y * GridSettings.GRID_SIZE.y + position.x

func place_piece_on_grid(piece: Piece) -> void:
	for block in piece.blocks:
		place_block_on_grid(block)
	
	piece.queue_free()
	
func place_block_on_grid(block: Block) -> void:
	block.get_parent().remove_child(block)
	self.add_child(block)
	block.set_grid_position(block.grid_position)
	
func is_empty(grid_position: Vector2i) -> bool:
	return grid[array_index(grid_position)] == null
	
func are_empty(grid_positions: Array[Vector2i]) -> bool:
	for grid_position in grid_positions:
		if !is_empty(grid_position):
			return false
	return true
	
func are_empty_relative(base_grid_position: Vector2i, grid_positions: Array[Vector2i]) -> bool:
	for grid_position in grid_positions:
		if !is_empty(base_grid_position + grid_position):
			return false
	return true 
