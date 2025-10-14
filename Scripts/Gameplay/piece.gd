class_name Piece
extends Node2D

@export var blocks: Array[Block]
@export var _rotate_sfx: AudioStream
@export var _move_sfx: AudioStream

var _piece_data: PieceData
var _grid_position: Vector2i

var _grid: TGrid

var _current_rotation := Enums.Rotation.DEGREES_0
var _is_splitted: bool

func _ready() -> void:
    _setup_blocks()
        
func setup(piece_data: PieceData, grid: TGrid, grid_position: Vector2i = Vector2i.ZERO) -> void:
    set_piece_data(piece_data)
    add_to_grid_in_position(grid, grid_position)

func set_piece_data(piece_data: PieceData) -> void:
    if piece_data.variants <= 0:
        push_error("Setting up Piece with Piece Data with 0 position variants (%s)." % piece_data.resource_name)
        return

    _piece_data = piece_data

func add_to_grid_in_position(grid: TGrid, grid_position: Vector2i) -> void:
    add_to_grid(grid)
    set_grid_position(grid_position)

func add_to_grid(grid: TGrid) -> void:
    _grid = grid
    if get_parent() == null:
        _grid.add_child(self)
    else:
        self.reparent(_grid)

    for block in blocks:
        block.set_grid(_grid)

func _setup_blocks() -> void:
    for block in blocks:
        block.attach_to_piece(self)

func set_grid_position(grid_position: Vector2i):
    _grid_position = _grid.apply_horizontal_index_loop(grid_position)
    position = _grid.get_position_in_grid(_grid_position)
    _update_blocks_positions()

func _get_blocks_offsets(piece_rotation: Enums.Rotation = _current_rotation) -> Array[Vector2i]:
    return _piece_data.get_blocks_positions(piece_rotation)

func _update_blocks_positions() -> void:
    _is_splitted = false

    for i in range(Constants.BLOCKS_PER_PIECE):
        var block_offsets = _get_blocks_offsets()
        var grid_position = _grid_position + block_offsets[i]

        _is_splitted = _is_splitted || (grid_position.x < 0 || grid_position.x >= _grid.get_size().x)

        blocks[i].set_grid_position(grid_position)
    
func get_is_splitted() -> bool:
    return _is_splitted

func try_rotate_clockwise() -> bool:
    return try_rotate(_current_rotation + 1)

func try_rotate_counterclockwise() -> void:
    return try_rotate(_current_rotation - 1)

func try_reset_rotation() -> bool:
    return try_rotate(Enums.Rotation.DEGREES_0, false)

func try_rotate(rotation_index: int, play_sfx: bool = true) -> bool:
    var new_rotation = _get_rotation_from_index(rotation_index)
    if _current_rotation == new_rotation:
        return true

    if !can_rotate_to(new_rotation):
        return false

    _current_rotation = new_rotation
    _update_blocks_positions()

    if play_sfx:
        AudioManager.instance.play_sfx(_rotate_sfx)

    return true
    
@warning_ignore("shadowed_variable_base_class")
func _get_rotation_from_index(rotation: int) -> Enums.Rotation:
    if _piece_data.variants <= 0:
        return Enums.Rotation.DEGREES_0
        
    if rotation < 0:
        @warning_ignore("integer_division")
        rotation += ((-rotation / _piece_data.variants) + 1) * _piece_data.variants
        
    return rotation % _piece_data.variants as Enums.Rotation

func can_rotate_to(piece_rotation: Enums.Rotation) -> bool:
    var block_offsets = _get_blocks_offsets(piece_rotation)
    return can_fit_with_offsets(block_offsets)

func can_fit_with_offsets(block_offsets: Array[Vector2i]) -> bool:
    for offset in block_offsets:
        var block_position = _grid.apply_horizontal_index_loop(_grid_position + offset)
        if !_grid.is_empty(block_position):
            return false
        
    return true

func can_apply_movement(offset: Vector2i) -> bool:
    for block in blocks:
        var next_position = block.get_grid_position() + offset
        next_position = _grid.apply_horizontal_index_loop(next_position)
        
        if !_grid.is_empty(next_position):
            return false

    return true

func try_move_down_one_row() -> bool:
    return try_move_down(1)

func try_move_down(height: int) -> bool:
    return try_move(Vector2i(0, height))

func try_move_sideways(sideways_offset: int) -> bool:
    var moved = try_move(Vector2i(sideways_offset, 0))
    if moved:
        AudioManager.instance.play_sfx(_move_sfx)

    return moved

func try_move(offset: Vector2i):
    if !can_apply_movement(offset):
        return false

    set_grid_position(_grid_position + offset)
    return true

func set_color(color: Color) -> void:
    for block in blocks:
        block.modulate = color
    
