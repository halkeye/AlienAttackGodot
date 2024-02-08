extends Node

var current_scene = null

signal delta_score(score: int)

var score = 0 : set=set_score
var level = 1

const UFOS_PER_LEVEL: int = 3

func set_score(value):
	var old_score = score
	score = value
	delta_score.emit(score - old_score)

func score_goal(level: int):
	return Global.level * UFOS_PER_LEVEL
	
func _ready():
	pass
