## Global signals
extends Node

signal GamePaused(bool)
signal GameStarted(bool)

signal update_ui

enum Effects {DAMAGE,SLOWNESS,DISORIENT,STUN}
