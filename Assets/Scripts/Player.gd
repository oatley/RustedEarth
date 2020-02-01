extends Sprite
var tile_size = 32 # Sprite size
var key
var mapx
var mapy
var delay = 0.0
var map

func _ready():
  pass 

func _process(delta):
  delay += delta
  if delay > 0.1:
    delay = 0
    get_input()
    
func get_input():
  if Input.is_action_pressed("up"):
    move_up()
  elif Input.is_action_pressed("down"):
    move_down()
  elif Input.is_action_pressed("left"):
    move_left()
  elif Input.is_action_pressed("right"):
    move_right()
  elif Input.is_action_pressed("zoom_in"):
    var cam = get_node("Camera2D")
    var vec = Vector2(0.1, 0.1)
    cam.zoom += vec;
  elif Input.is_action_pressed("zoom_out"):
    var cam = get_node("Camera2D")
    var vec = Vector2(0.1, 0.1)
    cam.zoom -= vec;

func update_pos(posx, posy):
  mapx = posx
  mapy = posy
  position = Vector2(mapx*tile_size, mapy*tile_size)

func move_up():
  mapy -= 1
  position = Vector2(mapx * tile_size, mapy * tile_size)
  
func move_down():
  mapy += 1
  position = Vector2(mapx * tile_size, mapy * tile_size)

func move_left():
  mapx -= 1
  position = Vector2(mapx * tile_size, mapy * tile_size)
  
func move_right():
  mapx += 1
  position = Vector2(mapx * tile_size, mapy * tile_size)









