extends Node

@export var mano_claribel: Mano
@export var texto_mano_claribel: Label
@export var emociones_claribel: AnimatedSprite2D
@export var texto_bocadillo: Label

@export var mano_lazarus: Mano
@export var texto_mano_lazarus: Label
@export var emociones_lazarus: AnimatedSprite2D

@onready var boton_finalizar = $"BOTON FINALIZAR"
@onready var boton_nueva_partida = $"BOTON NUEVA PARTIDA"
@onready var boton_cambiar_cartas = $"BOTON CAMBIAR CARTAS"
@onready var boton_jugar_mano = $"BOTON JUGAR MANO"
@export var contador_victorias: Label

var modo_seleccion = false

func _enter_tree():
	Global.interfaz_batalla = self

var descoloque := 2:
	set(value):
		descoloque = clamp(value,0,4)
var rondas_restantes := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	emociones_lazarus.hide()
	mano_lazarus.show()
	boton_cambiar_cartas.hide()
	boton_jugar_mano.hide()
	boton_finalizar.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	contador_victorias.set_text("RONDAS RESTANTES: " + str(rondas_restantes))
	if descoloque == 4:
		boton_nueva_partida.hide()
		boton_finalizar.show()
		texto_bocadillo.set_text("¡Já! ¡Has perdido y mereces morir!")
	elif descoloque == 0:
		boton_nueva_partida.hide()
		boton_finalizar.show()
		texto_bocadillo.set_text("¡Eres un tramposo! ¡Estás muerto!")
	elif rondas_restantes == 0:
		boton_nueva_partida.hide()
		boton_finalizar.show()
		texto_bocadillo.set_text("Ya me cansé de jugar, seguimos\njugando mañana, ¿vale?")
	else:
		if mano_claribel.escondido == true:
			for child in mano_claribel.get_children():
				child.get_child(0).texture.set_current_frame(6)
		else:
			for child in mano_claribel.get_children():
				child.get_child(0).texture.set_current_frame(child.simbolo)
		if mano_lazarus.get_children() != []:
			for child in mano_lazarus.get_children():
				if modo_seleccion == false:
					mano_lazarus.array_seleccion = [0, 0, 0, 0, 0]
					child.seleccionado = 0
				else:
					mano_lazarus.array_seleccion[child.posicion] = child.seleccionado
					if mano_lazarus.array_seleccion != [0, 0, 0, 0, 0]:
						boton_cambiar_cartas.show()
						boton_jugar_mano.hide()
						if rondas_restantes == 10:
							texto_bocadillo.set_text("Recuerda que solo puedes cambiar\ntus cartas una vez.")
					else:
						if rondas_restantes == 10:
							texto_bocadillo.set_text("Intenta hacer la mejor mano.\nSi quieres, puedes cambiar las cartas\nque tú elijas.")
						boton_cambiar_cartas.hide()
						boton_jugar_mano.show()


func _on_boton_nueva_partida_pressed():
	mano_claribel.escondido = true
	mano_claribel.nueva_partida()
	mano_lazarus.nueva_partida()
	texto_mano_lazarus.set_text("")
	texto_mano_claribel.set_text("")
	boton_nueva_partida.hide()
	boton_jugar_mano.show()
	modo_seleccion = true

func _on_boton_cambiar_cartas_pressed():
	mano_lazarus.cambiar_cartas()
	texto_bocadillo.set_text("¡Veamos qué es lo que tienes!")
	boton_cambiar_cartas.hide()
	boton_jugar_mano.show()
	modo_seleccion = false

func _on_boton_jugar_mano_pressed():
	mano_claribel.escondido = false
	#jugamos manos
	mano_claribel.jugar_mano()
	mano_lazarus.jugar_mano()
	#ponemos texto
	texto_mano_lazarus.set_text(mano_lazarus.resultado[0])
	texto_mano_claribel.set_text(mano_claribel.resultado[0])
	#veredicto final
	if mano_lazarus.resultado[1][0] > mano_claribel.resultado[1][0]:
		texto_bocadillo.set_text("Has ganado...")
		descoloque -= 1
	else:
		if mano_lazarus.resultado[1][0] == mano_claribel.resultado[1][0]:
			if mano_lazarus.resultado[1][1] > mano_claribel.resultado[1][1]:
				texto_bocadillo.set_text("Has ganado...")
				descoloque -= 1
			else:
				if mano_lazarus.resultado[1][1] == mano_claribel.resultado[1][1]:
					if mano_lazarus.resultado[1][2] > mano_claribel.resultado[1][2]:
						texto_bocadillo.set_text("Has ganado...")
						descoloque -= 1
					else:
						if mano_lazarus.resultado[1][2] == mano_claribel.resultado[1][2]:
							texto_bocadillo.set_text("¿Hemos empatado? ¿Qué\nposibilidad había?")
						else:
							texto_bocadillo.set_text("¡He ganado!")
							descoloque += 1
				else:
					texto_bocadillo.set_text("¡He ganado!")
					descoloque += 1
		else:
			texto_bocadillo.set_text("¡He ganado!")
			descoloque += 1
	rondas_restantes -= 1
	boton_jugar_mano.hide()
	boton_nueva_partida.show()
	modo_seleccion = false

func _on_boton_finalizar_pressed():
	get_tree().change_scene_to_file("res://scenes/MenuPrincipal.tscn")

func _on_emociones_lazarus_cambio_personaje():
	emociones_lazarus.visible = false
	emociones_claribel.visible = true

func _on_emociones_claribel_cambio_personaje():
	emociones_lazarus.visible = true
	emociones_claribel.visible = false
