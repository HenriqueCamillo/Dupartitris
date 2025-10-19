class_name GameRules
extends RefCounted

# From GameMode
var hard_drop_enabled: bool = true
var hold_piece_enabled: bool = false
var next_pieces_look_ahead: int = 1
var piece_spawn_mode: = Enums.SpawnMode.Random
var split_enabled: bool = true

# Custom variables
var initial_level: int = 0

func set_game_mode_options(game_mode: GameMode) -> void:
    hard_drop_enabled = game_mode.get_hard_drop_enabled()
    hold_piece_enabled = game_mode.get_hold_piece_enabled()
    next_pieces_look_ahead = game_mode.get_next_pieces_look_ahead()
    piece_spawn_mode = game_mode.get_piece_spawn_mode()
    split_enabled = game_mode.get_split_enabled()

static func create_from_game_mode(game_mode: GameMode, start_level: int = 0) -> GameRules:
    var instance = GameRules.new()
    instance.set_game_mode_options(game_mode)
    instance.initial_level = start_level
    return instance
