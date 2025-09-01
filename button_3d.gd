extends Node3D

signal bought
var cost: int = 100
var income_amount: int = 2
var been_bought: bool = false

func _ready():
	$Area3D.connect("bought", self._emit_bought)

func _change_label(value, income, has_been_bought):
	$Area3D/TextViewport/Label.text = "+$" + UsefulFunctions._format_abbreviated(income) + "/min\nBuy for $" + UsefulFunctions._format_abbreviated(value)
	cost = value
	income_amount = income
	been_bought = has_been_bought
	if been_bought:
		$Area3D.visible = false
		$second_build.visible = true


func _emit_bought():
	GlobalVariables.income_per_minute += income_amount
	bought.emit()
