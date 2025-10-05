class_name TGrid
extends Node2D

@export var border: Sprite2D
@export var background: Sprite2D

var _grid: Array[Block]
var _origin_position: Vector2
		
func _ready() -> void:
	_initialize_grid_array()
	_setup_visuals()
	_calculate_origin_position()
	
func _initialize_grid_array() -> void:
	var size = GridSettings.GRID_SIZE
	var number_of_positions = size.x * size.y
	_grid.resize(number_of_positions)

func _setup_visuals() -> void:
	var grid_shape = GridSettings.GRID_SIZE
	background.position.y = -(grid_shape.y / 2) * GridSettings.BLOCK_SIZE
	background.region_rect = Rect2(Vector2.ZERO, grid_shape * GridSettings.BLOCK_SIZE)
	
	var border_shape = grid_shape + Vector2i(2, 2)
	border.region_rect = Rect2(Vector2.ZERO, border_shape * GridSettings.BLOCK_SIZE)
	border.position.y = background.position.y
	
func _calculate_origin_position() -> void:
	_origin_position = GridSettings.GRID_SIZE * GridSettings.BLOCK_SIZE
	_origin_position *= -1
	_origin_position.x /= 2
	
func get_origin_position() -> Vector2:
	return _origin_position
	
		
@warning_ignore("shadowed_variable_base_class")
func _array_index(position: Vector2i) -> int:
	return position.y * GridSettings.GRID_SIZE.y + position.x

#func position_piece_on_grid(piece: Piece, grid_position: Vector2i = GridSettings.INITIAL_POSITION) -> void:
	#piece.position = 

func place_piece_on_grid(piece: Piece) -> void:
	for block in piece.blocks:
		place_block_on_grid(block)
	
	piece.queue_free()
	
func place_block_on_grid(block: Block) -> void:
	block.detach_from_piece()
	self.add_child(block)
	# block.recalculate_position()
	
func is_empty(grid_position: Vector2i) -> bool:
	return _grid[_array_index(grid_position)] == null
	
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
