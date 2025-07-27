extends Node

@export var cutloop_stream: AudioStreamOggVorbis
@export var wrappedloop_stream: AudioStreamOggVorbis
@export var dbScale: float = -5.00

var intro_player: AudioStreamPlayer
var loop_player: AudioStreamPlayer
var loop_started := false
var streamloaded := false

func _ready() -> void:
	intro_player = AudioStreamPlayer.new()
	loop_player = AudioStreamPlayer.new()
	intro_player.name = "Cutloop Player"
	loop_player.name = "Wrappedloop Player"
	
	loop_player.bus = &"Music"
	intro_player.bus = &"Music"
	
	intro_player.volume_db = dbScale
	loop_player.volume_db = dbScale
	loop_player.autoplay = false
	set_process(true)

func _switchmusic(tracknameCut : String, tracknameWrapped : String, newVol : float):
	if streamloaded:
		intro_player.stop()
		loop_player.stop()
	
	cutloop_stream = load(tracknameCut)
	wrappedloop_stream = load(tracknameWrapped)
	
	streamloaded = true
	
	intro_player.stream = cutloop_stream
	
	if get_child_count() <= 0:
		add_child(intro_player)
		
	
	intro_player.volume_db = newVol
	intro_player.play(0.0)
	loop_started = false
	
	loop_player.stream = wrappedloop_stream
	loop_player.volume_db = newVol
	if get_child_count() <= 1:
		add_child(loop_player)
		loop_player.set("parameters/looping", true)
		
	
func _introdone():
		loop_player.play()
		loop_started = true
	
func _process(delta):
	var timeleft = (cutloop_stream.get_length() - intro_player.get_playback_position())
	
	if timeleft <= 0.0116:
		loop_player.play()
		
func _restartmusic():
	if intro_player.playing:
		intro_player.stop()
		
	if loop_player.playing:
		loop_player.stop()
		
	loop_started = false
	
	intro_player.play(0.0)
