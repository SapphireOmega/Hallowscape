extends CharacterBody2D

func npc1():pass

func interact_invis(in_area):
	if $Sprite2D2.visible and in_area == 0:
		$Sprite2D2.visible = false
	else:
		$Sprite2D2.visible = true
