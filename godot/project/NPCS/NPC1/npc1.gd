extends CharacterBody2D

func npc1():pass

func interact_invis():
	if $Sprite2D2.visible or Input.is_action_just_pressed("interact"):
		$Sprite2D2.visible = false
	else:
		$Sprite2D2.visible = true
