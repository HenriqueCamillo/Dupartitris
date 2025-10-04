extends Node2D

@export var spawner: PieceSpawner
@export var input_handler: InputHandler
@export var grid: TGrid
@export var das_timer: Timer

@export var drop_time_transitions: Dictionary[int, float]
@export var soft_drop_time: float

var drop_time: float
var level: int:
	set(value):
		level = value
		if drop_time_transitions.has(level):
			level_drop_time = drop_time_transitions[level]

var level_drop_time: float:
	set(value):
		if level_drop_time == value:
			return
			
		level_drop_time = value
		update_drop_time()
			
var is_soft_dropping: bool:
	set(value):
		if is_soft_dropping == value:
			return
			
		is_soft_dropping = value
		update_drop_time()

var falling_piece: Piece
var das_direction: int
var das_enabled: bool:
	set(value):
		if das_enabled == value:
			return
			
		das_enabled = value
		if das_enabled:
			das_timer.start()
		else:
			das_timer.stop()

func _ready() -> void:
	start_game(0)
	
func start_game(start_level: int) -> void:
	level = start_level
	level_drop_time = get_start_level_drop_time(start_level)
	update_drop_time()
	spawn_next_piece()

var elapsed_drop_time: float
func _process(delta: float) -> void:
	elapsed_drop_time += delta
	
	if elapsed_drop_time >= drop_time:
		apply_timed_drop()

func apply_timed_drop() -> void:
	drop_piece_one_row()
	elapsed_drop_time = 0
	
func drop_piece_one_row() -> void:
	if falling_piece != null:
		falling_piece.move_down_one_row()
	
@warning_ignore("shadowed_variable")
func get_start_level_drop_time(level: int) -> float:
	if drop_time_transitions.has(level):
		return drop_time_transitions[level]
		
	while level > 0:
		level -= 1
		if drop_time_transitions.has(level):
			return drop_time_transitions[level]
			
	push_error("Level 0 does not have a drop_time set. Using arbitrary start drop_time")
	return 1.0
	
func update_drop_time() -> void:
	if is_soft_dropping:
		drop_time = min(level_drop_time, soft_drop_time)
	else:
		drop_time = level_drop_time
		
	if elapsed_drop_time > drop_time:
		apply_timed_drop()	

func spawn_next_piece() -> void:
	falling_piece = spawner.spawn_piece()
	self.add_child(falling_piece)
	
func _on_rotate_clockwise_pressed() -> void:
	if falling_piece != null:
		falling_piece.rotate_clockwise()
		
func _on_rotate_counterclockwise_pressed() -> void:
	if falling_piece != null:
		falling_piece.rotate_counterclockwise()

func _on_horizontal_input_changed(direction: int) -> void:
	if falling_piece == null:
		return
		
	if direction != 0:	
		falling_piece.move_sideways(direction)
		das_direction = direction
		
	das_enabled = false
	
func _on_das_changed(enabled: bool) -> void:
	das_enabled = enabled
	
func _on_das_timer_timeout() -> void:
	if falling_piece != null:
		falling_piece.move_sideways(das_direction)

func _on_soft_drop_input_changed(is_pressed: bool) -> void:
	is_soft_dropping = is_pressed

# TODO:
func _on_hard_drop_pressed() -> void:
	pass
	
