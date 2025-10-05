class_name Piece
extends Node2D

const BLOCKS_PER_PIECE: int = 4

@export var blocks: Array[Block]

var _piece_data: PieceData

var _current_rotation := Enums.Rotation.DEGREES_0:
	set(value):
		if _current_rotation == value:
			return
			
		_current_rotation = value
		_update_blocks_positions()

var _grid_position: Vector2i:
	set(value):
		if _grid_position == value:
			return
			
		_grid_position = value
		position = _grid_position * GridSettings.BLOCK_SIZE
		_update_blocks_positions()
		
@warning_ignore("shadowed_variable")
func setup(piece_data: PieceData) -> void:
	if piece_data.variants <= 0:
		push_error("Setting up Piece with Piece Data with 0 position variants (%s)." % piece_data.resource_name)
		return
	
	self._piece_data = piece_data
	_update_blocks_positions()

func _get_blocks_offsets() -> Array[Vector2i]:
	return _piece_data.get_blocks_positions(_current_rotation)

func _update_blocks_positions() -> void:
	for i in range(BLOCKS_PER_PIECE):
		var block_offsets = _get_blocks_offsets()
		blocks[i].set_relative_grid_position(_grid_position, block_offsets[i])
	
func rotate_clockwise() -> void:
	_set_piece_rotation(_current_rotation + 1)

func rotate_counterclockwise() -> void:
	_set_piece_rotation(_current_rotation - 1)
	
func _set_piece_rotation(rotation_index: int) -> void:
	var new_rotation = _get_rotation_from_index(rotation_index)
	if _current_rotation == new_rotation:
		return
	
	_current_rotation = new_rotation
	
@warning_ignore("shadowed_variable_base_class")
func _get_rotation_from_index(rotation: int) -> Enums.Rotation:
	if _piece_data.variants <= 0:
		return Enums.Rotation.DEGREES_0
		
	if rotation < 0:
		@warning_ignore("integer_division")
		rotation += ((-rotation / _piece_data.variants) + 1) * _piece_data.variants
		
	return rotation % _piece_data.variants as Enums.Rotation

func move_down_one_row() -> void:
	_move(Vector2i(0, 1))

func move_sideways(offset: int) -> void:
	_move(Vector2i(offset, 0))
	
func _move(offset: Vector2i) -> void:
	_grid_position += offset
	
