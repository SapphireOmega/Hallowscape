extends CanvasLayer

var max_hp = 4
var hp = 4
var hp_nodes = []


func _on_ready():
	for i in hp_path().get_children():
		hp_nodes.append(i)

func hp_path():
	return $HP_widget/HP

func set_hp(desired_amount):
	if desired_amount > max_hp or desired_amount < 0:
		return 1
	while hp < desired_amount:
		add_hp()
	while hp > desired_amount:
		minus_hp()
	return 0


func minus_hp():
	if hp > 0:
		hp_path().get_child(hp-1).visible = false
		hp -=1


func add_hp():
	if hp < max_hp:
		hp_path().get_child(hp).visible = true
		hp +=1


