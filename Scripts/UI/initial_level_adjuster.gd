class_name InitialLevelAdjuster
extends Button

var _level: int = 0

func _ready() -> void:
    set_process_input(false)
    focus_entered.connect(_on_gain_focus)
    focus_exited.connect(_on_lose_focus)
    
    _set_level(0)
    
func _exit_tree() -> void:
    focus_entered.disconnect(_on_gain_focus)
    focus_exited.disconnect(_on_lose_focus)

func _input(event: InputEvent) -> void:
    if event.is_echo():
        return
      
    if event.is_action_pressed("ui_right"):
        _set_level(_level + 1)   
    elif event.is_action_pressed("ui_left"):
      _set_level(_level - 1) 
        
func _set_level(value: int) -> void:
    _level = (value + Constants.MAX_LEVEL + 1) % (Constants.MAX_LEVEL + 1)
    text = "<%02d>" % _level
    
func get_level() -> int:
    return _level

func _on_gain_focus() -> void:
    set_process_input(true)
    
func _on_lose_focus() -> void:
    set_process_input(false)
    
    
