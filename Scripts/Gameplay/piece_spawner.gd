class_name PieceSpawner
extends Node2D

@export var _piece_types: Array[PieceData]
@export var _piece_template: PackedScene
@export var _pieces_colors: Dictionary[PieceData, Color]

var _grid: TGrid

func setup(grid: TGrid) -> void:
	_grid = grid

func _get_random_piece_type() -> PieceData:
	var index = randi_range(0, _piece_types.size() - 1)
	return _piece_types[index]

func spawn_piece() -> Piece:
	var piece_type = _get_random_piece_type()
	var piece = _piece_template.instantiate() as Piece
	
	piece.set_color(_pieces_colors[piece_type])
	piece.setup(piece_type, _grid)
	piece.set_grid_position(_grid.spawn_position)
	_grid.add_child(piece)
	
	return piece
