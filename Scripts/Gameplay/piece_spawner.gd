class_name PieceSpawner
extends Node2D

@export var _piece_types: Array[PieceData]
@export var _piece_template: PackedScene
@export var _piece_colors: PieceColors
@export var _next_pieces: NextPieces

var _grid: TGrid

var _pieces_to_queue: int = 1
var _spawn_mode := Enums.SpawnMode.Random

var _available_piece_types: Array[PieceData]

func _reset_available_piece_types() -> void:
    _available_piece_types = _piece_types.duplicate()

func setup(grid: TGrid, spawn_mode: Enums.SpawnMode, next_pieces_look_ahead: int) -> void:
    _grid = grid
    _pieces_to_queue = next_pieces_look_ahead
    _spawn_mode = spawn_mode
    
    _reset_available_piece_types()
    _next_pieces.set_capacity(_pieces_to_queue)

func _get_random_piece_type() -> PieceData:
    if _available_piece_types.size() == 0:
        _reset_available_piece_types()
    
    var index = randi_range(0, _available_piece_types.size() - 1)
    var piece_type = _available_piece_types[index]
    
    if _spawn_mode == Enums.SpawnMode.SevenBag:
        _available_piece_types.remove_at(index)
    
    return piece_type

func get_next_piece() -> Piece:
    if _next_pieces.get_queue_size() < _pieces_to_queue:
        _queue_pieces()

    var spawned_piece = _spawn_piece()
    var piece_to_return = _next_pieces.pop_from_queue()
    if piece_to_return == null:
        spawned_piece.add_to_grid_in_position(_grid, _grid.get_spawn_position())
        return spawned_piece
        
    _next_pieces.add_to_queue(spawned_piece)

    piece_to_return.add_to_grid_in_position(_grid, _grid.get_spawn_position())
    return piece_to_return

func _spawn_piece() -> Piece:
    var piece_type = _get_random_piece_type()
    var piece = _piece_template.instantiate() as Piece
    piece.set_piece_data(piece_type)

    var color = _piece_colors.get_color(piece_type)
    piece.set_color(color)
    
    return piece

func _queue_pieces() -> void:
    var pieces_to_spawn = _pieces_to_queue - _next_pieces.get_queue_size()

    while pieces_to_spawn > 0:
        var spawned_piece = _spawn_piece()
        _next_pieces.add_to_queue(spawned_piece)
        pieces_to_spawn -= 1

func reset() -> void:
    _next_pieces.reset()
    _reset_available_piece_types()
