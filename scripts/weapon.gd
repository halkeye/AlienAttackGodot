extends TextureButton

enum GunType {
	BASIC,
	FIRESTORM,
	WIDEAREA,
	ZAPPER,
}
@export var gun_type: GunType = GunType.BASIC : set=set_gun_type

@onready var basic_gun_image = preload("res://sprites/weapons/Basic Gun.png")
@onready var firestorm_gun_image = preload("res://sprites/weapons/firestormgun.png")
@onready var widearea_gun_image = preload("res://sprites/weapons/wideareagun.png")
@onready var zapper_gun_image = preload("res://sprites/weapons/zappergun.png")

var bullet_scene = preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_gun_type(type):
	if type == GunType.BASIC:
		$".".set_texture_normal(basic_gun_image)
	elif type == GunType.FIRESTORM:
		$".".set_texture_normal(firestorm_gun_image)
	elif type ==GunType.WIDEAREA:
		$".".set_texture_normal(widearea_gun_image)
	elif type == GunType.ZAPPER:
		$".".set_texture_normal(zapper_gun_image)
	gun_type = type
				
func fire(pos: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.start($".".global_position, (pos - global_position).angle())
	get_tree().root.add_child(bullet)
	return bullet

func next_weapon(): 
	if gun_type == GunType.BASIC:
		gun_type = GunType.FIRESTORM
	elif gun_type == GunType.FIRESTORM:
		gun_type = GunType.WIDEAREA
	elif gun_type == GunType.WIDEAREA:
		gun_type = GunType.ZAPPER
	elif gun_type == GunType.ZAPPER:
		gun_type = GunType.BASIC
		
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				next_weapon()
