class_name Splash
extends Node2D


@onready var splash_audio: AudioStreamPlayer2D = %SplashAudio
@onready var splash_anim: AnimatedSprite2D = %SplashAnim


func _ready() -> void:
	splash_anim.play("splash")
	splash_anim.animation_finished.connect(queue_free)
	splash_audio.play()
