extends Node2D

@export var _tetris_manager: TetrisManager
@export var _pause_ui: PauseUI

func _on_paused() -> void:
    _pause_ui.show_ui()
    
func _on_unpaused() -> void:
    await Delay.one_frame()
    _tetris_manager.unpause()
