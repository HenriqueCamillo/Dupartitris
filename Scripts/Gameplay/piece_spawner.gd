class_name PieceSpawner
extends Node2D

@export var _piece_types: Array[PieceData]
@export var _piece_template: PackedScene

var _grid: TGrid

var _grid_origin_position: Vector2:
	get:
		if _grid == null:
			return Vector2.ZERO
		return _grid.get_origin_position()

func setup(grid: TGrid) -> void:
	_grid = grid

func _get_random_piece_type() -> PieceData:
	var index = randi_range(0, _piece_types.size() - 1)
	return _piece_types[index]

func spawn_piece() -> Piece:
	var piece_type = _get_random_piece_type()
	var piece = _piece_template.instantiate() as Piece
	piece.setup(piece_type, _grid_origin_position)
	piece.grid_position = GridSettings.INITIAL_POSITION
	_grid.add_child(piece)
	return piece
