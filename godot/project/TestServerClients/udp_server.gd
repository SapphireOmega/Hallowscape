extends Node2D

var server = PacketPeerUDP.new()
var connected = false
var addr = "255.255.255.255"

# Called when the node enters the scene tree for the first time.
func _ready():
	server.set_broadcast_enabled(true)
	server.set_dest_address(addr,28960)
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",send_packet)
	timer.set_wait_time(2)
	timer.one_shot = false
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func send_packet():
	var message = "gameplay"
	var error = server.put_packet(message.to_ascii_buffer())
	print(message)
