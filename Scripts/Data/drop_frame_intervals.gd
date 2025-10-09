class_name DropFrameIntervals
extends Resource

const _ONE_SECOND_INTERVAL: int= 60

@export var _level_transitions: Dictionary[int, int]
@export var _soft_drop_interval: int
@export var _lines_to_level_up: int = 10

func get_frames_per_drop_in_level(level: int) -> int:
    if _level_transitions.has(level):
        return _level_transitions[level]

    while level > 0:
        level -= 1
        if _level_transitions.has(level):
            return _level_transitions[level]

    push_error("Level 0 does not have a _level_transitions set. Using one second as interval")
    return _ONE_SECOND_INTERVAL

func is_transition_level(level: int) -> int:
    return _level_transitions.has(level)
    

func get_frames_per_soft_drop() -> int:
    return _soft_drop_interval

func get_lines_to_level_up() -> int:
    return _lines_to_level_up
