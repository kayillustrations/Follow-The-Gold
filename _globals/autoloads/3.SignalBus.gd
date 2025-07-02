## Global signals
extends Node

signal GamePaused(bool)
signal GameStarted(bool)

enum Effects {DAMAGE,SLOWNESS,DISORIENT,STUN}
