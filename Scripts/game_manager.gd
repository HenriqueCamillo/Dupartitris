extends Node2D

@export_group("Node References")
@export var _tetris_manager: TetrisManager
@export var _pause_ui: PauseUI
@export var _score_ui: LabelValueUI
@export var _cleared_lines_ui: LabelValueUI
@export var _level_ui: LabelValueUI
@export var _menus: Menus

@export_group("Music and SFX")
@export var _menu_music: AudioStream
@export var _gameplay_music: AudioStream
@export var _pause_in_sfx: AudioStream
@export var _pause_out_sfx: AudioStream


func _ready() -> void:
    _tetris_manager.disable()
    
func _on_paused() -> void:
    _pause_ui.show_ui()
    AudioManager.instance.pause_music()
    AudioManager.instance.play_sfx(_pause_in_sfx)
    
func _on_unpaused() -> void:
    await Delay.one_frame()
    _tetris_manager.enable()
    AudioManager.instance.resume_music()
    AudioManager.instance.play_sfx(_pause_out_sfx)

func _on_score_changed(score: int) -> void:
    _score_ui.set_value(score)

func _on_lines_cleared_changed(lines_cleared: int) -> void:
    _cleared_lines_ui.set_value(lines_cleared)

func _on_level_changed(level: int) -> void:
    _level_ui.set_value(level)
    
func _on_pressed_play() -> void:
    _tetris_manager.start_game(0)
    AudioManager.instance.play_music(_gameplay_music)

func _on_game_over() -> void:
    _tetris_manager.reset()
    _menus.show_main_menu()
    AudioManager.instance.play_music(_menu_music)
