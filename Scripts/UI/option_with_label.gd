class_name OptionWithLabel
extends HBoxContainer

var _font_color: Color
var _font_focus_color: Color

@onready var _selectable_option: SelectableOption = $SelectableOption
@onready var _option_name: Label = $OptionName

signal confirmed

func _ready() -> void:
    _fetch_font_colors()
    _set_normal_color()
    
    _selectable_option.focus_entered.connect(_set_focus_color)
    _selectable_option.focus_exited.connect(_set_normal_color)
    _selectable_option.pressed.connect(_confirm)
    
func _exit_tree() -> void:
    _selectable_option.focus_entered.disconnect(_set_focus_color)
    _selectable_option.focus_exited.disconnect(_set_normal_color)
    _selectable_option.pressed.disconnect(_confirm)
    
func _set_focus_color() -> void:
    _option_name.add_theme_color_override("font_color", _font_focus_color)
    
func _set_normal_color() -> void:
    _option_name.add_theme_color_override("font_color", _font_color)
    
func _fetch_font_colors() -> void:
    _font_color = get_theme_color("font_color", "Button")
    _font_focus_color = get_theme_color("font_focus_color", "Button")
    
func get_selected_option() -> int:
    return _selectable_option.get_selected_option()

func set_option(index: int) -> void:
    _selectable_option.set_option(index)
    
func _confirm() -> void:
    confirmed.emit()
    
    
    
