extends Node



# In the node hierarchy there are 2 main track nodes:
# -On_event, which is for full songs
# -Random, which is for layered music
# 	-Low/Rising/High dictate which layers play first, Low has the highest priority
#
# HOW TO ADD A NEW SONG:
# 1. create a audiostreamplayer node and place it under the preffered node
# if it is a tracklayer, add it to the Low/Rising/High, whichever fits best
# else add it to On_event, you will be able to call it whenever you see fit
# 2. go to the Filesystem tab and select your track that you want to add
# (it should be under music). then in the scene tab, click on import
# enable loop, and then (re)import, the song.
# 3. Select the Audiostreamplayer node, in the Inspector the first "variable" is the Stream
# this refers to the audio stream, drag the songfile from the Filesystem tab into the Stream variable
# 4. In the audiostreamplayer inspector, set the Bus to "Music"
#
# HOW TO INTERACT WITH LAYERED MUSIC:
# get_currently_playing() - returns the currently playing song
# up_music_intensity() - queues up a new tracklayer to be played
# lower_music_intensity() - queues up a tracklayer to be stopped
# queue_track(songname) - stops all other songs and queues up songname
# stop_track_by_name(songname) - stops the requested song

var n_random_tracks : int = 5

var threat_difference : int = 0
var n_desired_layers : int = 0
var n_active_layers : int = 0
var currently_playing := ""
var queue := []

# returns whatever is playing atm or null, "Random" if layered music is on.
func get_currently_playing():
	if n_active_layers > 0 and currently_playing != "":
		return 1
	if n_active_layers > 0:
		return "Random"
	if currently_playing != "":
		return currently_playing
	return null



#queues a specific track, this is for non-dynamic music
#therefore it only plays the most recently queued track
#all other songs are stopped
#the rest of the queue is emptied afterwards
func queue_track(songname):
	queue.append(songname)

#queue a intensity increase
func up_music_intensity(level=1):
	n_desired_layers = min(n_desired_layers + level, n_random_tracks )

#set the desired number of song layers
func set_music_intensity(level):
	if level < 0 or level > n_random_tracks:
		return 1
	n_desired_layers = level
	return 0

#queue a intensity decrease
func lower_music_intensity(level=1):
	n_desired_layers = max(n_desired_layers - level, 0)


#the timer in this scene will call this function every X seconds (to the beat)
#when that happens we check if there are queued tracks and play them
func _on_timer_timeout() ->void:
	threat_difference = n_desired_layers - n_active_layers
	if len(queue) > 0: #first check if we need to play a set track
		if stop_random_track_layered() == 0:
			n_active_layers -= 1
		else:
			var songname = queue.pop_back()
			queue = []
			play_track_by_name(songname)
		threat_difference = 0

	if currently_playing == "":
		while threat_difference > 0:
			if play_random_track_layered() == 0:
				threat_difference -= 1
				n_active_layers += 1
			else:
				threat_difference = 0
		if threat_difference < 0:
			if stop_random_track_layered() == 0:
				threat_difference += 1
				n_active_layers -= 1
			else:
				threat_difference = 0


#plays a random track, but only does higher intensity tracks if enough tracks
#from the previous layer are already playing
#you only need to pass a node if we decide on multiple soundtracks
func play_random_track_layered(node=$Random):
	var candidates = not_playing_in_node(node.find_child("Low"))
	#if low is enough, add rising, if rising is enough, add high
	if len(playing_in_node(node.find_child("Low"))) >= 1:
		candidates.append_array(not_playing_in_node(node.find_child("Rising")))
		if len(playing_in_node(node.find_child("Rising"))) >= 1:
			candidates.append_array(not_playing_in_node(node.find_child("High")))
	if len(candidates) == 0:
		return 1
	var index = randi() % candidates.size()
	candidates[index].play()
	return 0



#stops a random track, but only stops lower intensity tracks if enough tracks
#from the previous layer are already playing
#you only need to pass a node if we decide on multiple soundtracks
func stop_random_track_layered(node=$Random):
	var candidates = playing_in_node(node.find_child("High"))
	#if high is empty, add rising, if rising is empty, add low
	if len(candidates) == 0:
		candidates.append_array(playing_in_node(node.find_child("Rising")))
		if len(candidates) == 0:
			candidates.append_array(playing_in_node(node.find_child("Low")))
			if len(candidates) == 0:
				return 1
	var index = randi() % candidates.size()
	candidates[index].stop()
	return 0


#plays the track by the trackname
#stops all other tracks playing in the node
#you probably dont need to change the node
func play_track_by_name(songname, node = "On_event"):
	if songname == null:
		return 1
	var song = get_node_or_null(node + "/" + songname)
	if song == null:
		return 1
	var playing = playing_in_node(get_node(node))
	for n in playing:
		if n.get_name() != songname:
			n.stop()
	if song.is_playing():
		return 1
	song.play()
	currently_playing = songname
	return 0

#stop playing a specific track
#you probably dont need to change the node
func stop_track_by_name(songname, node = "On_event"):
	var song = get_node_or_null(node + "/" + songname)
	if song == null or not song.is_playing():
		return 1
	song.stop()
	currently_playing = ""
	return 0
	

#returns the songs playing in a node as a array
#works on single nested songs too
func playing_in_node(node):
	var n = []
	for track in node.get_children():
		if track.get_class() != "Node":
			if track.is_playing():
				n.append(track)
		else:
			for t in track:
				if t.is_playing():
					n.append(t)
	return n


func not_playing_in_node(node):
	var n = []
	for track in node.get_children():
		if not track.is_playing():
			n.append(track)
	return n


func sound_effect(soundname, node = "Effects"):
	if soundname == null:
		return 1
	var sound = get_node_or_null(node + "/" + soundname)
	sound.play()
	return 0



