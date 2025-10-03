extends Node2D

@export var spawner: PieceSpawner
@export var input_handler: InputHandler
@export var grid: TGrid
@export var das_timer: Timer

var current_piece: Piece
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
	start_game()

func start_game() -> void:
	spawn_next_piece()
	
func spawn_next_piece() -> void:
	current_piece = spawner.spawn_piece()
	self.add_child(current_piece)
	
func _on_rotate_clockwise_pressed() -> void:
	if current_piece != null:
		current_piece.rotate_clockwise()
		
func _on_rotate_counterclockwise_pressed() -> void:
	if current_piece != null:
		current_piece.rotate_counterclockwise()

func _on_horizontal_input_changed(direction: int) -> void:
	if current_piece == null:
		return
		
	if direction != 0:	
		current_piece.move_sideways(direction)
		das_direction = direction
		
	das_enabled = false
	
func _on_das_changed(enabled: bool) -> void:
	das_enabled = enabled
	
func _on_das_timer_timeout() -> void:
	if current_piece != null:
		current_piece.move_sideways(das_direction)
	
	
