@tool
extends Area3D

@export_tool_button("Set End Transform") var end_transform_action = set_end_transform

func set_end_transform():
	var undo_redo = EditorInterface.get_editor_undo_redo()
	undo_redo.create_action("Set Teleporter End Position")
	undo_redo.add_do_property($TargetTransform, &"transform", EditorInterface.get_editor_viewport_3d().get_camera_3d().transform)
	undo_redo.add_undo_property($TargetTransform, &"transform", transform)
	undo_redo.commit_action()
