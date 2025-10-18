class_name TopAnchoredGrid
extends TGrid
  
func _setup_visuals() -> void:
    var grid_shape = _visible_size
    _background.region_rect = Rect2(Vector2.ZERO, grid_shape * Constants.BLOCK_SIZE)
    _background.position = Vector2(0, (grid_shape.y / 2.0) * Constants.BLOCK_SIZE)
    
    var border_shape = grid_shape + Vector2i(2, 2)
    _border.region_rect = Rect2(Vector2.ZERO, border_shape * Constants.BLOCK_SIZE)
    _border.position = _background.position

func _calculate_origin_position() -> void:
    _origin_position = Vector2(-(_visible_size.x / 2.0), 0.0) * Constants.BLOCK_SIZE
