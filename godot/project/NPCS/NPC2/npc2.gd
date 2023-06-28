# This file is an implementation for an NPC that only does some dialogue.

extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("idle")

func npc2():pass

# Show the interact button when more than 1 player is in the area.
func interact_invis(in_area):
	if $Sprite2D2.visible and in_area == 0:
		$Sprite2D2.visible = false
	else:
		$Sprite2D2.visible = true
