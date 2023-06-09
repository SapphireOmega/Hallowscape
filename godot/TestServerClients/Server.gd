extends Node

@export var runOnStart = false
@export var PORT = 8080

var server = TCPServer.new()
var mutex = Mutex.new()
var threads = []

var MAX_PLAYERS = 2
var n_players = 0

func _ready():
	if runOnStart:
		server.listen(PORT)
		var PCRThread = Thread.new()
		PCRThread.start(processConnectionRequest)
		PCRThread.wait_to_finish()

func processConnectionRequest():
	while true:
		if server.is_connection_available() and n_players <= MAX_PLAYERS:
			var tcp = server.take_connection()
			
			mutex.lock()
			n_players += 1
			mutex.unlock()
			
			print("Client " + str(n_players) + " connected")

			var SCThread = Thread.new()
			SCThread.start(serveClient.bind(tcp, n_players))
			threads.append(SCThread)
	
	for thread in threads:
		thread.wait_to_finish()

func serveClient(tcp, clientID):
	while tcp.get_status() == tcp.STATUS_CONNECTED:
		tcp.poll()
		if tcp.get_status() != tcp.STATUS_CONNECTED:
			break
		var bytes = tcp.get_available_bytes()
		if bytes > 0:
			var data = tcp.get_partial_data(bytes)
			print(data[1].get_string_from_utf8())
			var message = "Hello client " + str(clientID)
			tcp.put_data(message.to_utf8_buffer())

	tcp.disconnect_from_host()

	mutex.lock()
	n_players -= 1
	mutex.unlock()

	print("Client " + str(clientID) + " disconnected")
