extends AnimatedSprite2D

var mouse_in = false
var simbolo = 6
var posicion = 0
var seleccionado = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_frame(simbolo)
	scale = Vector2(0.5, 0.5)

func _on_area_2d_mouse_entered():
	mouse_in = true

func _on_area_2d_mouse_exited():
	mouse_in = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().name == "MANO LAZARUS" and Global.interfaz_batalla.modo_seleccion == true:
		if mouse_in == true:
			scale = Vector2(0.55, 0.55)
		else:
			scale = Vector2(0.5, 0.5)
		if Input.is_action_just_pressed("mouse_button_left") and mouse_in == true:
			if seleccionado == 1:
				seleccionado = 0
				position.y += 20
			else:
				seleccionado = 1
				position.y -= 20
