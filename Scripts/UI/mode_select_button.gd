class_name ModeSelectButton
extends ButtonWithSubmenu

@onready var _game_modes_container: VBoxContainer = $GameModesVContainer
@onready var _indicator: Label = $Indicator
@onready var _game_mode_displayer: GameModeDisplayer = $GameModeDisplayer

var _font_color: Color
var _font_focus_color: Color

signal game_mode_selected(game_mode: GameMode)
signal game_mode_focused(game_mode: GameMode)

func _ready() -> void:
    super._ready()
    
    _game_mode_displayer.customization_finished.connect(_select_game_mode)
    _game_mode_displayer.customized_game_mode.connect(_on_customized_game_mode)
    _game_mode_displayer.show_game_mode_options(_submenu_first_selected.get_game_mode())
    
    _fetch_font_colors()
    _indicator.add_theme_color_override("font_color", _font_color)
    _update_label_position(_submenu_first_selected)
        
    var game_mode_buttons = _game_modes_container.get_children() as Array[GameModeButton]
    for button in game_mode_buttons:
        var game_mode = button.get_game_mode()
        button.mode_focused.connect(_update_focused_game_mode)
        
        if game_mode is CustomGameMode:
            button.mode_selected.connect(_customize_game_mode)
        else:
            button.mode_selected.connect(_select_game_mode_from_button)

func _exit_tree() -> void:
    _game_mode_displayer.customization_finished.disconnect(_select_game_mode)
    _game_mode_displayer.customized_game_mode.disconnect(_on_customized_game_mode)
    
func _customize_game_mode(game_mode_button: GameModeButton) -> void:
    var custom_game_mode = game_mode_button.get_game_mode()
    _game_mode_displayer.customize_game_mode(custom_game_mode)
    _submenu_first_selected = game_mode_button
    
func _select_game_mode_from_button(game_mode_button: GameModeButton) -> void:
    _submenu_first_selected = game_mode_button
    _update_label_position(game_mode_button)
    _select_game_mode(game_mode_button.get_game_mode())
    
func _select_game_mode(game_mode: GameMode) -> void:
    grab_focus()
    _update_label_position(_submenu_first_selected)
    _indicator.add_theme_color_override("font_color", _font_color)
    game_mode_selected.emit(game_mode)
    
func _on_customized_game_mode(game_mode: GameMode):
    game_mode_focused.emit(game_mode)
    
    
func _update_focused_game_mode(game_mode_button: GameModeButton) -> void:
    var game_mode = game_mode_button.get_game_mode()
    _game_mode_displayer.show_game_mode_options(game_mode)
    _update_label_position(game_mode_button)
    game_mode_focused.emit(game_mode)
    
func _update_label_position(game_mode_button: GameModeButton) -> void:
    _indicator.global_position.y = game_mode_button.global_position.y

func _fetch_font_colors() -> void:
    _font_color = _indicator.get_theme_color("font_color", "Button")
    _font_focus_color = _indicator.get_theme_color("font_focus_color", "Button")
    
func _show_submenu() -> void:
    super._show_submenu()
    _indicator.add_theme_color_override("font_color", _font_focus_color)
