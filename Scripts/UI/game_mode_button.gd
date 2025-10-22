class_name GameModeButton
extends Button

@export var _game_mode: GameMode
@export var _select_sfx: AudioStream

signal mode_focused(game_mode: GameModeButton)
signal mode_selected(game_mode: GameModeButton)

func _ready() -> void:
    text = _game_mode.get_display_name()
    pressed.connect(_on_pressed)
    focus_entered.connect(_on_focus_entered)
    
func _exit_tree() -> void:
    focus_entered.disconnect(_on_focus_entered)
    
func _on_focus_entered() -> void:
    AudioManager.instance.play_sfx(_select_sfx)
    mode_focused.emit(self)

func _on_pressed() -> void:
    mode_selected.emit(self)

func get_game_mode() -> GameMode:
    return _game_mode
