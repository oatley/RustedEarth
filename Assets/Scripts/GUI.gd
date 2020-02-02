extends MarginContainer

onready var map = get_node("/root/Main/Map")

func _on_ButtonStart_pressed():
  map.play(0) # play level 0 is ground level
