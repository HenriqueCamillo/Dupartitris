class_name Menus
extends CanvasLayer

@export var _main_menu: PressStartScreen

signal pressed_play()

func _ready() -> void:
    show_main_menu()

func show_main_menu() -> void:
    _main_menu.pressed_start.connect(_on_pressed_start)
    _main_menu.set_process_input(true)
    _main_menu.show()
    
func _on_pressed_start() -> void:
    _main_menu.pressed_start.disconnect(_on_pressed_start)
    _main_menu.set_process_input(false)
    _main_menu.hide()
    await Delay.one_frame()
    _transition_to_mode_select()
    
func _transition_to_mode_select() -> void:
    pressed_play.emit()



    
