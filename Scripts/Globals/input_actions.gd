extends Node

const action_names := {
	Action.MOVE_LEFT: "move_left",
	Action.MOVE_RIGHT: "move_right",
	Action.HARD_DROP: "hard_drop",
	Action.SOFT_DROP: "soft_drop",
	Action.ROTATE_CLOCKWISE: "rotate_clockwise",
	Action.ROTATE_COUNTERCLOCKWISE: "rotate_counterclockwise",
}

enum Action {
	MOVE_LEFT,
	MOVE_RIGHT,
	HARD_DROP,
	SOFT_DROP,
	ROTATE_CLOCKWISE,
	ROTATE_COUNTERCLOCKWISE,
}

func get_action_name(action: Action) -> String:
	if !action_names.has(action):
		push_error("Missing action name for action %s" % Action.keys()[action])
		return "";
		
	return action_names[action]
	
	
