extends Node2D

@export var _tetris_manager: TetrisManager
@export var _pause_ui: PauseUI
@export var _score_ui: LabelValueUI
@export var _cleared_lines_ui: LabelValueUI
@export var _level_ui: LabelValueUI

func _on_paused() -> void:
    _pause_ui.show_ui()
    
func _on_unpaused() -> void:
    await Delay.one_frame()
    _tetris_manager.unpause()

func _on_score_changed(score: int) -> void:
    _score_ui.set_value(score)

func _on_lines_cleared_changed(lines_cleared: int) -> void:
    _cleared_lines_ui.set_value(lines_cleared)

func _on_level_changed(level: int) -> void:
    _level_ui.set_value(level)
