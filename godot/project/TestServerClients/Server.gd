extends Node

@export var PORT = 8080
@export var RunOnLaunch = true

var server : TCPServer
var ThreadsMutex : Mutex
var GeneralMutex : Mutex
var PCRThread : Thread

var players = {"ID1":null, "ID2":null}
var GameRunning = true
var RunningThreads = []
var ClosingThreads = []
var MAX_PLAYERS = 2
var n_players = 0

func _ready():
	if !RunOnLaunch:
		self.set_process(false)
		return
	
	var ip = get_ip_addr()
	print(ip)

	server = TCPServer.new()
	ThreadsMutex = Mutex.new()
	GeneralMutex = Mutex.new()

	server.listen(PORT)
	PCRThread = Thread.new()
	PCRThread.start(processConnectionRequest)
	
	ThreadsMutex.lock()
	RunningThreads.append(PCRThread)
	ThreadsMutex.unlock()

func _process(_delta):
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
	
	while GameRunning and n_players < MAX_PLAYERS:
		if server.is_connection_available():
			var tcp = server.take_connection()

			GeneralMutex.lock()
			n_players += 1
			players[players.find_key(null)] = tcp
			GeneralMutex.unlock()

			var SCThread = Thread.new()
			SCThread.start(serveClient.bind(SCThread, tcp, n_players))
			
			print("client " + str(players.find_key(tcp)) + " connected")
			
			ThreadsMutex.lock()
			RunningThreads.append(SCThread)
			ThreadsMutex.unlock()
	
	get_tree().paused = false

	ThreadsMutex.lock()
	RunningThreads.erase(PCRThread)
	ClosingThreads.append(PCRThread)
	ThreadsMutex.unlock()

func serveClient(SCThread, tcp, clientID):
#	await get_tree().create_timer(3.0).timeout
#	tcp.put_data("puzzel".to_utf8_buffer())

	while tcp.get_status() == tcp.STATUS_CONNECTED and GameRunning:
		tcp.poll()
		if tcp.get_status() != tcp.STATUS_CONNECTED:
			break

		var bytes = tcp.get_available_bytes()
		if bytes > 0:
			var data = tcp.get_partial_data(bytes)
#			print(data[1].get_string_from_utf8())
			var command = JSON.parse_string(data[1].get_string_from_utf8())
			if command:
				if command["type"] == "pressed":
					Input.action_press(command["action"])
				elif command["type"] == "released":
					Input.action_release(command["action"])
				else:
					pass

	print("client " + str(players.find_key(tcp)) + " disconnected")
	
	GeneralMutex.lock()
	n_players -= 1
	players[players.find_key(tcp)] = null
	GeneralMutex.unlock()
	
	tcp.disconnect_from_host()
	
	ThreadsMutex.lock()
	RunningThreads.erase(SCThread)
	ClosingThreads.append(SCThread)
	ThreadsMutex.unlock()

func sendToClient(PlayerID, message):
	var reciever = players[PlayerID]
	if reciever:
		reciever.put_data(message.to_utf8_buffer())

func _exit_tree():
	GameRunning = false
	
	for thread in RunningThreads:
		thread.wait_to_finish()
	
	for thread in ClosingThreads:
		thread.wait_to_finish()
