class_name ModeSelectButton
extends ButtonWithSubmenu

@onready var _game_modes_container: VBoxContainer = $GameModesVContainer
@onready var _indicator: Label = $Indicator

var _font_color: Color
var _font_focus_color: Color

signal game_mode_selected(game_mode: GameMode)

func _ready() -> void:
    super._ready()
    grab_focus()
    
    _fetch_font_colors()
    _indicator.add_theme_color_override("font_color", _font_color)
    _update_label_position(_submenu_first_selected)
        
    var game_mode_buttons = _game_modes_container.get_children() as Array[GameModeButton]
    for button in game_mode_buttons:
        var game_mode = button.get_game_mode()
        button.mode_focused.connect(_update_label_position)
        
        if game_mode is CustomGameMode:
            button.pressed.connect(_customize_game_mode)
        else:
            button.mode_selected.connect(_select_game_mode)
    
func _customize_game_mode() -> void:
    print("Not implemented: Custom game mode selected")
    grab_focus()
    _indicator.add_theme_color_override("font_color", _font_color)    
    
func _select_game_mode(game_mode_button: GameModeButton) -> void:
    _submenu_first_selected = game_mode_button
    game_mode_selected.emit(game_mode_button.get_game_mode())
    
    grab_focus()
    _indicator.add_theme_color_override("font_color", _font_color)
    _update_label_position(game_mode_button)
    
# Yeah, could be better
func _update_label_position(game_mode_button: GameModeButton) -> void:
    _indicator.global_position.y = game_mode_button.global_position.y

func _fetch_font_colors() -> void:
    _font_color = _indicator.get_theme_color("font_color", "Button")
    _font_focus_color = _indicator.get_theme_color("font_focus_color", "Button")
    
func _show_submenu() -> void:
    super._show_submenu()
    _indicator.add_theme_color_override("font_color", _font_focus_color)
