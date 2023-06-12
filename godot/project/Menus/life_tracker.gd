extends Node




func P1_minus_hp():
	var hp = [
		$Lifebars/HP/P1/hp/hp1,
		$Lifebars/HP/P1/hp/hp2,
		$Lifebars/HP/P1/hp/hp3
	]
	print(hp[0])
	if hp[0].visible:
		hp[0].visible = false
	elif hp[1].visible:
		hp[1].visible = false
	elif hp[2].visible:
		hp[2].visible = false
		#TODO: call murder
		get_tree().reload_current_scene()


func P2_minus_hp():
	var hp = [
		$Lifebars/HP/P2/hp/hp1,
		$Lifebars/HP/P2/hp/hp2,
		$Lifebars/HP/P2/hp/hp3
	]
	if hp[0].visible:
		hp[0].visible = false
	elif hp[1].visible:
		hp[1].visible = false
	elif hp[2].visible:
		hp[2].visible = false
		#TODO: call murder
		get_tree().reload_current_scene()

