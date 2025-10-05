class_name PieceSpawner
extends Node2D

@export var _piece_types: Array[PieceData]
@export var _piece_template: PackedScene

func _get_random_piece_type() -> PieceData:
	var index = randi_range(0, _piece_types.size() - 1)
	return _piece_types[index]

func spawn_piece() -> Piece:
	var piece_type = _get_random_piece_type()
	var piece = _piece_template.instantiate() as Piece
	piece.setup(piece_type)
	return piece
