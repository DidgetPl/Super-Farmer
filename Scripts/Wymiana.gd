extends Area2D

@export var animal_1: String = "Królik"
@export var animal_2: String = "Owca"
@export var animal_1_number: int = 6

@onready var farm = $"../../../Główna plansza"
@onready var ann: Label = $"../../../Komunikat"

@onready var options: Node2D = $"../../../Przyciski opcji"
@onready var left_option: Button = $"../../../Przyciski opcji/Lewa opcja"
@onready var right_option: Button = $"../../../Przyciski opcji/Prawa opcja"
@onready var gm: Node2D = $"../../.."

var plural = {"królik": "króliki", "owca": "owce", "świnia": "świnie", "krowa": "krowy", "koń": "konie", "mały pies": "małego psa", "duży pies": "dużego psa"}

func _on_input_event(viewport, event, shape_idx):
	if gm.cfi != 0:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and gm.can_trade:
		if farm.current_farm[gm.cfi][animal_1.to_lower()] >= animal_1_number or farm.current_farm[gm.cfi][animal_2.to_lower()] >= 1:
			gm.can_trade = false
			options.visible = true
			left_option.text = "Chcę " + plural[animal_1.to_lower()]
			right_option.text = "Chcę " + plural[animal_2.to_lower()]
			farm.current_trade = [animal_1, animal_2, animal_1_number]
		else:
			ann.text = "Posiadasz za mało zwierząt, by dokonać tej wymiany."
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not gm.can_trade:
		ann.text = "Już dokonałeś wymiany w tej turze."
	farm.check_if_not_too_many()
