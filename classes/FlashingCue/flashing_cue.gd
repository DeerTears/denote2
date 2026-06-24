extends Node3D

@export_file_path("*.wav") var sound_path := "res://classes/FlashingCue/8BitKick.wav"

@export_color_no_alpha var flash_colour := Color.WHITE:
	get:
		return flash_colour
	set(new_colour):
		if null:
			await tree_entered
		flash_colour = new_colour
		if get_node_or_null("MeshInstance") == null:
			await tree_entered
			#await get_tree().create_timer(0.1).timeout
		$MeshInstance.mesh = $MeshInstance.mesh.duplicate(true)
		$MeshInstance.material_override = $MeshInstance.material_override.duplicate(true)
		$MeshInstance.material_override.albedo_color = new_colour
		$MeshInstance.material_override.emission = new_colour
		$OmniLight3D.light_color = new_colour

@onready var audio := $Audio

func play_sound() -> void:
	audio.stream = load(sound_path)
	audio.play()
