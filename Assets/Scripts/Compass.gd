extends Sprite

var target_angle = 0
var turn_speed = deg2rad(90)
var pos #= Vector2(22.0*32.0, 17.0*32.0)
var player

func _process(delta):
  if player:
    rotation = (pos - player.position).angle()
    rotation += turn_speed
