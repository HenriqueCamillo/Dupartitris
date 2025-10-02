extends Node2D

@export var spawner: PieceSpawner
@export var input_handler: InputHandler

var current_piece: Piece

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
