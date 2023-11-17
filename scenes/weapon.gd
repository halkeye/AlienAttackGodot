extends Node2D

@export_enum("Basic", "Firestorm", "Widearea", "Zapper") var gun_type: String = "Basic" : set=set_gun_type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_gun_type(type):
	$BasicGun.hide()
	$Firestormgun.hide()
	$Wideareagun.hide()
	$Zappergun.hide()
	
	if type == "Basic":
		$BasicGun.show()
	elif type == "Firestorm":
		$Firestormgun.show()
	elif type == "Widearea":
		$Wideareagun.show()
	elif type == "Zapper":
		$Zappergun.show()
