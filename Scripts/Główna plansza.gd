extends Node2D

var current_farm = [{"królik": 1, "owca": 0, "świnia": 0, "krowa": 0, "koń": 0, "mały pies": 0, "duży pies": 0},
{"królik": 1, "owca": 0, "świnia": 0, "krowa": 0, "koń": 0, "mały pies": 0, "duży pies": 0},
{"królik": 1, "owca": 0, "świnia": 0, "krowa": 0, "koń": 0, "mały pies": 0, "duży pies": 0},
{"królik": 1, "owca": 0, "świnia": 0, "krowa": 0, "koń": 0, "mały pies": 0, "duży pies": 0},
]
var current_trade = ["królik", "owca", 6]
	
@onready var gm: Node2D = $".."
	
func _ready():
	update_label()	

func update_label():
	for key in ["królik", "owca", "świnia", "krowa", "koń"]:
		get_node("Etykiety/" + key.capitalize()).text = str(current_farm[gm.cfi][key])
	for key in ["królik", "owca", "świnia", "krowa", "koń", "mały pies", "duży pies"]:	
		if current_farm[gm.cfi][key] == 0:
			get_node("Znaczniki/" + key.capitalize()).modulate = Color(0.3, 0.3, 0.3, 1.0)  # RGBA: (0, 255, 0, 255) - Zielony
		else:
			get_node("Znaczniki/" + key.capitalize()).modulate = Color(1.0, 1.0, 1.0, 1.0)  # RGBA: (0, 255, 0, 255) - Zielony			

func check_if_not_too_many():
	var sum = {"królik": 0, "owca": 0, "świnia": 0, "krowa": 0, "koń": 0}
	for key in sum.keys():
		for i in range(4):
			sum[key] += current_farm[i][key]
		if gm.all_animals[key] < sum[key]:
			current_farm[gm.cfi][key] -= (sum[key] - gm.all_animals[key])

func handle_trade(is_right: bool):
	current_trade[0] = current_trade[0].to_lower()
	current_trade[1] = current_trade[1].to_lower()
	
	if is_right:
		if current_farm[gm.cfi][current_trade[0]] < current_trade[2]:
			$"../Komunikat".text = "Posiadasz za mało zwierząt, by dokonać tej wymiany."
		else:
			current_farm[gm.cfi][current_trade[0]] -= current_trade[2]
			current_farm[gm.cfi][current_trade[1]] += 1
	else:
		if current_farm[gm.cfi][current_trade[1]] < 1:
			$"../Komunikat".text = "Posiadasz za mało zwierząt, by dokonać tej wymiany."
		else:
			current_farm[gm.cfi][current_trade[0]] += current_trade[2]
			current_farm[gm.cfi][current_trade[1]] -= 1
	update_label()
	gm.update_game_status()
