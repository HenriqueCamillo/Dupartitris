extends Node2D

@export_group("Node References")
@export var _tetris_manager: TetrisManager
@export var _pause_ui: PauseUI
@export var _score_ui: LabelValueUI
@export var _cleared_lines_ui: LabelValueUI
@export var _level_ui: LabelValueUI
@export var _menus: Menus
@export var _next_pieces_ui: Label
@export var _hold_piece_ui: Label
@export var _high_score_label: Label

@export_group("Music and SFX")
@export var _menu_music: AudioStream
@export var _gameplay_music: AudioStream
@export var _pause_in_sfx: AudioStream

@export_group("Game Rules")
@export var _game_mode: GameMode
@export var _initial_level: int

@export_group("SaveData")
@export var _save_data: SaveData

func _ready() -> void:
    _load()
    _update_high_score_label()
    
    _tetris_manager.disable()
    
func _on_paused() -> void:
    _pause_ui.show_ui()
    AudioManager.instance.pause_music()
    AudioManager.instance.play_sfx(_pause_in_sfx)
    
func _on_unpaused() -> void:
    await Delay.one_frame()
    _tetris_manager.enable()
    AudioManager.instance.resume_music()
    
func _save() -> void:
    ResourceSaver.save(_save_data, _save_data.PATH)
    
func _load() -> void:
    var _loaded_data = ResourceLoader.load(_save_data.PATH)
    if _loaded_data != null:
        _save_data = _loaded_data

func _on_score_changed(score: int) -> void:
    _score_ui.set_value(score)

func _on_lines_cleared_changed(lines_cleared: int) -> void:
    _cleared_lines_ui.set_value(lines_cleared)

func _on_level_changed(level: int) -> void:
    _level_ui.set_value(level)
    
func _on_set_new_score(score: int) -> void:
    var _game_mode_hash = _game_mode.hash()
    var current_score = _save_data.high_scores[_game_mode_hash] if _save_data.high_scores.has(_game_mode_hash) else 0
    if score <= current_score:
        return
        
    _save_data.high_scores[_game_mode_hash] = score
    _save()
    _update_high_score_label()

func _on_game_over() -> void:
    await Delay.one_frame()
    _tetris_manager.reset()
    _menus.show_game_rules_menu()
    AudioManager.instance.play_music(_menu_music)

func _on_game_mode_selected(game_mode: GameMode) -> void:
    _game_mode = game_mode
    _update_high_score_label()

func _on_game_mode_focused(game_mode: GameMode) -> void:
    _update_high_score_label(game_mode)

func _on_start_pressed() -> void:
    var game_rules: GameRules
    if _game_mode == null:
        game_rules = GameRules.new()
    else:
        game_rules = GameRules.create_from_game_mode(_game_mode, _initial_level)

    _tetris_manager.set_game_rules(game_rules)
    _tetris_manager.start_game()
    
    _upate_ui_according_to_game_rules(game_rules)
    _menus.hide()

    AudioManager.instance.play_music(_gameplay_music)
    
func _upate_ui_according_to_game_rules(game_rules: GameRules) -> void:     
    _hold_piece_ui.visible = game_rules.hold_piece_enabled
    _next_pieces_ui.visible = game_rules.next_pieces_look_ahead > 0
    if _next_pieces_ui.visible:
        _next_pieces_ui.text = "Sekva" if game_rules.next_pieces_look_ahead == 1 else "Sekvaj"

func _on_initial_level_selected(level: int) -> void:
    _initial_level = level

func _update_high_score_label(game_mode: GameMode = _game_mode) -> void:
    var _game_mode_hash = game_mode.hash()
    var high_score = _save_data.high_scores[_game_mode_hash] if _save_data.high_scores.has(_game_mode_hash) else 0
    _high_score_label.text = "Plej Bona\n%06d" % high_score
