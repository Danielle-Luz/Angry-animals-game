extends StaticBody2D

class_name Wood

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _vanish_sound: AudioStreamPlayer2D = $VanishSound

func vanish() -> void:
	self.queue_free()
	ScoreAutoload.increment_score()

func play_vanish_animation() -> void:
	self._animation_player.play("vanish")
	self._vanish_sound.position = self.position
	self._vanish_sound.play()
