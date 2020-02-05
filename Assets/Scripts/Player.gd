extends KinematicBody2D
var tile_size = 32 # Sprite size
var key
var mapx
var mapy
var delay = 0.0
var map
var world_level
var light = false
var objective = Vector2(22.0 * 32, 17.0 * 32)

export (int) var speed = 200
var velocity = Vector2()
var disable_move = false

func _ready():
  disable_light()
  get_node("/root/Main/CanvasLayer/Compass").pos = objective
  pass 

func _process(delta):
  get_input()
  
func _physics_process(delta):
  velocity = velocity.normalized() * speed
  #velocity = move_and_slide(velocity)
  move_and_slide(velocity)
  for i in get_slide_count():
    var collision = get_slide_collision(i)
    print(collision.collider.name)
    if collision.collider.name == "LightItem":
      light = true
      $Light2D.scale = Vector2(1.0,1.0)
      $Light2D.position = Vector2(0.0,0.0)
      get_node("/root/Main/Map/0x0x0/LightItem").hide()
      objective = Vector2(45.0*32,28.0*32)
      get_node("/root/Main/CanvasLayer/Compass").pos = objective
    if collision.collider.name == "LightHole" and light:
      disable_move = true
      enter_under()
      disable_move = false
    #print(collision.collider.name)
  
#
#  delay += delta
#  if delay > 0.1:
#    delay = 0
    
    
func get_input():
  if disable_move:
    return
  if Input.is_action_pressed("up"):
    move_up()
  elif Input.is_action_pressed("down"):
    move_down()
  elif Input.is_action_pressed("left"):
    move_left()
  elif Input.is_action_pressed("right"):
    move_right()
  else:
    velocity = Vector2(0,0)
  if Input.is_action_pressed("zoom_in"):
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
    get_node("/root/Main/CanvasLayer/Compass").show()
    enable_light()
  elif Input.is_action_pressed("up_stairs") and world_level == -1:
    var map_node = get_node("/root/Main/Map")
    map_node.clear_level()
    map_node.play(0)
    get_node("/root/Main/CanvasLayer/Compass").show()
    enable_light()

func enter_under():
  var map_node = get_node("/root/Main/Map")
  map_node.clear_level()
  map_node.play(-1)
  get_node("/root/Main/CanvasLayer/Compass").show()
  enable_light()

func update_pos(posx, posy):
  mapx = posx
  mapy = posy
  position = Vector2(mapx*tile_size, mapy*tile_size)

func disable_light():
  var mod = get_node("/root/Main/Map/CanvasModulate")
  mod.hide()
  $Light2D.enabled = true
  
func enable_light():
  var mod = get_node("/root/Main/Map/CanvasModulate")
  mod.show()
  $Light2D.enabled = true 

func move_up():
  velocity = Vector2()
  velocity.y -= 1
  
func move_down():
  velocity = Vector2()
  velocity.y += 1

func move_left():
  velocity = Vector2()
  velocity.x -= 1

func move_right():
  velocity = Vector2()
  velocity.x += 1

#func move_up():
#  mapy -= 1
#  position = Vector2(mapx * tile_size, mapy * tile_size)
#
#func move_down():
#  mapy += 1
#  position = Vector2(mapx * tile_size, mapy * tile_size)
#
#func move_left():
#  mapx -= 1
#  position = Vector2(mapx * tile_size, mapy * tile_size)
#
#func move_right():
#  mapx += 1
#  position = Vector2(mapx * tile_size, mapy * tile_size)








