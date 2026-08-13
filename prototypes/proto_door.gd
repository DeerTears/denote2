extends Node2D

func _ready() -> void:
	$Listener.connect("area_entered", on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area is ProtoPlayer:
		pass
