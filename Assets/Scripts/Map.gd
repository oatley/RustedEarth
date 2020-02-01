extends Node2D

var world = {} # map_name:map_file_path
var maps = {} # map_name: {tile_key:tile} 

onready var gui = get_node("/root/Main/GUI")
var floor_tile = load("res://Assets/Scenes/Floor.tscn")
var wall_tile = load("res://Assets/Scenes/Wall.tscn")
var water_tile = load("res://Assets/Scenes/Water.tscn")
var sand_tile = load("res://Assets/Scenes/Sand.tscn")
var tree_tile = load("res://Assets/Scenes/Tree.tscn")
var player_tile = load("res://Assets/Scenes/Player.tscn")

var world_name = "land1"
var world_size_x
var world_size_y
var map_size = 50
var tile_size = 32 # Sprite size
var player

# Called when the node enters the scene tree for the first time.
func _ready():
  """meow"""

func play():
  gui.hide()
  load_world()
  for x in range(-world_size_x, world_size_x+1):
    for y in range(-world_size_y, world_size_y+1):
      var map_name = str(x)+"x"+str(y)+"x"+"0"
      print(map_name)
      load_map(map_name)
      draw_map_tiles(map_name) # can you only draw map tiles of the closest 5?
  add_player("0x0x0") 

func load_world():
  var f = File.new()
  f.open("res://Assets/Worlds/"+world_name+"/"+world_name+".world", f.READ)
  var json_string = f.get_as_text()
  var json = JSON.parse(json_string)
  if json.error == OK:
    world = json.result
    world_size_x = int(world["size_x"])
    world_size_y = int(world["size_y"])
  else:
    print("error with json in world")

func load_map(map_name):
  var f = File.new()
  f.open(world[map_name], f.READ)
  var json_string = f.get_as_text()
  var json = JSON.parse(json_string)
  if json.error == OK:
    maps[map_name] = json.result
  else:
    print("error with json in map", map_name)

func add_player(map_name):
  player = player_tile.instance()
  player.key = "player"
  #player.map = maps[map_name]
  player.update_pos(maps[map_name]["mapsize"]["x"] / 2, maps[map_name]["mapsize"]["y"] / 2)
  add_child(player)

func draw_map_tiles(map_name):
  var node = Node2D.new()
  var map_group_x = int(map_name.split("x")[0])
  var map_group_y = int(map_name.split("x")[1])
  var map_group_z = int(map_name.split("x")[2])
  node.name = map_name
  add_child(node)
  for key in maps[map_name].keys():
    var x = maps[map_name][key]['x']
    var y = maps[map_name][key]['y']
    if maps[map_name][key]['c'] == "#":
      var t = wall_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == ".":
      var t = floor_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == "~":
      var t = water_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == ",":
      var t = sand_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == "t":
      # Add a ground tile under the tree
      if maps[map_name]["default_floor"]['c'] == ',':
        var t = sand_tile.instance()
        t.position = update_pos(x, y, map_group_x, map_group_y)
        node.add_child(t)
      elif maps[map_name]["default_floor"]['c'] == '.':
        var t = floor_tile.instance()
        t.position = update_pos(x, y, map_group_x, map_group_y)
        node.add_child(t)
      var t = tree_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)

func update_pos(posx, posy, map_group_x, map_group_y):
  var mapx = posx
  var mapy = posy
  #var pos
  var map_group_offset_x = tile_size * map_size * map_group_x
  var map_group_offset_y = tile_size * map_size * map_group_y
  var pos = Vector2(mapx*tile_size+map_group_offset_x, mapy*tile_size+map_group_offset_y)
#  var map_group_offset_x = map_size * map_group_x
#  var map_group_offset_y = map_size * map_group_y
#  if map_group_offset_x != 0 and map_group_offset_y != 0:
#    pos = Vector2(mapx*tile_size*map_group_offset_x, mapy*tile_size*map_group_offset_y)
#  elif map_group_offset_x != 0:
#    map_group_offset_y = tile_size * map_size * map_group_y
#    pos = Vector2(mapx*tile_size*map_group_offset_x, mapy*tile_size+map_group_offset_y)
#  elif map_group_offset_y != 0:
#    map_group_offset_x = tile_size * map_size * map_group_x
#    pos = Vector2(mapx*tile_size+map_group_offset_x, mapy*tile_size*map_group_offset_y)
#  else:
#    map_group_offset_x = tile_size * map_size * map_group_x
#    map_group_offset_y = tile_size * map_size * map_group_y
#    pos = Vector2(mapx*tile_size+map_group_offset_x, mapy*tile_size+map_group_offset_y)
  return pos



func is_floor(x, y, map_name):
  var key = str(x) + "x" + str(y)
  if maps[map_name][key] == ".":
    return true




