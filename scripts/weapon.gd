extends TextureButton

enum GunType {
	BASIC,
	FIRESTORM,
	WIDEAREA,
	ZAPPER,
}
@export var gun_type: GunType = GunType.BASIC : set=set_gun_type

var basic_gun_image = preload("res://sprites/weapons/Basic Gun.png")
var firestorm_gun_image = preload("res://sprites/weapons/firestormgun.png")
var widearea_gun_image = preload("res://sprites/weapons/wideareagun.png")
var zapper_gun_image = preload("res://sprites/weapons/zappergun.png")
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
				
func fire(pos: Vector2) -> void:
	var start_pos = $".".global_position
	var bullet = bullet_scene.instantiate()
	print(pos)
	if gun_type == GunType.ZAPPER:
		$LightningGenerator.generate(get_parent(), start_pos, pos)
		# create the bullet
		bullet.position = pos
		bullet.visible = false
		get_parent().add_child(bullet)
		# let it collide
		await get_parent().get_tree().physics_frame 
		# well twice, so it actually collides
		await get_parent().get_tree().physics_frame 
		# remove it
		bullet.call_deferred("queue_free")
		return
	
	bullet.start(start_pos, (pos - start_pos).angle())
	get_parent().add_child(bullet)

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
