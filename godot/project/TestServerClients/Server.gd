extends Node

@export var PORT = 12983
@export var RunOnLaunch = true

#var server : TCPServer
var server : UDPServer
var ThreadsMutex : Mutex
var GeneralMutex : Mutex
var PCRThread : Thread
var players = {"ID1":null, "ID2":null}
var GameRunning = true
var RunningThreads = []
var ClosingThreads = []
var MAX_PLAYERS = 1
var n_players = 0

func _ready():
	if !RunOnLaunch:
		self.set_process(false)
		return
		
	var ip = get_ip_addr()
	$CanvasLayer/ColorRect/VBoxContainer/IPLabel.text = ip

#	server = TCPServer.new()
	server = UDPServer.new()
	ThreadsMutex = Mutex.new()
	GeneralMutex = Mutex.new()

	server.listen(PORT)
	PCRThread = Thread.new()
	PCRThread.start(processConnectionRequest)
	
	ThreadsMutex.lock()
	RunningThreads.append(PCRThread)
	ThreadsMutex.unlock()

func _process(_delta):
	if Input.is_action_just_pressed("add_player"):
		n_players+=1
	if Input.is_action_just_pressed("remove_player"):
		n_players-=1

	for thread in ClosingThreads:
		ClosingThreads.erase(thread)
		thread.wait_to_finish()
	
	if n_players < MAX_PLAYERS and !PCRThread.is_alive():
		PCRThread = Thread.new()
		PCRThread.start(processConnectionRequest)
		
		ThreadsMutex.lock()
		RunningThreads.append(PCRThread)
		ThreadsMutex.unlock()

func get_ip_addr():
	var ip
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			ip = address
		else:
			break
	return ip

func processConnectionRequest():
	get_tree().paused = true
	$CanvasLayer.visible = true
	
	while GameRunning and n_players < MAX_PLAYERS:
		server.poll()
		$CanvasLayer/ColorRect/VBoxContainer/PlayerLabel.text = str(n_players) + "/" +\
		 														str(MAX_PLAYERS) + " connected"
		if server.is_connection_available():
			var udp = server.take_connection()
#			tcp.set_no_delay(true)

			GeneralMutex.lock()
			n_players += 1
			players[players.find_key(null)] = udp
			GeneralMutex.unlock()

			var SCThread = Thread.new()
			SCThread.start(serveClient.bind(SCThread, udp, n_players))
			
			print("client " + str(players.find_key(udp)) + " connected")
			
			ThreadsMutex.lock()
			RunningThreads.append(SCThread)
			ThreadsMutex.unlock()

	$CanvasLayer.visible = false
	get_tree().paused = false

	ThreadsMutex.lock()
	RunningThreads.erase(PCRThread)
	ClosingThreads.append(PCRThread)
	ThreadsMutex.unlock()

func serveClient(SCThread, udp : PacketPeerUDP, clientID):
	udp.bind(PORT, udp.get_packet_ip())
	while true:
		server.poll()
		if udp.get_available_packet_count() > 0:
			var data = udp.get_packet().get_string_from_utf8()
			print(data)
			var command = JSON.parse_string(data)
			if command["type"] == "pressed":
				Input.action_press(command["action"])
			elif command["type"] == "released":
				Input.action_release(command["action"])
			else:
				break

#	while tcp.get_status() == tcp.STATUS_CONNECTED and GameRunning:
#		tcp.poll()
#		if tcp.get_status() != tcp.STATUS_CONNECTED:
#			break

#		var bytes = tcp.get_available_bytes()
#		if bytes > 0:
#			var data = tcp.get_partial_data(bytes)
#			print(data[1].get_string_from_utf8())
#
#			var arguments = data[1].get_string_from_utf8().split(":")
#			if arguments[0] == "p":
#				Input.action_press(arguments[1])
#			elif arguments[0] == "r":
#				Input.action_release(arguments[1])

	print("client " + str(players.find_key(udp)) + " disconnected")
	
	GeneralMutex.lock()
	n_players -= 1
	players[players.find_key(udp)] = null
	GeneralMutex.unlock()
	
	udp.disconnect_from_host()
	
	ThreadsMutex.lock()
	RunningThreads.erase(SCThread)
	ClosingThreads.append(SCThread)
	ThreadsMutex.unlock()

func sendToPlayer(PlayerID, message):
	var reciever = players[PlayerID]
	print(reciever)
	if reciever:
		reciever.put_data(message.to_utf8_buffer())

func _exit_tree():
	GameRunning = false
	
	for thread in RunningThreads:
		if thread.is_alive():
			thread.wait_to_finish()
	
	for thread in ClosingThreads:
		if thread.is_alive():
			thread.wait_to_finish()
