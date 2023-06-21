# Note: comment the lines with --- to switch between TCP and UDP

extends Node

@export var PORT = 12983
@export var RunOnLaunch = true

# ---
#var server : UDPServer
var server : TCPServer
# ---

var ThreadsMutex : Mutex
var GeneralMutex : Mutex
var PCRThread : Thread
var players = {"1":null, "2":null}
var GameRunning = true
var RunningThreads = []
var ClosingThreads = []
var MAX_PLAYERS = 2
var n_players = 0

func _ready():
	# Does not run the server if this variable is turned off.
	if !RunOnLaunch:
		self.set_process(false)
		return
	
	# Displays the IP on the waiting screen.
	var ip = get_ip_addr()
	$CanvasLayer/ColorRect/VBoxContainer/IPLabel.text = ip

	# ---
#	server = UDPServer.new()
	server = TCPServer.new()
	# ---

	ThreadsMutex = Mutex.new()
	GeneralMutex = Mutex.new()

	# Create a new thread that listens to for incoming connection requests
	server.listen(PORT)
	PCRThread = Thread.new()
	PCRThread.start(processConnectionRequest)
	
	# Append the connection accepting thread to the running threads
	ThreadsMutex.lock()
	RunningThreads.append(PCRThread)
	ThreadsMutex.unlock()

func _process(_delta):
	# Close any threads that have finished
	for thread in ClosingThreads:
		ClosingThreads.erase(thread)
		thread.wait_to_finish()
	
	# Pause the game and create a new connection accepting thread 
	if n_players < MAX_PLAYERS and !PCRThread.is_alive():
		# Start the new connection accepting thread
		PCRThread = Thread.new()
		PCRThread.start(processConnectionRequest)
		
		# Append the connection accepting thread to the running threads
		ThreadsMutex.lock()
		RunningThreads.append(PCRThread)
		ThreadsMutex.unlock()

# Helper function for obtaining the host IP address
func get_ip_addr():
	var ip
	# Only return the last non-localhost IPv4 address in IP.get_local_addresses()
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			ip = address
		else:
			break
	return ip

# Thread function for accepting and handling incoming connection requests
func processConnectionRequest():
	# Pause the game and show the pause screen
	get_tree().paused = true
	$CanvasLayer.show()
	
	while GameRunning and n_players < MAX_PLAYERS:
		# ---
#		server.poll()
		# ---

		$CanvasLayer/ColorRect/VBoxContainer/PlayerLabel.text = str(n_players) + "/" +\
		 														str(MAX_PLAYERS) + " connected"
		if server.is_connection_available():
			# Take the connection and set the TCP delay to false
			var tcp = server.take_connection()

			# ---
			tcp.set_no_delay(true)
			#---

			# Combine the TCP stream to the player ID.
			GeneralMutex.lock()
			n_players += 1
			players[players.find_key(null)] = tcp
			GeneralMutex.unlock()

			# Create a new thread that serves the client
			var SCThread = Thread.new()
			SCThread.start(serveClient.bind(SCThread, tcp))
			
			print("client " + str(players.find_key(tcp)) + " connected")
			
			# Add the client thread to the running threads
			ThreadsMutex.lock()
			RunningThreads.append(SCThread)
			ThreadsMutex.unlock()

	# Here the maximum number of players is reached
	# Make the pause screen vanish
	$CanvasLayer.hide()
	get_tree().paused = false

	# Remove the connection accepting thread from the running threads and
	# queue it for deletion
	ThreadsMutex.lock()
	RunningThreads.erase(PCRThread)
	ClosingThreads.append(PCRThread)
	ThreadsMutex.unlock()

# Thread function for listening to client input
func serveClient(SCThread, tcp):
	# ---
#	tcp.bind(PORT, tcp.get_packet_ip())
#	while GameRunning:
#		server.poll()
#		if tcp.get_available_packet_count() > 0:
#			var data = tcp.get_packet()
#			var arguments = data.get_string_from_utf8().split(":")
#			if arguments[0] == "p": # Client presses button
#				Input.action_press(arguments[1]+players.find_key(tcp))
#			elif arguments[0] == "r": # Client releases button
#				Input.action_release(arguments[1]+players.find_key(tcp))

	while tcp.get_status() == tcp.STATUS_CONNECTED and GameRunning:
		tcp.poll()
		# Extra statement is needed here, otherwise error messages show
		if tcp.get_status() != tcp.STATUS_CONNECTED:
			break
		
		var bytes = tcp.get_available_bytes()
		if bytes > 0:
			# Get available data
			var data = tcp.get_partial_data(bytes)
#			print(data[1].get_string_from_utf8())
			# Split the incoming string into the arguments
			var arguments = data[1].get_string_from_utf8().split(":")
			if arguments[0] == "p": # Client presses button
				Input.action_press(arguments[1]+players.find_key(tcp))
			elif arguments[0] == "r": # Client releases button
				Input.action_release(arguments[1]+players.find_key(tcp))
	# ---

	# Here the client is no longer connected
	print("client " + str(players.find_key(tcp)) + " disconnected")
	
	# Remove the TCP connection from the player ID
	GeneralMutex.lock()
	n_players -= 1
	players[players.find_key(tcp)] = null
	GeneralMutex.unlock()
	
	# Close the connection
	# ---
	tcp.disconnect_from_host()
	# ---
	
	# Remove the client serving thread from the running threads and queue
	# it for deletion
	ThreadsMutex.lock()
	RunningThreads.erase(SCThread)
	ClosingThreads.append(SCThread)
	ThreadsMutex.unlock()

# Function to set a string to a player (this method can be called
# from other nodes)
func sendToPlayer(PlayerID, message):
	var reciever = players[str(PlayerID)]
	if reciever:
		reciever.put_data(message.to_utf8_buffer())

func _exit_tree():
	# Clean up the threads when the game is exited
	GameRunning = false
	
	for thread in RunningThreads:
		if thread.is_alive():
			thread.wait_to_finish()
	
	for thread in ClosingThreads:
		if thread.is_alive():
			thread.wait_to_finish()
