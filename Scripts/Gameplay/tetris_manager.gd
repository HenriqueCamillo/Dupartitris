class_name TetrisManager
extends Node2D

const MOVE_DOWN_ON_GRID_METHOD := "move_down_on_grid"
const CLEAR_METHOD := "clear"

@export var _spawner: PieceSpawner
@export var _grid: TGrid
@export var _das_timer: Timer

@export var _drop_time_transitions: Dictionary[int, float]
@export var _soft_drop_time: float


var _elapsed_drop_time: float
var _drop_time: float
var _level: int:
	set(value):
		_level = value
		if _drop_time_transitions.has(_level):
			_level_drop_time = _drop_time_transitions[_level]

var _level_drop_time: float:
	set(value):
		if _level_drop_time == value:
			return
			
		_level_drop_time = value
		_update_drop_time()
			
var _is_soft_dropping: bool:
	set(value):
		if _is_soft_dropping == value:
			return
			
		_is_soft_dropping = value
		_update_drop_time()

var _falling_piece: Piece
var _das_direction: int
var _das_enabled: bool:
	set(value):
		if _das_enabled == value:
			return
			
		_das_enabled = value
		if _das_enabled:
			_das_timer.start()
		else:
			_das_timer.stop()

func _ready() -> void:
	_spawner.setup(_grid)
	_start_game(0)
	
func _start_game(start_level: int) -> void:
	_level = start_level
	_level_drop_time = _get_start_level_drop_time(start_level)
	_update_drop_time()
	_spawn_next_piece()

func _process(delta: float) -> void:
	_elapsed_drop_time += delta
	
	if _elapsed_drop_time >= _drop_time:
		_apply_timed_drop()

func _apply_timed_drop() -> void:
	_drop_piece_one_row()
	_elapsed_drop_time = 0
	
func _drop_piece_one_row() -> void:
	if _falling_piece == null:
		return

	var reached_ground = !_falling_piece.try_move_down_one_row()
	if reached_ground:
		_place_piece_and_spawn_next()

func _place_piece_and_spawn_next() -> void:
	var cleared_lines = _grid.place_piece(_falling_piece)
	if cleared_lines.size() > 0:
		_clear_lines(cleared_lines)
	else:
		_spawn_next_piece()
	
func _clear_lines(cleared_lines: Array[int]) -> void:
	var rows_to_move_down = 0
	var cleared_line_index = 0
	
	for row in range(_grid.get_grid_size().y - 1, -1, -1): # TODO Invert after
		var row_group = TGrid.get_row_group_name(row)

		if cleared_line_index < cleared_lines.size() && row == cleared_lines[cleared_line_index]:
			rows_to_move_down += 1
			cleared_line_index += 1
			call_group_fixed(row_group, CLEAR_METHOD)
		elif rows_to_move_down > 0:
			call_group_fixed(row_group, MOVE_DOWN_ON_GRID_METHOD, rows_to_move_down)

	# TODO: Animation
	_spawn_next_piece()

# TODO: investigate
func call_group_fixed(group_name: String, method_name: String, argument: Variant = null) -> void:
	# This fails to call the nodes that triggered this call
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

func _get_start_level_drop_time(level: int) -> float:
	if _drop_time_transitions.has(level):
		return _drop_time_transitions[level]
		
	while level > 0:
		level -= 1
		if _drop_time_transitions.has(level):
			return _drop_time_transitions[level]
			
	push_error("Level 0 does not have a _drop_time set. Using arbitrary start _drop_time")
	return 1.0
	
func _update_drop_time() -> void:
	if _is_soft_dropping:
		_drop_time = min(_level_drop_time, _soft_drop_time)
	else:
		_drop_time = _level_drop_time
		
	if _elapsed_drop_time >= _drop_time:
		_apply_timed_drop()	

func _spawn_next_piece() -> void:
	_falling_piece = _spawner.spawn_piece()
	
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
		
	_das_enabled = false
	
func _on_das_changed(enabled: bool) -> void:
	_das_enabled = enabled
	
func _on_das_timer_timeout() -> void:
	if _falling_piece != null:
		_falling_piece.try_move_sideways(_das_direction)

func _on_soft_drop_input_changed(is_pressed: bool) -> void:
	_is_soft_dropping = is_pressed

# TODO:
func _on_hard_drop_pressed() -> void:
	pass
	
