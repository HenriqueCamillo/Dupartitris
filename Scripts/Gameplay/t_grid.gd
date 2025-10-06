class_name TGrid
extends Node2D

const BLOCK_SIZE: float = 10

@export var _size := Vector2i(10, 20)

@export var _border: Sprite2D
@export var _background: Sprite2D

var _grid: Array[Block]
var _origin_position: Vector2

var spawn_position: Vector2:
	get:
		@warning_ignore("integer_division")
		return Vector2i(_size.x / 2, 0)
		
func _ready() -> void:
	_initialize_grid_array()
	_setup_visuals()
	_calculate_origin_position()
	
func _initialize_grid_array() -> void:
	var number_of_positions = _size.x * _size.y
	_grid.resize(number_of_positions)

func _setup_visuals() -> void:
	var grid_shape = _size
	_background.position.y = -(grid_shape.y / 2) * BLOCK_SIZE
	_background.region_rect = Rect2(Vector2.ZERO, grid_shape * BLOCK_SIZE)
	
	var border_shape = grid_shape + Vector2i(2, 2)
	_border.region_rect = Rect2(Vector2.ZERO, border_shape * BLOCK_SIZE)
	_border.position.y = _background.position.y
	
func _calculate_origin_position() -> void:
	_origin_position = _size * BLOCK_SIZE
	_origin_position *= -1
	_origin_position.x /= 2
	
func get_origin_position() -> Vector2:
	return _origin_position
		
func _array_index(grid_position: Vector2i) -> int:
	return grid_position.y * _size.x + grid_position.x

func place_piece(piece: Piece) -> void:
	for block in piece.blocks:
		place_block(block)
	
	piece.queue_free()
	
func place_block(block: Block) -> void:
	block.detach_from_piece()
	self.add_child(block)
	_grid[_array_index(block._grid_position)] = block
	
func is_empty(grid_position: Vector2i) -> bool:
	if is_out_of_bounds(grid_position):
		return false
		
	return _grid[_array_index(grid_position)] == null
	
func apply_horizontal_index_loop(grid_position: Vector2i):
	var x = grid_position.x
	if x < 0:
		@warning_ignore("integer_division")
		x += ((-x / _size.x) + 1) * _size.x

	grid_position.x = x % _size.x
	return grid_position

# Never gets out of bounds horizontally because it should teleport. Just remember to use apply_horizontal_index_loop when applying position
func is_out_of_bounds(grid_position: Vector2i) -> bool:
	return grid_position.y >= _size.y
