extends Node

var actions : Dictionary[ActionId, InputAction]

const _ACTION_NAMES: Dictionary[ActionId, String] = {
	ActionId.MOVE_LEFT: "move_left",
	ActionId.MOVE_RIGHT: "move_right",
	ActionId.HARD_DROP: "hard_drop",
	ActionId.SOFT_DROP: "soft_drop",
	ActionId.ROTATE_CLOCKWISE: "rotate_clockwise",
	ActionId.ROTATE_COUNTERCLOCKWISE: "rotate_counterclockwise",
}

enum ActionId {
	MOVE_LEFT,
	MOVE_RIGHT,
	HARD_DROP,
	SOFT_DROP,
	ROTATE_CLOCKWISE,
	ROTATE_COUNTERCLOCKWISE,
}

func _ready() -> void:
	for action_id in _ACTION_NAMES:
		var action_name = _ACTION_NAMES[action_id]
		var action = InputAction.new(action_name)
		actions[action_id] = action

func _input(event: InputEvent) -> void:
	for action_id in actions:
		var action = actions[action_id]
		if event.is_action(action.name):
			action.is_pressed = event.is_pressed()
			break

func get_action_name(action_id: ActionId) -> String:
	if !_ACTION_NAMES.has(action_id):
		push_error("Missing action name for actionId %s" % ActionId.keys()[action_id])
		return "";
		
	return _ACTION_NAMES[action_id]


class InputAction:
	signal changed(value: bool)
	var name: String
	
	var is_pressed: bool:
		set(value):
			if is_pressed == value:
				return
			is_pressed = value
			changed.emit(value)	

	@warning_ignore("shadowed_variable")
	func _init(name: String) -> void:
		self.name = name
