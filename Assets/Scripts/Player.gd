extends Sprite
var tile_size = 32 # Sprite size
var key
var mapx
var mapy
var delay = 0.0
var map
var world_level
var light = false

func _ready():
  disable_light()
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
  elif Input.is_action_pressed("light_toggle"):
    if light:
      disable_light()
    else:
      enable_light()
  elif Input.is_action_pressed("down_stairs") and world_level == 0:
    var map_node = get_node("/root/Main/Map")
    map_node.clear_level()
    map_node.play(-1)
    if not light:
      enable_light()
  elif Input.is_action_pressed("up_stairs") and world_level == -1:
    var map_node = get_node("/root/Main/Map")
    map_node.clear_level()
    map_node.play(0)
    if light:
      disable_light()

func update_pos(posx, posy):
  mapx = posx
  mapy = posy
  position = Vector2(mapx*tile_size, mapy*tile_size)

func disable_light():
  var mod = get_node("/root/Main/Map/CanvasModulate")
  light = false
  mod.hide()
  $Light2D.enabled = false
  
func enable_light():
  var mod = get_node("/root/Main/Map/CanvasModulate")
  light = true
  mod.show()
  $Light2D.enabled = true  

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









