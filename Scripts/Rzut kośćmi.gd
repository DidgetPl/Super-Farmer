extends Button

var dice_1 = ["królik", "królik", "królik", "królik", "królik", "królik", "owca", "owca", "owca", "świnia", "krowa", "wilk"]
var dice_2 = ["królik", "królik", "królik", "królik", "królik", "królik", "owca", "owca", "świnia", "świnia", "koń", "lis"]

var plural = {"królik": "króliki", "owca": "owce", "świnia": "świnie"}
var accusative = {"królik": "królika", "owca": "owcę", "świnia": "świnię", "krowa": "krowę", "koń": "konia"}

@onready var ann: Label = $"../../Komunikat"
@onready var farm = $"../../Główna plansza"
@onready var gm: Node2D = $"../.."

var can_roll_dices: bool = true

func _on_button_up():
	if $"../../Przyciski opcji".visible or gm.cfi != 0 or not can_roll_dices:
		return
	
	can_roll_dices = false
	roll_dices()
	gm.cfi += 1
	
func roll_dices():
	var wall_1: String = roll_dice(dice_1)
	var wall_2: String = roll_dice(dice_2)
	
	ann.text = ""
	if wall_1 == wall_2:
		ann.text += "Wylosowałeś 2 " + plural[wall_1]+ "! Otrzymujesz "
		var shift: int = floor((2+farm.current_farm[gm.cfi][wall_1])/2)
		receiving(wall_1, shift)
		farm.current_farm[gm.cfi][wall_1] += shift
	else:
		for wall in [wall_1, wall_2]:
			if wall == "wilk":
				if farm.current_farm[gm.cfi]["duży pies"] == 0:
					farm.current_farm[gm.cfi]["owca"] = 0
					farm.current_farm[gm.cfi]["świnia"] = 0
					farm.current_farm[gm.cfi]["krowa"] = 0
					ann.text += "Wylosowałeś wilka! Pożera Ci wszystkie owce, świnie i krowy! "
				else:
					ann.text += "Wylosowałeś wilka, ale twój duży pies ochronił twoje zwierzęta! "
			elif wall == "lis":
				if farm.current_farm[gm.cfi]["mały pies"] == 0:
					if farm.current_farm[gm.cfi]["królik"] > 1:
						farm.current_farm[gm.cfi]["królik"] = 1
						ann.text += "Wylosowałeś lisa! Pożera Ci wszystkie prawie wszystkie króliki! "
					else:
						ann.text += "Wylosowałeś lisa, ale masz za mało królików, by jakieś stracić. "
				else:
					ann.text += "Wylosowałeś lisa, ale twój mały pies ochronił twoje króliki! "
			else:
				if farm.current_farm[gm.cfi][wall] > 0:
					var shift: int = floor((1+farm.current_farm[gm.cfi][wall])/2)
					farm.current_farm[gm.cfi][wall] += shift
					ann.text += "Wylosowałeś " + accusative[wall] + "! Otrzymujesz "
					receiving(wall, shift)
				else:
					ann.text += "Wylosowałeś " + accusative[wall]+ ", ale nie posiadasz tego zwierzęcia. "
	farm.check_if_not_too_many()
	farm.update_label()
	gm.update_game_status()

func receiving(wall, shift):
	if shift > 1:
		ann.text += plural[wall] + " w liczbie " + str(shift) + "! "
	else:
		ann.text += accusative[wall] + "! "

func roll_dice(dice):
	var random_i = randi() % dice.size()
	return dice[random_i]
