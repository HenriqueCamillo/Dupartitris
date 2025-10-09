class_name TetrisManager
extends Node2D

const MOVE_DOWN_ON_GRID_METHOD := "move_down_on_grid"
const CLEAR_METHOD := "clear"

@export var _spawner: PieceSpawner
@export var _grid: TGrid
@export var _piece_holder: PieceHolder
@export var _das_timer: Timer

@export var _drop_frame_intervals: DropFrameIntervals

var _falling_piece: Piece
var _lines_cleared: int

var _das_direction: int
var _das_enabled: bool

var _is_soft_dropping: bool

var _frames_per_drop: int
var _elapsed_frames: int

var _level: int
var _level_frames_per_drop: int

var _can_hold_piece: bool

func _ready() -> void:
    _spawner.setup(_grid)
    _start_game(0)
    
func _start_game(start_level: int) -> void:
    _set_level(start_level, true)
    _update_frames_per_drop()
    _spawn_next_piece()

func _spawn_next_piece() -> void:
    _elapsed_frames = 0
    _falling_piece = _spawner.spawn_piece()
    _can_hold_piece = true

    for block in _falling_piece.blocks:
        if !_grid.is_empty(block.get_grid_position()):
            _game_over()
            break

func _game_over() -> void:
    _falling_piece = null
    await get_tree().create_timer(2).timeout
    get_tree().reload_current_scene()

#region PieceDropping

func _physics_process(_delta: float) -> void:
    if _falling_piece == null:
        return

    _elapsed_frames += 1
    
    if _elapsed_frames >= _frames_per_drop:
        _apply_timed_drop()

func _apply_timed_drop() -> void:
    _drop_piece_one_row()
    _elapsed_frames = 0
    
func _drop_piece_one_row() -> void:
    if _falling_piece == null:
        return

    var reached_ground = !_falling_piece.try_move_down_one_row()
    if reached_ground:
        _place_piece_and_spawn_next()

func _update_frames_per_drop() -> void:
    if _is_soft_dropping:
        _frames_per_drop = min(_level_frames_per_drop, _drop_frame_intervals.get_frames_per_soft_drop())
    else:
        _frames_per_drop = _level_frames_per_drop
        
    if _elapsed_frames >= _frames_per_drop:
        _apply_timed_drop()	

#endregion

#region PiecePlacement

func _place_piece_and_spawn_next() -> void:
    var cleared_lines = _grid.place_piece(_falling_piece)
    _falling_piece = null

    if cleared_lines.size() > 0:
        _clear_lines(cleared_lines)
    else:
        _spawn_next_piece()
    
func _clear_lines(cleared_lines: Array[int]) -> void:
    var rows_to_move_down = 0
    var cleared_line_index = 0
    
    for row in range(_grid.get_size().y - 1, -1, -1):
        var row_group = TGrid.get_row_group_name(row)

        if cleared_line_index < cleared_lines.size() && row == cleared_lines[cleared_line_index]:
            rows_to_move_down += 1
            cleared_line_index += 1
            call_group_fixed(row_group, CLEAR_METHOD)
        elif rows_to_move_down > 0:
            call_group_fixed(row_group, MOVE_DOWN_ON_GRID_METHOD, rows_to_move_down)

    _increase_lines_cleared(cleared_lines.size())

    # TODO: Animation
    _spawn_next_piece()

# TODO: use godot's call_group after fix enters the release
func call_group_fixed(group_name: String, method_name: String, argument: Variant = null) -> void:
    # This fails to call nodes that were just reparented
    # if argument == null:
    # 	get_tree().call_group(group_name, method_name)
    # else:
    # 	get_tree().call_group(group_name, method_name, argument)

    var nodes_in_group = get_tree().get_nodes_in_group(group_name)
    for node in nodes_in_group:
        if argument == null:
            node.call(method_name)
        else:
            node.call(method_name, argument)

func _increase_lines_cleared(quantity: int) -> void:
    _lines_cleared += quantity
    @warning_ignore("integer_division")
    while _lines_cleared / _drop_frame_intervals.get_lines_to_level_up() > _level:
        _level_up()

func _level_up() -> void:
    _set_level(_level + 1)

func _set_level(new_level: int, is_first_setup: bool = false) -> void:
    _level = new_level

    if _drop_frame_intervals.is_transition_level(_level) || is_first_setup:
        _level_frames_per_drop = _drop_frame_intervals.get_frames_per_drop_in_level(_level)
        _update_frames_per_drop()

#endregion

#region PlayerInput	
    
func _on_rotate_clockwise_pressed() -> void:
    if _falling_piece != null:
        _falling_piece.try_rotate_clockwise()
        
func _on_rotate_counterclockwise_pressed() -> void:
    if _falling_piece != null:
        _falling_piece.try_rotate_counterclockwise()

func _on_horizontal_input_changed(direction: int) -> void:
    if _falling_piece == null:
        return
        
    if direction != 0:	
        _falling_piece.try_move_sideways(direction)
        _das_direction = direction
        
    _set_das_enabled(false)
    
func _set_das_enabled(value: bool) -> void:
    _das_enabled = value
    if _das_enabled:
        _das_timer.start()
    else:
        _das_timer.stop()
        
func _on_das_timer_timeout() -> void:
    if _falling_piece != null:
        _falling_piece.try_move_sideways(_das_direction)

func _set_is_soft_dropping(value: bool) -> void:
    _is_soft_dropping = value
    _update_frames_per_drop()

func _on_hard_drop_pressed() -> void:
    if _falling_piece == null:
        return

    var min_height = _grid.get_size().y
    for block in _falling_piece.blocks:
        var height = _grid.get_number_of_empty_blocks_under(block.get_grid_position())
        min_height = min(min_height, height)

    _falling_piece.try_move_down(min_height)
    _place_piece_and_spawn_next()

func _on_hold_pressed() -> void:
    if !_can_hold_piece || _falling_piece == null:
        return

    _falling_piece = _piece_holder.swap_piece(_falling_piece)
    if _falling_piece != null:
        _falling_piece.add_to_grid_in_position(_grid, _grid.get_spawn_position())
    else:
        _spawn_next_piece()

    _can_hold_piece = false
    
#endregion
