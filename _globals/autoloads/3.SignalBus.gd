## Global signals
extends Node

signal GamePaused(bool)
signal GameStarted(bool)

signal update_ui

enum Effects {DAMAGE,SLOWNESS,DISORIENT,STUN,BLINDED}

signal isDamaged(b:bool)
signal isBlinded(b:bool)
signal isSlowed(b:bool)
signal isDisoriented(b:bool)
signal isStunned(b:bool)
