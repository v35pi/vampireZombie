extends AnimatedSprite2D

var clickable := false
var mouse_in := false
@onready var texto_globo = $"../TEXTO GLOBO"

func _process(delta):
	if Input.is_action_just_pressed("mouse_button_left") and clickable == true and mouse_in == true:
		clickable = false
	if clickable == false:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.15))
		texto_globo.set_modulate(lerp(get_modulate(), Color(0,0,0,0), 0.15))
	else:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0.75), 0.15))
		self.show()
		if texto_globo != null:
			texto_globo.set_modulate(Color(0,0,0,1))
			texto_globo.visible = true

func _on_texto_globo_texto_cambiado():
	clickable = true

func _on_area_2d_mouse_entered():
	mouse_in = true

func _on_area_2d_mouse_exited():
	mouse_in = false
