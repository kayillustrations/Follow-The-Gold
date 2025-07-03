## Global signals
extends Node

signal GamePaused(bool)
signal GameStarted(bool)

signal update_ui

enum Effects {DAMAGE,SLOWNESS,DISORIENT,STUN,BLINDED}

var isDamaged:bool = false
var isBlinded:bool = false
var isSlowed:bool = false
var isDisoriented:bool = false
var isStunned:bool = false
