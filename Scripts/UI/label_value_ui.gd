class_name LabelValueUI
extends Label

@export var _title: String
@export var _digits_to_show: int = 2

var _text_template: String:
    get:
        return "%s\n%0" + str(_digits_to_show) + "d"

func set_value(value: Variant) -> void:
    text = _text_template % [_title, value]
