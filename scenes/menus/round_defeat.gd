extends CanvasLayer

signal back

func _on_back_btn_pressed():
	back.emit()
