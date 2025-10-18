class_name Menus
extends CanvasLayer

@export var _main_menu: PressStartScreen
@export var _game_rules_menu: GameRulesMenu

func _ready() -> void:
    _game_rules_menu.hide()
    show_main_menu()

func show_main_menu() -> void:
    _main_menu.pressed_start.connect(_on_pressed_start)
    _main_menu.set_process_input(true)
    _main_menu.show()
    show()
    
func _on_pressed_start() -> void:
    _main_menu.pressed_start.disconnect(_on_pressed_start)
    _main_menu.set_process_input(false)
    _main_menu.hide()
    await Delay.one_frame()
    show_game_rules_menu()
    
func show_game_rules_menu() -> void:
    _game_rules_menu.show_menu()
    show()
