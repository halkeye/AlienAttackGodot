extends Node
class_name FullScreenImage

@export var image: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y

	var scale = min(
		viewportWidth / image.texture.get_size().x,
		viewportHeight / image.texture.get_size().y,
	)
		

	# Optional: Center the sprite, required only if the sprite's Offset>Centered checkbox is set
	image.set_position(Vector2(viewportWidth/2, viewportHeight/2))

	# Set same scale value horizontally/vertically to maintain aspect ratio
	# If however you don't want to maintain aspect ratio, simply set different
	# scale along x and y
	image.set_scale(Vector2(scale, scale))
