extends Node

enum Sounds {COOKING,WATER,WRONG,EAT,POP}







func make_sound(type: Sounds):
	var s = AudioStreamPlayer.new()
	self.add_child(s)
	if type == Sounds.COOKING:
		s.stream = load("res://Minigry_new/sound/justsomesounds-cooking-sound-442650.mp3")
		s.volume_db=-10
	elif type == Sounds.WATER:
		s.stream = load("res://Minigry_new/sound/universfield-pouring-water-191999.mp3")
	elif type == Sounds.WRONG:
		s.stream = load("res://Minigry_new/sound/soundshelfstudio-ui-error-pop-515668.mp3")
	elif type == Sounds.EAT:
		s.stream = load("res://Minigry_new/sound/mrstokes302-mmm-male-voice-sfx-mrstokes302-424185.mp3")
	elif type == Sounds.POP:
		s.stream = load("res://Minigry_new/sound/soundreality-pop-423717.mp3")
		s.volume_db=-15
	s.play()
	s.connect("finished", func():
		s.queue_free()
	)
