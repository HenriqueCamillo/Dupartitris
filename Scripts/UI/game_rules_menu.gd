class_name GameRulesMenu
extends Control

@export var _first_selected: Control

func show_menu() -> void:
    show()
    _first_selected.grab_focus()
