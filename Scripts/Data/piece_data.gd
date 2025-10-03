extends Resource
class_name PieceData

@export var variants: int
@export var piece_locations_0: Array[Vector2i]
@export var piece_locations_90: Array[Vector2i]
@export var piece_locations_180: Array[Vector2i]
@export var piece_locations_270: Array[Vector2i]


func get_blocks_positions(rotation: Enums.Rotation = Enums.Rotation.DEGREES_0) -> Array[Vector2i]:
	rotation = rotation % variants as Enums.Rotation
	
	match rotation:
		Enums.Rotation.DEGREES_0: 
			return piece_locations_0
		Enums.Rotation.DEGREES_90: 
			return piece_locations_90
		Enums.Rotation.DEGREES_180: 
			return piece_locations_180
		Enums.Rotation.DEGREES_270: 
			return piece_locations_270
		_: 
			return piece_locations_0
