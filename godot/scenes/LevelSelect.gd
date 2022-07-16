extends Control

onready var rating_icon = {
	"none": preload("res://assets/ui/Trophy_01_00.png"),
	"bronze": preload("res://assets/ui/Trophy_01_01.png"),
	"silver": preload("res://assets/ui/Trophy_01_02.png"),
	"gold": preload("res://assets/ui/Trophy_01_03.png"),
}

func _ready():
	for level in 4:
			var text = "Level %d" % level
			
			var rating = GlobalGame.scores.get(level, "none")
			var icon = rating_icon[rating]
			$LevelList.add_item(text, icon)

func _on_LevelList_item_activated(index):
	print(index)
	GlobalGame.load_level("res://levels/level0%d.tscn" % index)

func _on_LevelList_item_selected(index):
	_on_LevelList_item_activated(index)

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
