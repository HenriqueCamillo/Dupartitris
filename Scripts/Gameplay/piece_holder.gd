class_name PieceHolder
extends TGrid

const _SPAWN_POSITION := Vector2i(2, 1)

var _held_piece: Piece

func _setup_visuals() -> void:
    var grid_shape = _visible_size
    _background.region_rect = Rect2(Vector2.ZERO, grid_shape * BLOCK_SIZE)
    
    var border_shape = grid_shape + Vector2i(2, 2)
    _border.region_rect = Rect2(Vector2.ZERO, border_shape * BLOCK_SIZE)

func _calculate_origin_position() -> void:
    _origin_position = -(_visible_size / 2) * BLOCK_SIZE

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
