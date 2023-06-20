extends Node2D

const CAMLIMITS = {
	"top" :0,
	"bottom" :360,
	"left" :0,
	"right" :2016,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicGallery.set_music_intensity(2)

