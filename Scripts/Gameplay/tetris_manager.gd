class_name TetrisManager
extends Node2D

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
	_grid.place_piece(_falling_piece)
	_spawn_next_piece()
	
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
		_falling_piece.rotate_clockwise()
		
func _on_rotate_counterclockwise_pressed() -> void:
	if _falling_piece != null:
		_falling_piece.rotate_counterclockwise()

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
	
