extends Node2D

var filepath="user://save.dat"
onready var save_game={}
onready var load_game={}
var file

func saveGame(level:String,keys:int,treasure:int,score:int,coins:int,complete:bool)->void:
	loadGame()
	if(load_game.has(level)):
		save_game=load_game
		keys=max(keys,save_game[level]["keys"])
		score=max(score,save_game[level]["score"])
		score=max(treasure,save_game[level]["treasure"])
		if(save_game[level]["complete"]==true):
			complete=true
		save_game[level]={"keys":keys,"treasure":treasure,"score":score,"complete":complete}
		save_game["coins"]+=coins
		file=File.new()
		file.open(filepath,File.WRITE)
		file.store_line(to_json(save_game))
	else:
		save_game[level]={"keys":keys,"treasure":treasure,"score":score,"complete":complete}
		save_game["coins"]=coins
		file=File.new()
		file.open(filepath,File.WRITE)
		file.store_line(to_json(save_game))
	file.close()
func loadGame()->void:
	file=File.new()
	if file.file_exists(filepath):
		file.open(filepath,File.READ)
		load_game=parse_json(file.get_as_text())
		file.close()

