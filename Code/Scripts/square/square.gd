extends Node3D

@export var color: Color = Color(1, 1, 1) # Default white

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	# Create a unique material for this instance
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.set_surface_override_material(0, mat)
