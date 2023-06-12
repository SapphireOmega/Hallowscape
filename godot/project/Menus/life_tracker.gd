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
	elif hp[1]:
		hp[1].visible = false
	elif hp[2]:
		hp[2].visible = false
		#TODO: call murder


func P2_minus_hp():
	var hp = [
		$Lifebars/HP/P2/hp/hp1.visible,
		$Lifebars/HP/P2/hp/hp2.visible,
		$Lifebars/HP/P2/hp/hp3.visible
	]
	if hp[0]:
		hp[0] = false
	elif hp[1]:
		hp[1] = false
	elif hp[2]:
		hp[2] = false
		#TODO: call murder


# Called when the node enters the scene tree for the first time.
func _ready():
	P1_minus_hp()
	P1_minus_hp()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
