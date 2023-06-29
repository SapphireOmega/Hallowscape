extends Node2D

const CAMLIMITS = {
	"top" :-500,
	"bottom" :360,
	"left" :0,
	"right" :1152,
	}


func _ready():
	MusicGallery.play_track_by_name("Scary_Church")
