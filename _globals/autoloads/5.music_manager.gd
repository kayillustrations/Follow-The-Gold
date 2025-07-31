extends Node

@export var cutloop_stream: AudioStreamOggVorbis
@export var wrappedloop_stream: AudioStreamOggVorbis
@export var dbScale: float = -5.00
var db_offset: float = 10

var intro_player: AudioStreamPlayer
var loop_player: AudioStreamPlayer
var loop_started := false
var streamloaded := false
var bufferMs: float = 0.0

func _ready() -> void:
	bufferMs = (512.0 / AudioServer.get_mix_rate())
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
		intro_player.set("parameters/looping", false)
		
	
	intro_player.volume_db = newVol - db_offset
	loop_started = false
	
	loop_player.stream = wrappedloop_stream
	loop_player.volume_db = newVol - db_offset
	if get_child_count() <= 1:
		add_child(loop_player)
		loop_player.set("parameters/looping", true)
		
	loop_player.play(0.0)

func _restartmusic():
	if intro_player.playing:
		intro_player.stop()
		
	if loop_player.playing:
		loop_player.stop()
		
	loop_started = false
	
	intro_player.play(0.0)
