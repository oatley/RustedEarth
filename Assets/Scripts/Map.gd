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

var tile_size = 32 # Sprite size
var player

# Called when the node enters the scene tree for the first time.
func _ready():
  """meow"""

func play():
  var map_name = "0x0x0"
  gui.hide()
  load_world()
  #print(world.keys())
  load_map(map_name)
  print(maps.keys())
  draw_map_tiles(map_name)
  add_player(map_name) 

func load_world():
  var f = File.new()
  f.open("res://Assets/Worlds/meow/meow.world", f.READ)
  var json_string = f.get_as_text()
  var json = JSON.parse(json_string)
  if json.error == OK:
    world = json.result
  else:
    print("error with json in world")

func load_map(map_name):
  var f = File.new()
  f.open(world[map_name], f.READ)
  var json_string = f.get_as_text()
  var json = JSON.parse(json_string)
  if json.error == OK:
    maps[map_name] = json.result
    print(maps[map_name])
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
  node.name = map_name
  add_child(node)
  for key in maps[map_name].keys():
    if maps[map_name][key]['c'] == "#":
      var t = wall_tile.instance()
      t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
      node.add_child(t)
    elif maps[map_name][key]['c'] == ".":
      var t = floor_tile.instance()
      t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
      node.add_child(t)
    elif maps[map_name][key]['c'] == "~":
      var t = water_tile.instance()
      t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
      node.add_child(t)
    elif maps[map_name][key]['c'] == ",":
      var t = sand_tile.instance()
      t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
      node.add_child(t)
    elif maps[map_name][key]['c'] == "t":
      # Add a ground tile under the tree
      if maps[map_name]["default_floor"]['c'] == ',':
        var t = sand_tile.instance()
        t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
        node.add_child(t)
      elif maps[map_name][key]["default_floor"]['c'] == '.':
        var t = floor_tile.instance()
        t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
        node.add_child(t)
      var t = tree_tile.instance()
      t.position = update_pos(maps[map_name][key]['x'], maps[map_name][key]['y'])
      node.add_child(t)

func update_pos(posx, posy):
  var mapx = posx
  var mapy = posy
  var pos = Vector2(mapx*tile_size, mapy*tile_size)
  return pos

func is_floor(x, y, map_name):
  var key = str(x) + "x" + str(y)
  if maps[map_name][key] == ".":
    return true




