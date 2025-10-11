class_name PauseUI
extends Control

signal unpaused()

var _is_active: bool = true

func _ready() -> void:
    hide_ui()

func show_ui() -> void:
    if _is_active:
        return
        
    _is_active = true
    show()
    set_process_input(true)
    
func hide_ui() -> void:
    if !_is_active:
        return
        
    _is_active = false
    hide()
    set_process_input(false)
    
func _unpause() -> void:
    if !_is_active:
        return
        
    _is_active = false
    set_process_input(false)
    
    await Delay.one_frame()
    
    hide()
    unpaused.emit()
    
func _input(event: InputEvent) -> void:
    if !_is_active:
        return
        
    if event.is_action_pressed("pause"):
        _unpause()
