extends ParallaxBackground

var viewport_size
var relative_x
var relative_y

func _ready():
	get_tree().get_root().connect("size_changed", Callable(self, "viewport_changed")) # register event if viewport changes
	viewport_changed()
	relative_x = 0
	relative_y = 0

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		relative_x = -1 * (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		relative_y = -1 * (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		# print("relative_y: " + str(relative_y))
		# print("relative_x: " + str(relative_x))
		var proporcion = 1 / float(get_child_count())
		var suma_proporcion = proporcion
		for child in self.get_children(): # for each parallaxlayer do...
			child.motion_offset.x = lerp(0, 10, suma_proporcion) * relative_x
			child.motion_offset.y = lerp(0, 10, suma_proporcion) * relative_y
			suma_proporcion += proporcion

# gets called on the start of the application once and every time the viewport changes
# centers the images
func viewport_changed():
	viewport_size = get_viewport().size
	for child in self.get_children():
		child.get_child(0).offset.x = 0
		child.get_child(0).offset.y = 0
