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
var bullet_expanding_scene = preload("res://scenes/bullet_expanding.tscn")

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
				
func fire(target_pos: Vector2) -> void:
	if is_fireing():
		# can't fire while firing
		return
		
	var start_pos = $".".global_position
	var bullet = bullet_scene.instantiate() # FIXME

	if gun_type == GunType.ZAPPER:
		var generator = $LightningGenerator.duplicate()
		var on_done = func():
			if bullet != null: # no collision
				bullet.call_deferred("queue_free")
		generator.lightning_done.connect(on_done)
		generator.generate(get_parent(), start_pos, target_pos)
		# create the bullet
		bullet.position = target_pos
		bullet.visible = false
		get_parent().add_child(bullet)
		$LightingSoundPlayer.seek(0.0)
		$LightingSoundPlayer.play()
		return
	if gun_type == GunType.BASIC:
		$BasicGunSoundPlayer.seek(0.0)
		$BasicGunSoundPlayer.play()
	if gun_type == GunType.FIRESTORM:
		$FirestormSoundPlayer.seek(0.0)
		$FirestormSoundPlayer.play()
	if gun_type == GunType.WIDEAREA:
		$WideAreaSoundPlayer.seek(0.0)
		$WideAreaSoundPlayer.play()
		bullet = bullet_expanding_scene.instantiate()
		
	bullet.start(start_pos, target_pos)
	get_parent().add_child(bullet)

func is_fireing() -> bool:
	return $LightingSoundPlayer.playing || $BasicGunSoundPlayer.playing ||$WideAreaSoundPlayer.playing || $FirestormSoundPlayer.playing
	
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
