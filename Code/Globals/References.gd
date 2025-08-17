extends Node

@export var MainGridMap: GridMap

func _enter_tree() -> void:
	if get_node(^".."):
		print(^"..")
