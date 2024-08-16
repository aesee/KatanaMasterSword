class_name PlayerCutProcessor

var points : PackedVector2Array
const regression_window = 30.0
const cut_length = 250.0
const max_points = 20

signal cut_happened(cut_begin : Vector2, cut_end : Vector2)

func add_next_point(position : Vector2):
	points.append(position)
	var number_of_points = points.size()
	if (number_of_points < 3):
		return
	if (number_of_points > max_points):
		var begin = number_of_points - 1 - max_points
		points = points.slice(begin)
	if (is_straight_line()):
		if (points[0].distance_to(position) > cut_length):
			cut(points[0], position)
	else:
		clear()
	
func clear():
	points.clear()

func cut(cut_begin : Vector2, cut_end : Vector2):
	clear()
	cut_happened.emit(cut_begin, cut_end)

func is_straight_line():
	var n = points.size()

	# Calculate the mean of x and y values
	var mean = Vector2.ZERO
	for point in points:
		mean += point
	mean /= n

	# Calculate the slope and y-intercept
	var numerator = 0.0
	var denominator = 0.0
	for point in points:
		numerator += (point.x - mean.x) * (point.y - mean.y)
		denominator += (point.x - mean.x) * (point.x - mean.x)

	if denominator == 0.0:
		return false  # Avoid division by zero
	
	var slope = numerator / denominator
	var intercept = mean.y - slope * mean.x

	# Check if all points lie close to the regression line
	for point in points:
		if abs(point.y - (slope * point.x + intercept)) > regression_window:
			return false

	return true
