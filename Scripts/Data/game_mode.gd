class_name GameMode
extends Resource

@export var _display_name: String = "Ludreĝimo"

@export var _hard_drop_enabled: bool = true
@export var _hold_piece_enabled: bool = true
@export var _next_pieces_look_ahead: int = 1
@export var _piece_spawn_mode:= Enums.SpawnMode.Random
@export var _split_enabled: bool = true

func get_display_name() -> String:
    return _display_name

func get_hard_drop_enabled() -> bool:
    return _hard_drop_enabled

func get_hold_piece_enabled() -> bool:
    return _hold_piece_enabled

func get_next_pieces_look_ahead() -> int:
    return _next_pieces_look_ahead

func get_piece_spawn_mode() -> Enums.SpawnMode:
    return _piece_spawn_mode

func get_split_enabled() -> bool:
    return _split_enabled
