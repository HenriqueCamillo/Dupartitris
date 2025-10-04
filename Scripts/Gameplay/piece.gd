extends Node2D
class_name Piece

const BLOCKS_PER_PIECE: int = 4

@export var blocks: Array[Block]

var piece_data: PieceData

var current_rotation := Enums.Rotation.DEGREES_0:
	set(value):
		if current_rotation == value:
			return
			
		current_rotation = value
		update_blocks_positions()

var grid_position: Vector2i:
	set(value):
		if grid_position == value:
			return
			
		grid_position = value
		position = grid_position * GridSettings.BLOCK_SIZE
		update_blocks_positions()
		
@warning_ignore("shadowed_variable")
func setup(piece_data: PieceData) -> void:
	if piece_data.variants <= 0:
		push_error("Setting up Piece with Piece Data with 0 position variants (%s)." % piece_data.resource_name)
		return
	
	self.piece_data = piece_data
	update_blocks_positions()

func get_blocks_offsets() -> Array[Vector2i]:
	return piece_data.get_blocks_positions(current_rotation)

func update_blocks_positions() -> void:
	for i in range(BLOCKS_PER_PIECE):
		var block_offsets = get_blocks_offsets()
		blocks[i].set_relative_grid_position(grid_position, block_offsets[i])
	
func rotate_clockwise() -> void:
	set_piece_rotation(current_rotation + 1)

func rotate_counterclockwise() -> void:
	set_piece_rotation(current_rotation - 1)
	
func set_piece_rotation(rotation_index: int) -> void:
	var new_rotation = get_rotation_from_index(rotation_index)
	if current_rotation == new_rotation:
		return
	
	current_rotation = new_rotation
	
@warning_ignore("shadowed_variable_base_class")
func get_rotation_from_index(rotation: int) -> Enums.Rotation:
	if piece_data.variants <= 0:
		return Enums.Rotation.DEGREES_0
		
	if rotation < 0:
		@warning_ignore("integer_division")
		rotation += ((-rotation / piece_data.variants) + 1) * piece_data.variants
		
	return rotation % piece_data.variants as Enums.Rotation

func move_down_one_row() -> void:
	move(Vector2i(0, 1))

func move_sideways(offset: int) -> void:
	move(Vector2i(offset, 0))
	
func move(offset: Vector2i) -> void:
	grid_position += offset
	
