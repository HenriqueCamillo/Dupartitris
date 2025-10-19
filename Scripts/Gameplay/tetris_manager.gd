class_name TetrisManager
extends Node2D

const _MOVE_DOWN_ON_GRID_METHOD := "move_down_on_grid"
const _CLEAR_METHOD := "clear"

@export_group("Node References")
@export var _input_handler: InputHandler
@export var _spawner: PieceSpawner
@export var _grid: TGrid
@export var _piece_holder: PieceHolder
@export var _das_timer: Timer

@export_group("Data Resources references")
@export var _drop_frame_intervals: DropFrameIntervals
@export var _dupartitris_score_rules: ScoreRules
@export var _classic_tetris_score_rules: ScoreRules

var _score_rules: ScoreRules

@export_group("SFX")
@export var _line_clear_sound_effects: LineClearSoundEffects
@export var _game_over_sfx: AudioStream

signal paused()
signal game_over()
signal score_changed(score: int)
signal level_changed(level: int)
signal lines_cleared_changed(lines_cleared: int)

var _falling_piece: Piece
var _lines_cleared: int
var _intial_level_lines_cleared_equivalent: int

var _das_direction: int
var _das_enabled: bool

var _is_soft_dropping: bool

var _frames_per_drop: int
var _elapsed_frames: int

var _level: int
var _level_frames_per_drop: int

var _can_hold_piece: bool
var _is_enabled: bool

var _score: int
var _score_from_last_clear: int

var _has_lost: bool
var _in_game_over_animation: bool
var _piece_that_caused_loss: Piece

var _game_rules: GameRules

var _is_hard_drop_enabled: bool:
    get:
        return _game_rules.hard_drop_enabled

var _is_hold_piece_enabled: bool:
    get:
        return _game_rules.hold_piece_enabled

func _ready() -> void:
    _grid.on_finished_line_clear.connect(_on_finished_line_clear)

func _exit_tree() -> void:
    _grid.on_finished_line_clear.disconnect(_on_finished_line_clear)


func set_game_rules(game_rules: GameRules) -> void:
    _game_rules = game_rules
    _grid.set_split_enabled(game_rules.split_enabled)
    _spawner.setup(_grid, game_rules.piece_spawn_mode, game_rules.next_pieces_look_ahead)
    _piece_holder.visible = game_rules.hold_piece_enabled
    
    _score_rules = _dupartitris_score_rules if _game_rules.split_enabled else _classic_tetris_score_rules
    
func start_game() -> void:
    if _game_rules == null:
        push_error("Tetris Manager was not initialized with a game mode. Using default values.")
        set_game_rules(GameRules.new())
    
    enable()
    
    _set_level(_game_rules.initial_level, true)
    _set_score(0)
    _set_lines_cleared(0)

    _spawn_next_piece_after_delay()

func _spawn_next_piece_after_delay() -> void:
    await Delay.physics_frames(Constants.PIECE_SPAWN_DELAY)
    _spawn_next_piece()
    
func _spawn_next_piece() -> void:
    _elapsed_frames = 0
    _falling_piece = _spawner.get_next_piece()
    _can_hold_piece = true

    for block in _falling_piece.blocks:
        if !_grid.is_empty(block.get_grid_position()):
            _game_over()
            break

func _game_over() -> void:
    # TODO: Better game over animation
    _has_lost = true
    _in_game_over_animation = true

    _piece_that_caused_loss = _falling_piece
    _falling_piece = null

    await get_tree().create_timer(1).timeout
    AudioManager.instance.play_sfx(_game_over_sfx)
    await get_tree().create_timer(3).timeout

    _in_game_over_animation = false

#region PieceDropping

func _physics_process(_delta: float) -> void:
    if _falling_piece == null:
        return

    _elapsed_frames += 1
    
    if _elapsed_frames >= _frames_per_drop:
        _apply_timed_drop()

func _apply_timed_drop() -> void:
    _drop_piece_one_row()
    _elapsed_frames = 0
    
func _drop_piece_one_row() -> void:
    if _falling_piece == null:
        return

    var reached_ground = !_falling_piece.try_move_down_one_row()
    if reached_ground:
        _place_piece_and_spawn_next()
    elif _is_soft_dropping:
        _increase_score(_score_rules.get_soft_drop_score_per_row())

func _update_frames_per_drop() -> void:
    if _is_soft_dropping:
        _frames_per_drop = min(_level_frames_per_drop, _drop_frame_intervals.get_frames_per_soft_drop())
    else:
        _frames_per_drop = _level_frames_per_drop
        
    if _elapsed_frames >= _frames_per_drop:
        _apply_timed_drop()	

#endregion

#region PiecePlacement

func _place_piece_and_spawn_next() -> void:
    var is_splitted = _falling_piece.get_is_splitted()

    var cleared_lines = _grid.place_piece(_falling_piece)
    _falling_piece = null
    _set_is_soft_dropping(false)
    var lines_cleared = cleared_lines.size()

    var sfx = _line_clear_sound_effects.get_sfx(lines_cleared, is_splitted)
    AudioManager.instance.play_sfx(sfx)

    if _score_rules.is_perfect_score(lines_cleared, is_splitted):
        _grid.flash_background()

    if lines_cleared > 0:
        _score_from_last_clear = _score_rules.get_score(_level, lines_cleared, is_splitted)
        _clear_lines(cleared_lines)
    else:
        _spawn_next_piece_after_delay()
    
func _clear_lines(cleared_lines: Array[int]) -> void:
    for cleared_line in cleared_lines:
        var row_group = TGrid.get_row_group_name(cleared_line)
        call_group_fixed(row_group, _CLEAR_METHOD)
        # And wait for line clear animation

func _on_finished_line_clear(cleared_lines: Array[int]):
    await Delay.physics_frames(Constants.STACK_DROP_DELAY)

    var rows_to_move_down = 0
    var cleared_line_index = 0
    
    for row in range(_grid.get_size().y - 1, -1, -1):
        var row_group = TGrid.get_row_group_name(row)

        if cleared_line_index < cleared_lines.size() && row == cleared_lines[cleared_line_index]:
            rows_to_move_down += 1
            cleared_line_index += 1
        elif rows_to_move_down > 0:
            call_group_fixed(row_group, _MOVE_DOWN_ON_GRID_METHOD, rows_to_move_down)

    _increase_lines_cleared(cleared_lines.size())
    _increase_score(_score_from_last_clear)
    _spawn_next_piece_after_delay()

# TODO: use godot's call_group after fix enters the release
func call_group_fixed(group_name: String, method_name: String, argument: Variant = null) -> void:
    # This fails to call nodes that were just reparented
    # if argument == null:
    # 	get_tree().call_group(group_name, method_name)
    # else:
    # 	get_tree().call_group(group_name, method_name, argument)

    var nodes_in_group = get_tree().get_nodes_in_group(group_name)
    for node in nodes_in_group:
        if argument == null:
            node.call(method_name)
        else:
            node.call(method_name, argument)

#endregion

#region ScoreAndLeveling

func _increase_lines_cleared(quantity: int) -> void:
    _set_lines_cleared(_lines_cleared + quantity)
    
    var lines_per_level = _drop_frame_intervals.get_lines_to_level_up()
    var total_lines = _lines_cleared + _intial_level_lines_cleared_equivalent
    @warning_ignore("integer_division")
    while total_lines / lines_per_level > _level:
        _level_up()

func _set_lines_cleared(value: int) -> void:
    _lines_cleared = value
    lines_cleared_changed.emit(_lines_cleared)

func _level_up() -> void:
    _set_level(_level + 1)

func _set_level(level: int, is_first_setup: bool = false) -> void:
    _level = level
    level_changed.emit(_level)

    if _drop_frame_intervals.is_transition_level(_level) || is_first_setup:
        _level_frames_per_drop = _drop_frame_intervals.get_frames_per_drop_in_level(_level)
        _update_frames_per_drop()
        
    if is_first_setup:
        var lines_per_level = _drop_frame_intervals.get_lines_to_level_up()
        _intial_level_lines_cleared_equivalent = lines_per_level * _level

func _increase_score(amount: int) -> void:
    _set_score(_score + amount)

func _set_score(value: int) -> void:
    _score = value
    score_changed.emit(_score)

#endregion

#region PlayerInput	
    
func _on_rotate_clockwise_pressed() -> void:
    if _falling_piece != null:
        _falling_piece.try_rotate_clockwise()
        
func _on_rotate_counterclockwise_pressed() -> void:
    if _falling_piece != null:
        _falling_piece.try_rotate_counterclockwise()

func _on_horizontal_input_changed(direction: int) -> void:
    if _falling_piece == null:
        return
        
    if direction != 0:	
        _falling_piece.try_move_sideways(direction)
        _das_direction = direction
        
    _set_das_enabled(false)
    
func _set_das_enabled(value: bool) -> void:
    _das_enabled = value
    if _das_enabled:
        _das_timer.start()
    else:
        _das_timer.stop()
        
func _on_das_timer_timeout() -> void:
    if _falling_piece != null:
        _falling_piece.try_move_sideways(_das_direction)

func _set_is_soft_dropping(value: bool) -> void:
    _is_soft_dropping = value
    _update_frames_per_drop()

func _on_hard_drop_pressed() -> void:
    if !_is_hard_drop_enabled:
        return
        
    if _falling_piece == null:
        return

    var min_height = _grid.get_size().y
    for block in _falling_piece.blocks:
        var height = _grid.get_number_of_empty_blocks_under(block.get_grid_position())
        min_height = min(min_height, height)

    _falling_piece.try_move_down(min_height)
    _place_piece_and_spawn_next()
    
    _increase_score(min_height * _score_rules.get_hard_drop_score_per_row())

func _on_hold_pressed() -> void:
    if !_is_hold_piece_enabled:
        return

    if !_can_hold_piece || _falling_piece == null:
        return

    _falling_piece = _piece_holder.swap_piece(_falling_piece)
    if _falling_piece != null:
        _falling_piece.add_to_grid_in_position(_grid, _grid.get_spawn_position())
    else:
        _spawn_next_piece_after_delay()

    _can_hold_piece = false
    
func pause() -> void:
    if !_has_lost:
        disable()
        paused.emit()
    else:
        if !_in_game_over_animation:
            _finish_game()

func _finish_game() -> void:
    _piece_that_caused_loss.queue_free()
    _piece_that_caused_loss = null
    game_over.emit()

#endregion

#region SetEnabled

func enable() -> void:
    _is_enabled = false
    set_physics_process(true)
    _input_handler.enable() 

func disable() -> void:
    _is_enabled = true
    set_physics_process(false)
    _input_handler.disable()
    _set_das_enabled(false)
    _set_is_soft_dropping(false)

func reset() -> void:
    disable()
    _spawner.reset()
    _input_handler.reset()
    _grid.reset()
    _piece_holder.reset()
    
    _in_game_over_animation = false
    _has_lost = false

#endregion
