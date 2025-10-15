class_name ScoreRules
extends Resource

@export var _scores_by_lines_cleared: Array[int]
@export var _scores_with_splitted_piece: Array[int]

@export var _soft_drop_score_per_row: int
@export var _hard_drop_score_per_row: int

func get_score(lines_cleared: int, is_piece_splitted: bool) -> int:
    var scores = _scores_with_splitted_piece if is_piece_splitted else _scores_by_lines_cleared
    return scores[lines_cleared - 1]

func get_soft_drop_score_per_row() -> int:
    return _soft_drop_score_per_row

func get_hard_drop_score_per_row() -> int:
    return _hard_drop_score_per_row
