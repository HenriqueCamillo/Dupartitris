class_name TGrid
extends Node2D

const _ROW_GROUP_NAME := "Row%02d"
const _EXTRA_ROWS_ABOVE: int = 2

@export var _visible_size := Vector2i(10, 20)
var _real_size := _visible_size + Vector2i(0, _EXTRA_ROWS_ABOVE)

@export var _border: Sprite2D
@export var _upper_border: Sprite2D
@export var _row_above_upper_border: Sprite2D
@export var _background: Sprite2D

var _grid: Array[Block]
var _origin_position: Vector2
var _spawn_position: Vector2

var _last_cleared_lines: Array[int]

signal on_finished_line_clear(lines_cleared: Array[int])
        
func _ready() -> void:
    _initialize_grid_array()
    _setup_visuals()
    _calculate_origin_position()
    _calculate_spawn_position()
    
func _initialize_grid_array() -> void:
    var number_of_positions = _real_size.x * _real_size.y
    _grid.resize(number_of_positions)

func _setup_visuals() -> void:
    var grid_shape = _visible_size
    _background.region_rect = Rect2(Vector2.ZERO, grid_shape * Constants.BLOCK_SIZE)
    _background.position = Vector2(0, -(grid_shape.y / 2) * Constants.BLOCK_SIZE)
    
    var border_shape = grid_shape + Vector2i(2, 2)
    _border.region_rect = Rect2(Vector2.ZERO, border_shape * Constants.BLOCK_SIZE)
    _border.position = _background.position

    var upper_border_shape = Vector2i(border_shape.x, 1)
    _upper_border.region_rect = Rect2(Vector2.ZERO, upper_border_shape * Constants.BLOCK_SIZE)
    _upper_border.position = Vector2(0, -(grid_shape.y * Constants.BLOCK_SIZE + (Constants.BLOCK_SIZE / 2.0)))

    _row_above_upper_border.region_rect = _upper_border.region_rect
    _row_above_upper_border.position = _upper_border.position - Vector2(0, Constants.BLOCK_SIZE)
    
func _calculate_origin_position() -> void:
    _origin_position = Vector2(-_real_size.x / 2.0, -_real_size.y) * Constants.BLOCK_SIZE

func _calculate_spawn_position() -> void:
    @warning_ignore("integer_division")
    _spawn_position = Vector2i(_real_size.x / 2, _EXTRA_ROWS_ABOVE)

func get_size() -> Vector2i:
    return _real_size

func get_spawn_position() -> Vector2i:
    return _spawn_position
    
func _get_grid_element(grid_position: Vector2i) -> Block:
    var index = _array_index(grid_position)
    return _grid[index]
    
func _set_grid_element(grid_position: Vector2i, block: Block) -> void:
    var index = _array_index(grid_position)
    _grid[index] = block

func get_position_in_grid(grid_position: Vector2i) -> Vector2:
    return grid_position * Constants.BLOCK_SIZE + _origin_position
        
func _array_index(grid_position: Vector2i) -> int:
    return grid_position.y * _real_size.x + grid_position.x

func clear_position(grid_postiion: Vector2i) -> void:
    _set_grid_element(grid_postiion, null)
    
func place_piece(piece: Piece) -> Array[int]:
    var completed_lines: Dictionary[int, bool]

    for block in piece.blocks:
        place_block(block)
    
    for block in piece.blocks:
        var row = block.get_grid_position().y
        if completed_lines.has(row):
            continue
        
        var row_group = get_row_group_name(row)
        var blocks_in_row = get_tree().get_node_count_in_group(row_group)
        if blocks_in_row == _real_size.x:
            completed_lines[row] = true
            
    piece.queue_free()
    
    _last_cleared_lines = completed_lines.keys()
    _last_cleared_lines.sort()
    _last_cleared_lines.reverse()
    
    return _last_cleared_lines
    
func place_block(block: Block) -> void:
    block.detach_from_piece()
    _set_grid_element(block.get_grid_position(), block)

    var row_group = get_row_group_name(block.get_grid_position().y)
    block.add_to_group(row_group)
    block.cleared.connect(_on_block_cleared)

func _on_block_cleared(block: Block) -> void:
    block.cleared.disconnect(_on_block_cleared)

    if block.get_grid_position().x == 0:
        if _last_cleared_lines.size() > 0:
            on_finished_line_clear.emit(_last_cleared_lines.duplicate())
            _last_cleared_lines.clear()
    
func move_block_down(block: Block, number_of_rows: int) -> void:
    var old_row_group = get_row_group_name(block.get_grid_position().y)
    var new_row_group = get_row_group_name(block.get_grid_position().y + number_of_rows)
    
    block.remove_from_group(old_row_group)
    block.add_to_group(new_row_group)
    
    var old_grid_position = block.get_grid_position()
    var new_grid_position = old_grid_position + Vector2i(0, number_of_rows)

    _set_grid_element(old_grid_position, null)
    _set_grid_element(new_grid_position, block)

    block.set_grid_position(new_grid_position)

static func get_row_group_name(row_index: int) -> String:
    return _ROW_GROUP_NAME %  row_index
    
func is_empty(grid_position: Vector2i) -> bool:
    if is_out_of_bounds(grid_position):
        return false
        
    return _get_grid_element(grid_position) == null
    
func apply_horizontal_index_loop(grid_position: Vector2i):
    var x = grid_position.x
    if x < 0:
        @warning_ignore("integer_division")
        x += ((-x / _real_size.x) + 1) * _real_size.x

    grid_position.x = x % _real_size.x
    return grid_position

# Never gets out of bounds horizontally because it should teleport. Just remember to use apply_horizontal_index_loop when applying position
func is_out_of_bounds(grid_position: Vector2i) -> bool:
    return grid_position.y >= _real_size.y

func get_number_of_empty_blocks_under(grid_position: Vector2i) -> int:
    var empty_blocks = 0
    
    grid_position.y += 1
    while is_empty(grid_position):
        empty_blocks += 1
        grid_position.y += 1

    return empty_blocks
