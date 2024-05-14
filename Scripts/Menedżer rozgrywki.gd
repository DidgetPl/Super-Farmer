extends Node2D

@onready var main_board = $"Główna plansza"
var all_animals = {"królik": 60, "owca": 24, "świnia": 20, "krowa": 12, "koń": 6}
var cfi = 0:
	get:
		return cfi
	set(value):
		cfi = value
		if cfi == 0:
			$"Przyciski/Rzut kośćmi".can_roll_dices = true
			can_trade = true
		elif cfi == 1:
			start_cpu_rounds()
			
var can_trade: bool = true
var game_won: bool = false

func update_game_status():
	if 0 not in [main_board.current_farm[cfi]["królik"], main_board.current_farm[cfi]["owca"], main_board.current_farm[cfi]["świnia"], main_board.current_farm[cfi]["krowa"], main_board.current_farm[cfi]["koń"]]:
		game_won = true
		$"Komunikat Zwycięstwa".text = "GRACZ " + str(cfi+1) + " WYGRAŁ!"
		$"Komunikat Zwycięstwa".visible = true
		await get_tree().create_timer(5).timeout
		get_tree().quit()

func start_cpu_rounds():
	while cfi != 0 and not game_won:
		await get_tree().create_timer(3).timeout
		$"Gracz 1".text = "GRACZ " + str(cfi+1)
		main_board.update_label()
		$Komunikat.text = ""
		if cfi != 0:
			await get_tree().create_timer(2).timeout
			$"Przyciski/Rzut kośćmi".roll_dices()
			await get_tree().create_timer(2).timeout
		cfi = (cfi+1)%4
	$"Gracz 1".text = "GRACZ " + str(cfi+1)
	main_board.update_label()
	$Komunikat.text = ""
