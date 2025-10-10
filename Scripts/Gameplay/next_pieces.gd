class_name NextPieces
extends CenterAnchoredGrid

const _ROWS_PER_PIECE: int = 3

@export var _max_pieces_in_queue: int = 6
var _piece_queue: Array[Piece]

func _get_piece_grid_position(position_in_queue: int) -> Vector2i:
    return Vector2i(2, position_in_queue * _ROWS_PER_PIECE)

func get_queue_size() -> int:
    return _piece_queue.size()

func add_to_queue(piece: Piece) -> void:
    _piece_queue.append(piece)
    piece.add_to_grid(self)
    _set_piece_position(piece, _piece_queue.size() - 1)

func pop_from_queue() -> Piece:
    if _piece_queue.size() == 0:
        return null

    var popped_piece = _piece_queue[0]
    _piece_queue.remove_at(0)
    _refresh_pieces_positions()

    return popped_piece

func _refresh_pieces_positions() -> void:
    for i in range(_piece_queue.size()):
        _set_piece_position(_piece_queue[i], i)

func _set_piece_position(piece: Piece, position_index: int) -> void:
    piece.visible =  position_index < _max_pieces_in_queue
    if piece.visible:
        var grid_position = _get_piece_grid_position(position_index)
        piece.set_grid_position(grid_position)
