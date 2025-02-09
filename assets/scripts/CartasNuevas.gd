extends Button

@export var angulo_x_max: float = 15.0
@export var angulo_y_max: float = 15.0
@export var max_separacion_sombra: float = 50.0

@export_category("Oscillator")
@export var muelle: float = 150.0
@export var friccion: float = 10.0
@export var multiplicador_velocidad: float = 2.0

var desplazamiento: float = 0.0 
var velocidad_oscilador: float = 0.0

var tween_rotacion: Tween
var tween_sobrevolar: Tween
var tween_manejar: Tween

var ultima_posicion_mouse: Vector2
var velocidad_mouse: Vector2
var seguir_raton: bool = false
var ultima_posicion: Vector2
var velocidad: Vector2

@onready var textura_carta = $TexturaCarta
@onready var sombra = $Sombra

var simbolo = 6
var posicion = 0
var seleccionado = 0

func _ready() -> void:
	#enseñar símbolo correcto
	textura_carta.texture.set_current_frame(simbolo)
	# convertimos de grados a radianes para lerp_angle()
	angulo_x_max = deg_to_rad(angulo_x_max)
	angulo_y_max = deg_to_rad(angulo_y_max)

func _process(delta: float) -> void:
	#rotate_velocity(delta)
	seguimiento_raton(delta)
	#manejar_sombra(delta)

#func rotate_velocity(delta: float) -> void:
#	if not seguir_raton:
#		return
#	var posicion_central: Vector2 = global_position - (size/2.0)
#	print("posicion: ", posicion_central)
#	print("posicion: ", ultima_posicion)
	# computar la velocidad
#	velocidad = (posicion - ultima_posicion) / delta
#	ultima_posicion = posicion
	
#	print("velocidad: ", velocidad)
#	velocidad_oscilador += velocidad.normalized().x * multiplicador_velocidad
	
	# cosas del oscilador
#	var force = -spring * displacement - damp * oscillator_velocity
#	oscillator_velocity += force * delta
#	displacement += oscillator_velocity * delta
	
#	rotation = displacement

#func manejar_sombra(delta: float) -> void:
	# Y position is enver changed.
	# Only x changes depending on how far we are from the center of the screen
	#var centro: Vector2 = get_viewport_rect().size / 2.0
	#var distancia: float = global_position.x - centro.x
	
	#sombra.position.x = lerp(0.0, -sign(distancia) * max_separacion_sombra, abs(distancia/(centro.x)))

func seguimiento_raton(delta: float) -> void:
	if not seguir_raton:
		return
	var posicion_raton: Vector2 = get_global_mouse_position()
	global_position = posicion_raton - (size/2.0)

func manejar_click_raton(event: InputEvent) -> void:
	#si no clicamos con el botón que quiero del ratón, devuelve void
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.is_pressed():
		seguir_raton = true
	else:
		# drop card
		seguir_raton = false
		if tween_manejar and tween_manejar.is_running():
			tween_manejar.kill()
		tween_manejar = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_manejar.tween_property(self, "rotation", 0.0, 0.3)

func _on_gui_input(event: InputEvent) -> void:
	
	manejar_click_raton(event)
	
	# Don't compute rotation when moving the card
	if seguir_raton:
		return
	if not event is InputEventMouseMotion:
		return
	
	# Handles rotation
	# Get local mouse pos
	var mouse_pos: Vector2 = get_local_mouse_position()
	#print("Mouse: ", mouse_pos)
	#print("Card: ", position + size)
	var diff: Vector2 = (position + size) - mouse_pos

	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)

	var rotacion_x: float = rad_to_deg(lerp_angle(-angulo_x_max, angulo_x_max, lerp_val_x))
	var rotacion_y: float = rad_to_deg(lerp_angle(angulo_y_max, -angulo_y_max, lerp_val_y))
	
	textura_carta.material.set_shader_parameter("x_rot", rotacion_y)
	textura_carta.material.set_shader_parameter("y_rot", rotacion_x)

func _on_mouse_entered() -> void:
	if tween_sobrevolar and tween_sobrevolar.is_running():
		tween_sobrevolar.kill()
	tween_sobrevolar = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_sobrevolar.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)

func _on_mouse_exited() -> void:
	# Reset rotation
	if tween_rotacion and tween_rotacion.is_running():
		tween_rotacion.kill()
	tween_rotacion = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rotacion.tween_property(textura_carta.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rotacion.tween_property(textura_carta.material, "shader_parameter/y_rot", 0.0, 0.5)
	
	# Reset scale
	if tween_sobrevolar and tween_sobrevolar.is_running():
		tween_sobrevolar.kill()
	tween_sobrevolar = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_sobrevolar.tween_property(self, "scale", Vector2.ONE, 0.55)

func _on_pressed():
	if get_parent().name == "MANO LAZARUS" and Global.interfaz_batalla.modo_seleccion == true:
		if seleccionado == 1:
			seleccionado = 0
			self.position.y += 20
		else:
			seleccionado = 1
			self.position.y -= 20
