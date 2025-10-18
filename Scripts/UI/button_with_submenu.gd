class_name ButtonWithSubmenu
extends Button

@export var _submenu_first_selected : Control

func _ready() -> void:
    pressed.connect(_show_submenu)

func _exit_tree() -> void:
    pressed.disconnect(_show_submenu)

func _show_submenu() -> void:
    _submenu_first_selected.grab_focus()
    
