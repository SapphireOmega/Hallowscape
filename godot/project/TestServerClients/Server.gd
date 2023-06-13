extends Node

@export var PORT = 8080
@export var RunOnLaunch = true

var server : TCPServer
var ThreadsMutex : Mutex
var GeneralMutex : Mutex
var PCRThread : Thread
var udp_server:Node

var GameRunning = true
var RunningThreads = []
var ClosingThreads = []
var MAX_PLAYERS = 2
var n_players = 0

func _ready():
	if RunOnLaunch:
		print("hey")
		udp_server = preload("res://TestServerClients/udp_server.tscn").instantiate()
		add_child(udp_server)
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

func processConnectionRequest():
	while GameRunning and n_players < MAX_PLAYERS:
		if server.is_connection_available():
			var tcp = server.take_connection()

			GeneralMutex.lock()
			n_players += 1
			GeneralMutex.unlock()

			var SCThread = Thread.new()
			SCThread.start(serveClient.bind(SCThread, tcp, n_players))
			
			print("client " + str(n_players) + " connected")
			
			ThreadsMutex.lock()
			RunningThreads.append(SCThread)
			ThreadsMutex.unlock()
	
	ThreadsMutex.lock()
	RunningThreads.erase(PCRThread)
	ClosingThreads.append(PCRThread)
	ThreadsMutex.unlock()

func serveClient(SCThread, tcp, clientID):
	while tcp.get_status() == tcp.STATUS_CONNECTED and GameRunning:
		tcp.poll()
		if tcp.get_status() != tcp.STATUS_CONNECTED:
			break

		var bytes = tcp.get_available_bytes()
		if bytes > 0:
			var data = tcp.get_partial_data(bytes)
			var command = JSON.parse_string(data[1].get_string_from_utf8())
			if command:
				if command["type"] == "pressed":
					Input.action_press(command["action"])
				else:
					Input.action_release(command["action"])

	tcp.disconnect_from_host()
	
	print("client " + str(clientID) + " disconnected")
	
	GeneralMutex.lock()
	n_players -= 1
	GeneralMutex.unlock()
	
	ThreadsMutex.lock()
	RunningThreads.erase(SCThread)
	ClosingThreads.append(SCThread)
	ThreadsMutex.unlock()

func _exit_tree():
	GameRunning = false
	
	for thread in RunningThreads:
		thread.wait_to_finish()
	
	for thread in ClosingThreads:
		thread.wait_to_finish()
