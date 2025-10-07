class_name Piece
extends Node2D

const BLOCKS_PER_PIECE: int = 4

@export var blocks: Array[Block]

var _piece_data: PieceData
var _grid_position: Vector2i

var _grid: TGrid

var _current_rotation := Enums.Rotation.DEGREES_0:
	set(value):
		if _current_rotation == value:
			return
			
		_current_rotation = value
		_update_blocks_positions()

		
func setup(piece_data: PieceData, grid: TGrid) -> void:
	if piece_data.variants <= 0:
		push_error("Setting up Piece with Piece Data with 0 position variants (%s)." % piece_data.resource_name)
		return
	
	_piece_data = piece_data
	_grid = grid

	_setup_blocks()
	_update_blocks_positions()

func _setup_blocks() -> void:
	for block in blocks:
		block.setup(_grid)
		block.attach_to_piece(self)
		block.on_detach.connect(_on_block_detached)

func _on_block_detached(block: Block) -> void:
	for i in range(0, blocks.size() - 1):	
		if blocks[i] == block:
			blocks.remove_at(i)
			break

	block.on_detach.disconnect(_on_block_detached)

func set_grid_position(grid_position: Vector2i):
	_grid_position = _grid.apply_horizontal_index_loop(grid_position)
	position = _grid.get_position_in_grid(_grid_position)
	_update_blocks_positions()

func _get_blocks_offsets(piece_rotation: Enums.Rotation = _current_rotation) -> Array[Vector2i]:
	return _piece_data.get_blocks_positions(piece_rotation)

func _update_blocks_positions() -> void:
	for i in range(BLOCKS_PER_PIECE):
		var block_offsets = _get_blocks_offsets()
		blocks[i].set_grid_position(_grid_position + block_offsets[i])
	
func try_rotate_clockwise() -> bool:
	return try_rotate(_current_rotation + 1)

func try_rotate_counterclockwise() -> void:
	return try_rotate(_current_rotation - 1)

func try_rotate(rotation_index: int) -> bool:
	var new_rotation = _get_rotation_from_index(rotation_index)
	if _current_rotation == new_rotation:
		return true

	if !can_rotate_to(new_rotation):
		return false

	_current_rotation = new_rotation
	return true
	
@warning_ignore("shadowed_variable_base_class")
func _get_rotation_from_index(rotation: int) -> Enums.Rotation:
	if _piece_data.variants <= 0:
		return Enums.Rotation.DEGREES_0
		
	if rotation < 0:
		@warning_ignore("integer_division")
		rotation += ((-rotation / _piece_data.variants) + 1) * _piece_data.variants
		
	return rotation % _piece_data.variants as Enums.Rotation

func can_rotate_to(piece_rotation: Enums.Rotation) -> bool:
	var block_offsets = _get_blocks_offsets(piece_rotation)
	return can_fit_with_offsets(block_offsets)

func can_fit_with_offsets(block_offsets: Array[Vector2i]) -> bool:
	for offset in block_offsets:
		var block_position = _grid.apply_horizontal_index_loop(_grid_position + offset)
		if !_grid.is_empty(block_position):
			return false
		
	return true

func can_apply_movement(offset: Vector2i) -> bool:
	for block in blocks:
		var next_position = block.get_grid_position() + offset
		next_position = _grid.apply_horizontal_index_loop(next_position)
		
		if !_grid.is_empty(next_position):
			return false

	return true

func try_move_down_one_row() -> bool:
	return try_move_down(1)

func try_move_down(height: int) -> bool:
	return try_move(Vector2i(0, height))

func try_move_sideways(sideways_offset: int) -> bool:
	return try_move(Vector2i(sideways_offset, 0))

func try_move(offset: Vector2i):
	if !can_apply_movement(offset):
		return false

	set_grid_position(_grid_position + offset)
	return true

func set_color(color: Color) -> void:
	for block in blocks:
		block.modulate = color
	
