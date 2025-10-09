extends Resource
class_name PieceColors

@export var colors_by_piece: Dictionary[PieceData, Color]

func get_color(piece: PieceData) -> Color:
    if !colors_by_piece.has(piece):
        push_error("Trying to get color of a piece that isn't on PieceColors configuration.")
        return Color.WHITE
        
    return colors_by_piece[piece]
