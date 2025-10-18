class_name InitialLevelButton
extends ButtonWithSubmenu

@export var _level_adjuster: InitialLevelAdjuster

signal intial_level_selected(level: int)

func _ready() -> void:
    super._ready()
    _level_adjuster.pressed.connect(_confirm_level)
    
func _exit_tree() -> void:
    _level_adjuster.pressed.disconnect(_confirm_level)
    
func _confirm_level() -> void:
    grab_focus()
    intial_level_selected.emit(_level_adjuster.get_level())
