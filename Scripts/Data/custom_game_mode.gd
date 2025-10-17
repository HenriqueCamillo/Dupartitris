class_name CustomGameMode
extends GameMode

func set_hard_drop_enabled(value: bool) -> void:
    _hard_drop_enabled = value

func set_hold_piece_enabled(value: bool) -> void:
    _hold_piece_enabled = value

func set_next_pieces_look_ahead(value: int) -> void:
    _next_pieces_look_ahead = value

func set_piece_spawn_mode(value: Enums.SpawnMode) -> void:
    _piece_spawn_mode = value

func set_split_enabled(value: bool) -> void:
    _split_enabled = value

func copy_from(source_game_mode: GameMode) -> void:
    _hard_drop_enabled = source_game_mode.get_hard_drop_enabled()
    _hold_piece_enabled = source_game_mode.get_hold_piece_enabled()
    _next_pieces_look_ahead = source_game_mode.get_next_pieces_look_ahead()
    _piece_spawn_mode = source_game_mode.get_piece_spawn_mode()
    _split_enabled = source_game_mode.get_split_enabled()
