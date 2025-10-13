class_name ScoreRules
extends Resource

@export var _scores_by_lines_cleared: Array[int]
@export var _scores_with_splitted_piece: Array[int]

func get_score(lines_cleared: int, is_piece_splitted: bool) -> int:
    var scores = _scores_with_splitted_piece if is_piece_splitted else _scores_by_lines_cleared
    return scores[lines_cleared - 1]
