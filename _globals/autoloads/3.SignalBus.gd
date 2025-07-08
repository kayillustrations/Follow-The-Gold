## Global signals
extends Node

signal GamePaused(bool)
signal GameStarted(bool)

signal update_ui

enum Effects {DAMAGE,SLOWNESS,DISORIENT,STUN,BLINDED}
enum Obstacles {COIN,SEWER,PUDDLE,POPPY,RAT,CROW}

signal isAffected(b:bool)
signal coinCollected()

signal isDamaged(b:bool)
signal isBlinded(b:bool)
signal isSlowed(b:bool)
signal isDisoriented(b:bool)
signal isStunned(b:bool)

signal dead
