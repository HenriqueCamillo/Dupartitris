class_name Block
extends Node2D

const _HALF_BLOCK_OFFSET := Vector2(GridSettings.BLOCK_SIZE / 2, GridSettings.BLOCK_SIZE / 2)

var _parent_piece: Piece
var _grid_position: Vector2i
var grid_origin_position: Vector2

@warning_ignore("unused_signal")
signal on_detach(block: Block)

func attach_to_piece(piece: Piece) -> void:
	var parent = get_parent()
	if parent != piece:
		parent.remove_child(self)
		_parent_piece.add_child(self)
		
	_parent_piece = piece
	recalculate_position()

func detach_from_piece() -> void:
	_parent_piece = null
	_parent_piece.remove_child(self)
	recalculate_position()

func set_grid_position(grid_position: Vector2i) -> void:
	_grid_position = grid_position
	recalculate_position()

func recalculate_position() -> void:
	var world_position = _grid_position * GridSettings.BLOCK_SIZE + _HALF_BLOCK_OFFSET + grid_origin_position
	if _parent_piece != null:
		position = world_position - _parent_piece.position
	else:
		position = world_position
