extends Sprite2D
class_name Piece

const blocks_per_piece: int = 4

var piece_data: PieceData
var current_rotation := Enums.Rotation.DEGREES_0
var block_positions: Array[Vector2i]

@export var blocks: Array[Sprite2D]
		
@warning_ignore("shadowed_variable")
func setup(piece_data: PieceData) -> void:
	if piece_data.variants <= 0:
		push_error("Setting up Piece with Piece Data with 0 position variants (%s)." % piece_data.resource_name)
		return
	
	self.piece_data = piece_data
	var piece_locations = piece_data.get_block_positions()
	set_block_positions(piece_locations)
	
@warning_ignore("shadowed_variable")
func set_block_positions(block_positions: Array[Vector2i]) -> void:
	self.block_positions = block_positions
	
	for i in range(blocks_per_piece):
		blocks[i].position = block_positions[i] * GridSettings.BLOCK_SIZE
	
func rotate_clockwise() -> void:
	set_piece_rotation(current_rotation + 1)

func rotate_counterclockwise() -> void:
	set_piece_rotation(current_rotation - 1)
	
func set_piece_rotation(rotation_index: int) -> void:
	var new_rotation = get_rotation_from_index(rotation_index)
	if current_rotation == new_rotation:
		return
	
	var new_positions = piece_data.get_block_positions(new_rotation)
	set_block_positions(new_positions)
	current_rotation = new_rotation
	
@warning_ignore("shadowed_variable_base_class")
func get_rotation_from_index(rotation: int) -> Enums.Rotation:
	if piece_data.variants <= 0:
		return Enums.Rotation.DEGREES_0
		
	if rotation < 0:
		@warning_ignore("integer_division")
		rotation += ((-rotation / piece_data.variants) + 1) * piece_data.variants
		
	return rotation % piece_data.variants as Enums.Rotation
