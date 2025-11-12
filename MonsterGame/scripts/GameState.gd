extends Node
var TreasureCount = 0
var nextlvl = 1
var unlockedLevels = 1
var shop_open = false
var completed_levels: Array[bool] = []
var brightness_activated = false
var invincibility_activated = false
var speed_activated = false
var gold = 10

func incrementTreasureCount():
	TreasureCount += 1

func getNextLevel(level_num: int):
	var nextlvl = 1 +1
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
