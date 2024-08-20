extends Node
class_name Math

static func round(num: float, points : int):
	points = float(points)
	return round(num*pow(10,points))/pow(10,points)
static func floor(num : float):
	return floorf(num)
