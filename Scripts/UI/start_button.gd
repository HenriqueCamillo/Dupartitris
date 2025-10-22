class_name StartButton
extends Button

@export var _select_sfx: AudioStream

func _on_focus_entered() -> void:
    AudioManager.instance.play_sfx(_select_sfx)
