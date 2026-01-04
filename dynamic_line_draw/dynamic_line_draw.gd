extends Node2D

var cut_line: Line2D
var direction_line: Line2D
var line_length: int = 100

var drawing = false

var next_cut_line: Vector2

func _ready() -> void:
	cut_line = Line2D.new()
	cut_line.width = 10
	cut_line.default_color = Color.RED
	cut_line.add_point(Vector2.ZERO)
	cut_line.add_point(Vector2.ONE * line_length)

	get_parent().call_deferred("add_child", cut_line)

	direction_line = Line2D.new()
	direction_line.width = 10
	direction_line.default_color = Color.YELLOW
	direction_line.add_point(Vector2.ZERO)
	direction_line.add_point(Vector2.RIGHT * line_length)

	get_parent().call_deferred("add_child", direction_line)

var time: float = 0.0
var max_rotation: float = 25
var frequency: float = 2.0

func _process(delta: float) -> void:
	if drawing:
		var current_pos = cut_line.points[-1]
		if current_pos.distance_to(next_cut_line) > 0.5:
			cut_line.points[-1] = current_pos.lerp(next_cut_line, 10.0 * delta)
		else:
			cut_line.points[-1] = next_cut_line
			drawing = false
		return

	time += delta

	var a = cut_line.points[-2]
	var b = cut_line.points[-1]

	var base_angle = (b - a).angle()

	var swing = sin(time * frequency) * deg_to_rad(max_rotation)

	direction_line.rotation = base_angle + swing

	direction_line.position = b

	direction_line.visible = true

func _input(event):
	if event is InputEventKey:
		if event.is_released() and event.keycode == KEY_SPACE:
			var direction_vector = Vector2.RIGHT.rotated(direction_line.rotation)

			var offset = direction_vector * line_length
			next_cut_line = cut_line.points[-1] + offset

			cut_line.add_point(cut_line.points[-1])

			drawing = true
			direction_line.visible = false

			line_length = randi_range(25, 100)
			max_rotation = randf_range(25, 50)
			direction_line.points[-1] = Vector2.RIGHT * line_length
