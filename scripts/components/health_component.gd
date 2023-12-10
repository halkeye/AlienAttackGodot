extends Node
class_name HealthComponent

signal health_depleted

@export_group("Health")
var health: int = 1 : set=set_health
@export var max_health:int = 1

func _ready():
	health = max_health
	
func set_health(value : int) -> void:
	health = value
	if is_dead():
		# Now its dead, let everyone know
		health_depleted.emit()

func damage(amount: int = 1) -> bool:
	if is_dead():
		# dead things can't take damage
		return false
		
	health -= amount
	return true
			
func is_dead():
	return health <= 0
