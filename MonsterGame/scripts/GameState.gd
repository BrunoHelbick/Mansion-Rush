extends Node

var TreasureCount = 0
var nextlvl = 1
var unlockedLevels = 1
var shop_open = false
var completed_levels: Array[bool] = []
var brightness_activated = false
var invincibility_activated = false
var speed_activated = false
var gold = 0
var swords_owned: Array[String] = []
var equipped_sword: String = ""

const SAVE_FILE_PATH = "user://gamesave.json"

func save_game():
	var save_data = {
		"next_level": nextlvl,
		"unlocked_levels": unlockedLevels,
		"completed_levels": completed_levels,
		"gold": gold,
		"swords_owned": swords_owned,
		"equipped_sword": equipped_sword,
		"brightness_activated": brightness_activated,
		"invincibility_activated": invincibility_activated,
		"speed_activated": speed_activated
	}
	
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	print("Game saved!")

func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No save file found")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	json.parse(json_string)
	var save_data = json.data
	
	nextlvl = save_data.get("next_level", 1)
	unlockedLevels = save_data.get("unlocked_levels", 1)
	
	# Convert levels to Array[bool]
	var loaded_levels = save_data.get("completed_levels", [])
	completed_levels.clear()
	for level in loaded_levels:
		completed_levels.append(level as bool)
	
	gold = save_data.get("gold", 0)
	
	# Load swords
	var loaded_swords = save_data.get("swords_owned", [])
	swords_owned.clear()
	for sword in loaded_swords:
		swords_owned.append(sword as String)
	
	equipped_sword = save_data.get("equipped_sword", "")
	
	brightness_activated = save_data.get("brightness_activated", false)
	invincibility_activated = save_data.get("invincibility_activated", false)
	speed_activated = save_data.get("speed_activated", false)
	print("Game loaded!")

# Sword helper functions
func has_any_sword() -> bool:
	return swords_owned.size() > 0

func has_sword(sword_name: String) -> bool:
	return sword_name in swords_owned

func buy_sword(sword_name: String):
	if not has_sword(sword_name):
		swords_owned.append(sword_name)
		equipped_sword = sword_name  # Auto-equip new sword

func incrementTreasureCount():
	TreasureCount += 1

# Gets next level and marks current as complete
func getNextLevel(level_num: int):
	var nextlvl = 1 + 1
	if not is_level_completed(level_num):
		TreasureCount = 0
		unlockedLevels += 1
		mark_level_completed(level_num)

func is_level_completed(level_num: int) -> bool:
	while completed_levels.size() <= level_num:
		completed_levels.append(false)
	return completed_levels[level_num]

func mark_level_completed(level_num: int):
	while completed_levels.size() <= level_num:
		completed_levels.append(false)
	completed_levels[level_num] = true

func resetTreasure():
	TreasureCount = 0

# Sets save to default	
func reset_game():
	TreasureCount = 0
	nextlvl = 1
	unlockedLevels = 1
	completed_levels.clear()
	brightness_activated = false
	invincibility_activated = false
	speed_activated = false
	gold = 0
	swords_owned.clear()
	equipped_sword = ""
	save_game()
