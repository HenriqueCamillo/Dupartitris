class_name Block
extends Node2D

const _HALF_BLOCK_OFFSET := Vector2(Constants.BLOCK_SIZE / 2, Constants.BLOCK_SIZE / 2)

var _parent_piece: Piece
var _grid_position: Vector2i
var _grid: TGrid

signal cleared(block: Block)

func set_grid(grid: TGrid) -> void:
    _grid = grid

func attach_to_piece(piece: Piece) -> void:
    _parent_piece = piece
    reparent(piece)

func detach_from_piece() -> void:
    _parent_piece = null
    reparent(_grid)
    recalculate_position()

func get_grid_position() -> Vector2i:
    return _grid_position

func set_grid_position(grid_position: Vector2i) -> void:
    _grid_position = _grid.apply_horizontal_index_loop(grid_position)
    recalculate_position()

func recalculate_position() -> void:
    var world_position = _grid.get_position_in_grid(_grid_position) + _HALF_BLOCK_OFFSET
    if _parent_piece != null:
        position = world_position - _parent_piece.position
    else:
        position = world_position

func move_down_on_grid(number_of_rows: int) -> void:
    if _grid == null:
        push_error("Trying to move block down on grid, but it doesn't have a reference to a grid")
        return

    _grid.move_block_down(self, number_of_rows)

func clear() -> void:
    _grid.clear_position(_grid_position)
    var delay = _get_clear_delay()
    _destroy_after_delay(delay)

func _get_clear_delay() -> int:
    var number_of_columns = _grid.get_size().x
    var center: float = (number_of_columns - 1) / 2.0
    var delay_multiplier: int = abs(_grid_position.x - center)
    return Constants.BLOCK_CLEAR_DELAY * delay_multiplier

func _destroy_after_delay(delay_in_frames: int) -> void:
    for i in range(delay_in_frames):
        await get_tree().physics_frame 

    cleared.emit(self)
    queue_free()
