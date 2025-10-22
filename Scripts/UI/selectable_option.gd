class_name SelectableOption
extends Button

@export var _options: Array[String] = [ "Ne", "Jes" ]
@export var _selected_option: int

@export var _select_sfx: AudioStream
@export var _change_selection_sfx: AudioStream


signal option_selected(index: int)

func _ready() -> void:
    set_process_input(false)
    focus_entered.connect(_on_gain_focus)
    focus_exited.connect(_on_lose_focus)
    
    set_option(_selected_option)

func _exit_tree() -> void:
    focus_entered.disconnect(_on_gain_focus)
    focus_exited.disconnect(_on_lose_focus)

func _input(event: InputEvent) -> void:
    if event.is_echo():
        return
      
    if event.is_action_pressed("ui_right"):
        _select_option(_selected_option + 1)
    elif event.is_action_pressed("ui_left"):
        _select_option(_selected_option - 1) 
           
func _select_option(value: int) -> void:
    AudioManager.instance.play_sfx(_change_selection_sfx)
    set_option(value)
    option_selected.emit(_selected_option)

func get_selected_option() -> int:
    return _selected_option
    
func set_option(option: int) -> void:
    _selected_option = (option + _options.size()) % (_options.size())
    text = "<%s>" % _options[_selected_option]
    
func _on_gain_focus() -> void:
    AudioManager.instance.play_sfx(_select_sfx)
    set_process_input(true)
    
func _on_lose_focus() -> void:
    set_process_input(false) 
