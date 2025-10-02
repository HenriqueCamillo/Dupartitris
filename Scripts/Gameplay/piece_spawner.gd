extends Node2D
class_name PieceSpawner

@export var piece_types: Array[PieceData]
@export var piece_template: PackedScene

func get_random_piece_type() -> PieceData:
	var index = randi_range(0, piece_types.size() - 1)
	return piece_types[index]

func spawn_piece() -> Piece:
	var piece_type = get_random_piece_type()
	var piece = piece_template.instantiate() as Piece
	piece.setup(piece_type)
	return piece
