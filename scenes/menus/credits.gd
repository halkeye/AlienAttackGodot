extends ColorRect

@export var base_speed = 100.0

@onready var markdown_label : MarkdownLabel = %MarkdownLabel

var line = 0.0

func _ready():
	markdown_label.display_file("res://credits.md")
	markdown_label.position.y = get_viewport().size.y + 10

func _process(delta):
	markdown_label.position.y -= base_speed * delta
	if markdown_label.position.y + markdown_label.get_content_height() < 0:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(load("res://scenes/menus/main_menu.tscn"))
