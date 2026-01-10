extends Node
class_name GameOfLifeModel

@export var width := 10
@export var height := 10
@export var generation_time := .2

signal generation_finished
signal cell_died(x: int, y: int)
signal cell_born(x: int, y: int)

const ALIVE := 1
const DEAD := 0

var _started := false
var _last_cells := []
var _current_cells := []
var _born_signal_accumulator := []
var _died_signal_accumulator := []
var _generation_timer := 0.0

func start() -> void:
	for y in range(height):
		for x in range(height):
			var state = randi_range(0, 1)
			self._current_cells[y][x] = state
			if state == ALIVE:
				cell_born.emit(x, y)
	_started = true

func _ready() -> void:
	for y in range(height):
		self._current_cells.append([])
		self._last_cells.append([])
		for x in range(height):
			self._current_cells[y].append(0)
			self._last_cells[y].append(0)

func _process(delta: float) -> void:
	if not _started:
		return
	_generation_timer -= delta
	if _generation_timer < 0.0:
		_generation_timer = generation_time
		_calculate_next_generation()

func _calculate_next_generation():
	var working_array = self._last_cells
	self._last_cells = self._current_cells
	self._current_cells = working_array
	
	for x in range(width):
		for y in range(height):
			var previous_state = self._last_cells[y][x]
			var next_state = self._calculate_next_cell_state(x, y)
			self._current_cells[y][x] = next_state
			if next_state != previous_state:
				self._add_cell_signal(next_state, x, y)
	
	generation_finished.emit()
	self._emit_signals(cell_died, self._died_signal_accumulator)
	self._emit_signals(cell_born, self._born_signal_accumulator)

func _emit_signals(signal_type, signals):
	for position in signals:
		signal_type.emit(position.x, position.y)
	signals.clear()

func _calculate_next_cell_state(x, y):
	var neighbor_range = range(-1, 2) # 2 is exclusive
	var total_living_neighbors = 0
	
	for x_delta in neighbor_range:
		for y_delta in neighbor_range:
			var neighbor_x = (x + x_delta) % self.width
			var neighbor_y = (y + y_delta) % self.height
			if neighbor_x == x and neighbor_y == y:
				# not neighbor, self
				continue
			total_living_neighbors += self._last_cells[neighbor_y][neighbor_x]
	return ALIVE if total_living_neighbors in range(2, 4) else DEAD # 4 is exclusive
	
func _add_cell_signal(new_state, x, y):
	match new_state:
		ALIVE: 
			self._born_signal_accumulator.append(Vector2(x, y))
		DEAD:
			self._died_signal_accumulator.append(Vector2(x, y))
