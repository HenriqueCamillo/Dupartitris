class_name CenterAnchoredGrid
extends TGrid


func _setup_visuals() -> void:
    var grid_shape = _visible_size
    _background.region_rect = Rect2(Vector2.ZERO, grid_shape * BLOCK_SIZE)
    
    var border_shape = grid_shape + Vector2i(2, 2)
    _border.region_rect = Rect2(Vector2.ZERO, border_shape * BLOCK_SIZE)

func _calculate_origin_position() -> void:
    _origin_position = -(_visible_size / 2.0) * BLOCK_SIZE
