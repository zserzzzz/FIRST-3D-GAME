@tool
extends EditorScript

const MESHLIB_PATH = "res://Assets/Resources/MainMeshLib.tres"

const MESH_PATH = "res://Assets/Meshes/"


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var dir: DirAccess = DirAccess.open(MESH_PATH)
	var meshlib = MeshLibrary.new()
	
	if dir:
		var id = meshlib.get_last_unused_item_id()
		var meshs = dir.get_files()
		for mesh in meshs:
			meshlib.create_item(id)
			meshlib.set_item_mesh(id,load(MESH_PATH + mesh))
	ResourceSaver.save(meshlib,MESHLIB_PATH)
