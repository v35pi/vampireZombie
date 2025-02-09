class_name Emociones

extends AnimatedSprite2D

var mouse_in = false
signal cambio_personaje

func _on_area_2d_mouse_entered():
	mouse_in = true

func _on_area_2d_mouse_exited():
	mouse_in = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_button_left") and mouse_in == true:
		cambio_personaje.emit()

func _on_area_claribel_mouse_entered():
	pass # Replace with function body.
