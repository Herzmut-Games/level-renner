extends LevelTemplate

func _ready():
	get_tree().paused = true
	$UI/Messages/TopLeft.text = "Level 1"
	$UI/Messages/Center.text = "Enemies ahead. I should be cautious and use my surroundings wisely..."
	yield(get_tree().create_timer(3.0), "timeout")
	$UI/Messages/Center.text = ""
	get_tree().paused = false
