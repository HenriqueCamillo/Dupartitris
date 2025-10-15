class_name PieceHolder
extends CenterAnchoredGrid

const _SPAWN_POSITION := Vector2i(2, 1)

var _held_piece: Piece

func _calculate_spawn_position() -> void:
    @warning_ignore("integer_division")
    _spawn_position = _SPAWN_POSITION

func swap_piece(new_piece: Piece) -> Piece:
    var previously_stored_piece = _held_piece
    _hold_piece(new_piece)
    return previously_stored_piece

func _hold_piece(piece: Piece) -> void:   
    _held_piece = piece
    _held_piece.add_to_grid_in_position(self, _spawn_position)
    _held_piece.try_reset_rotation()

func reset() -> void:
    super.reset();

    if _held_piece != null:
        _held_piece.queue_free()
        _held_piece = null
