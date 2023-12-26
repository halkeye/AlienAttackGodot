extends Label
@export var values: Array = []
@export var label: String = "" 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$".".text = label % values

func set_values(_values : Array) -> void:
	values = _values
	
func set_label(_value : String) -> void:
	label = _value
	
