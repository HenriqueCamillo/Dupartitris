class_name PressStartScreen
extends Control

signal pressed_start()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        pressed_start.emit()
