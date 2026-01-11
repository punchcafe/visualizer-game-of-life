extends Node3D


var _cell_array := []
var cell_scene = load("res://cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# width per cell 0.2, central offset = 0.2 * num cells per row / 2
	var x_offset = ($GameOfLifeModel.width * 0.2) / 2.0
	var y_offset = ($GameOfLifeModel.height * 0.2) / 2.0
	for y in range($GameOfLifeModel.height):
		_cell_array.append([])
		for x in range($GameOfLifeModel.width):
			var child = cell_scene.instantiate()
			_cell_array[y].append(child)
			add_child(child)
			child.position = Vector3((x * 0.2) - x_offset, 0.0, (y * 0.2) - y_offset)
			
	$GameOfLifeModel.start()

func _process(delta: float) -> void:
	self.rotate_y((PI / 2) * delta)
	pass


func _on_game_of_life_model_cell_born(x: int, y: int) -> void:
	_cell_array[y][x].live()


func _on_game_of_life_model_cell_died(x: int, y: int) -> void:
	_cell_array[y][x].die()
