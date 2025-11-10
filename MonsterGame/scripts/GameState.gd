extends Node

var TreasureCount = 0
var nextlvl = 1

func incrementTreasureCount():
	TreasureCount += 1

func getNextLevel():
	TreasureCount = 0
	nextlvl += 1

func resetTreasure():
	TreasureCount = 0
