extends Node

@export var RunOnLaunch = false
var server = TCPServer.new()
var password = "verysecure"

var PORT = 8080

func _ready():
	# Start listening on designated port
	if RunOnLaunch:
		server.listen(PORT)
		Thread.new().start(processConnectionRequests)
		print(IP.get_local_addresses())

# Thread for handling incoming TCP connection requests
func processConnectionRequests():
	while true:
		var conn = server.is_connection_available()
		if conn:
			# Accept connection
			var connector = server.take_connection()

			# Perform handshake with incoming client and poll for status
			var socket = WebSocketPeer.new()
			print(socket.accept_stream(connector))
			Thread.new().start(serveClient.bind(socket))

# Thread for handling incoming client data
func serveClient(socket):
	while true:
		socket.poll()
		var status = socket.get_ready_state()
		if status == WebSocketPeer.STATE_OPEN:
#			socket.send_text("Heyo".to_utf8_buffer())
			socket.poll()
			if socket.get_available_packet_count():
				print(socket.get_packet().get_string_from_utf8())

