extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Light.visible = false

func live():
	$Light.visible = true
	
func die():
	$Light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
