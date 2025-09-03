extends Node

# For saving before 
var initial_coins: float = 100
var initial_max_rows: int = 8
var initial_current_rows: int = 8
var initial_new_row_cost: int = 150
var initial_income_per_minute: int = 2

var buildings_bought: Dictionary = {
	100: false,
	500: false,
	1000: false,
	5000: false,
	10000: false,
	50000: false,
	100000: false,
	500000: false,
	1000000: false,
	50000000: false,
	1000000000: false,
}

# Datetime
var initial_datetime = Time.get_unix_time_from_system()

var coins: float = 100
var max_rows: int = 8
var current_rows: int = 8
var new_row_cost: int = 150
var income_per_minute: int = 2
var sfx_muted: bool = false
var music_muted: bool = false

var animations_on: bool = true
var free_balls = []

var bought_bg: Dictionary = {
	"Purple": true,
	"Blue": false,
	"Pink": false,
	"Red": false,
	"Green": false,
	"Orange": false,
	"Teal": false,
	"Gold": false
}
var selected_bg: String = "Purple"

func _ready():
	UsefulFunctions.load_data()
