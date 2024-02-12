extends CanvasLayer

signal next_level

func _on_label_pressed():
	next_level.emit()
