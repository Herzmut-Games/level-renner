extends Area2D
class_name NoWalljumpArea

func _on_No_walljump_Area_body_entered(body:Node):
	if body.has_method("disable_walljump"):
		body.disable_walljump()

func _on_No_walljump_Area_body_exited(body:Node):
	if body.has_method("enable_walljump"):
		body.enable_walljump()

