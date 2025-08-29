extends Node

# For saving before 
var initial_coins: float = 100
var initial_max_rows: int = 8
var initial_current_rows: int = 6
var initial_new_row_cost: int = 150
var initial_income_per_minute: int = 2

# Datetime
var initial_datetime = Time.get_unix_time_from_system()

var coins: float = 100
var max_rows: int = 8
var current_rows: int = 6
var new_row_cost: int = 150
var income_per_minute: int = 2
var animations_on: bool = true
var free_balls = []

func _ready():
	UsefulFunctions.load_data()
