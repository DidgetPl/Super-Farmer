extends Node2D

@onready var farm = $"../Główna plansza"

func _on_lewa_opcja_button_up():
	if self.visible:
		farm.handle_trade(false)
		self.visible = false

func _on_prawa_opcja_button_up():
	if self.visible:
		farm.handle_trade(true)
		self.visible = false
