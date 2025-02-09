extends ParallaxLayer

@onready var batalla = $"../.."
@onready var gpu_particles_2d = $"EMOCIONES CLARIBEL/GPUParticles2D"
@onready var emociones_claribel = $"EMOCIONES CLARIBEL"

func _process(delta):
	emociones_claribel.set_frame(batalla.descoloque)
	emociones_claribel.material.set_shader_parameter("WindStrength", 2+(abs(batalla.descoloque-2)*7.5))
	if batalla.descoloque == 2:
		gpu_particles_2d.hide()
	else:
		gpu_particles_2d.show()
		gpu_particles_2d.amount = abs(batalla.descoloque-2) * 10
