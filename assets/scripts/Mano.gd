class_name Mano

extends Node

const CARTAS_MANO = preload("res://scenes/CartasNuevas.tscn")
#variable con el nodo de las cartas

var mano_poker := [0, 0, 0, 0, 0] #mano de póker vacía
var array_seleccion := [0, 0, 0, 0, 0]
var agrupaciones_mano := []
var resultado := []
var escondido = false

func generar_mano_aleatoria(mano_poker): #bastante explicativo
	for i in range(5): #for de 5
		mano_poker[i] = randi() % 6 #llena el array[i] con un número del 0 al 5

func dibujar_cartas(posicion, categoria): #imprimir dibujos en pantalla
	var dibujo_impreso = CARTAS_MANO.instantiate() #crear carta
	dibujo_impreso.posicion = posicion #decir a la carta en dónde está
	dibujo_impreso.simbolo = categoria #decir a la carta qué símbolo es
	dibujo_impreso.position.x = posicion * 50 - 100 #separación
	add_child(dibujo_impreso) #añadir como hijo

func orden_final_mano_poker(array: Array) -> Array:
	var groups = []
	var current_group = []
	for i in range(array.size()):
		if current_group.size() == 0 or array[i] == current_group[-1]:
			current_group.append(array[i])
		else:
			groups.append(current_group)
			current_group = [array[i]]
	if current_group.size() > 0:
		groups.append(current_group)
	groups.sort_custom(func(a, b): return a.size() > b.size())
	return groups

func analizar_mano_poker(array: Array) -> Array:
	var description
	var puntuacion_mano = [-1, -1, -1]
	match array[0].size():
		1:
			description = "CARTA ALTA DE %d\n" % array[0]
			puntuacion_mano = [1, array[0], -1]
		2:
			if array[1].size() == 2:
				description = "DOBLE PAREJA DE %d Y %d\n" % [array[0][0], array[1][0]]
				puntuacion_mano = [3, array[0][0], array[1][0]]
			else:
				description = "PAREJA DE %d\n" % array[0][0]
				puntuacion_mano = [2, array[0][0], -1]
		3:
			if array[1].size() == 2:
				description = "FULL HOUSE DE TRÍO %d Y PAREJA %d\n" % [array[0][0], array[1][0]]
				puntuacion_mano = [5, array[0][0], array[1][0]]
			else:
				description = "TRÍO DE %d\n" % array[0][0]
				puntuacion_mano = [4, array[0][0], -1]
		4:
			description = "PÓKER DE %d\n" % array[0][0]
			puntuacion_mano = [6, array[0][0], -1]
		5:
			description = "REPÓKER DE %d\n" % array[0][0]
			puntuacion_mano = [7, array[0][0], -1]
	return [description, puntuacion_mano]

func nueva_partida(): #generar cartas
	for child in get_children():
		child.queue_free()
	generar_mano_aleatoria(mano_poker)
	for i in range(5):
		dibujar_cartas(i, mano_poker[i])

func cambiar_cartas():
	for child in get_children():
		if child.seleccionado == 1:
			mano_poker[child.posicion] = randi() % 6
			dibujar_cartas(child.posicion, mano_poker[child.posicion])
			child.queue_free()

func jugar_mano(): #jugar mano
	mano_poker.sort()
	mano_poker.reverse()
	agrupaciones_mano = orden_final_mano_poker(mano_poker)
	mano_poker = []
	for i in agrupaciones_mano:
		mano_poker += i
	for child in get_children():
		child.queue_free()
	for i in range(5):
		dibujar_cartas(i, mano_poker[i])
	resultado = analizar_mano_poker(agrupaciones_mano)
