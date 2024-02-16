extends TextureButton

enum GunType {
	BASIC,
	FIRESTORM,
	WIDEAREA,
	ZAPPER,
}
@export var gun_type: GunType = GunType.BASIC : set=set_gun_type

var bullet = null

var basic_gun_image = preload("res://sprites/weapons/Basic Gun.png")
var firestorm_gun_image = preload("res://sprites/weapons/firestormgun.png")
var widearea_gun_image = preload("res://sprites/weapons/wideareagun.png")
var zapper_gun_image = preload("res://sprites/weapons/zappergun.png")

func _unhandled_input(event):
	if event.is_action_pressed("weapon_switch"):
		next_weapon()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				fire(get_global_mouse_position())

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				next_weapon()
					
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
	if bullet != null:
		# can't fire while firing
		return
		
	var start_pos = $".".global_position

	if gun_type == GunType.ZAPPER:
		bullet = $BulletZapper.duplicate()
	if gun_type == GunType.BASIC:
		bullet = $BulletBasic.duplicate()
	if gun_type == GunType.FIRESTORM:
		bullet = $BulletFirestorm.duplicate()
	if gun_type == GunType.WIDEAREA:
		bullet = $BulletWideArea.duplicate()
		
	bullet.global_position = start_pos
	bullet.show()
	get_parent().add_child(bullet)
	bullet.start(start_pos, target_pos)
	
func next_weapon(): 
	if gun_type == GunType.BASIC:
		gun_type = GunType.FIRESTORM
	elif gun_type == GunType.FIRESTORM:
		gun_type = GunType.WIDEAREA
	elif gun_type == GunType.WIDEAREA:
		gun_type = GunType.ZAPPER
	elif gun_type == GunType.ZAPPER:
		gun_type = GunType.BASIC

func _on_child_exiting_tree(node):
	if node == bullet:
		bullet = null
		
func weapon():
	if bullet != null:
		bullet.queue_free()
