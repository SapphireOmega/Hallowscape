extends Node2D

const CAMLIMITS = {
	"top": 0,
	"bottom": 360,
	"left": 0,
	"right": 2016,
}

func _ready():
	MusicGallery.play_track_by_name("Signs_In_The_Field")
