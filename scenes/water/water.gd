extends Area2D

@onready var splash_sound: AudioStreamPlayer2D = $SplashSound

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	splash_sound.play()
