extends Label

var texto: String
signal texto_cambiado
# Called when the node enters the scene tree for the first time.
func _ready():
	texto_cambiado.emit()
	texto = get_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if texto != get_text():
		texto_cambiado.emit()
		texto = get_text()
