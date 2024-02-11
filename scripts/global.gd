extends Node

const UFOS_PER_LEVEL: int = 3

func score_goal(level: int):
	return Global.level * UFOS_PER_LEVEL

