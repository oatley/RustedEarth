extends Node2D

# Objects for store stupid amounts of data
var world = {} # map_name:map_file_path
var maps = {} # map_name: {tile_key:tile} 

# Preloads and prefabs
onready var gui = get_node("/root/Main/GUI")
var floor_tile = load("res://Assets/Scenes/Floor.tscn")
var wall_tile = load("res://Assets/Scenes/Wall.tscn")
var wall_black_tile = load("res://Assets/Scenes/Wall_black.tscn")
var water_tile = load("res://Assets/Scenes/Water.tscn")
var lava_tile = load("res://Assets/Scenes/Lava.tscn")
var sand_tile = load("res://Assets/Scenes/Sand.tscn")
var tree_tile = load("res://Assets/Scenes/Tree.tscn")
var player_tile = load("res://Assets/Scenes/Player.tscn")

# Global vars
var world_name = "land3"
var world_size_x
var world_size_y
var world_level
var map_size = 50
var tile_size = 32 # Sprite size
var player

# If you ever need to meow, look no further 
func _ready():
  """meow"""

# Quick shortcut to run all loads
# level changes the Z axis of the world to go underground 0 or -1
func play(level):
  world_level = level
  gui.hide()
  if player:
    player.world_level = world_level
  load_world()
  for x in range(-world_size_x, world_size_x+1):
    for y in range(-world_size_y, world_size_y+1):
      var map_name = str(x)+"x"+str(y)+"x"+str(world_level)
      print(map_name)
      load_map(map_name)
      draw_map_tiles(map_name) # can you only draw map tiles of the closest 5?
  if not player:
    add_player("0x0x0")
  player.z_index = 10 # if this is too low player hides behind map
  player.world_level = world_level

# Load world file, which contains map names and file paths unique each world
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

# Each world is made of dozens of maps, this loads individual maps
func load_map(map_name):
  var f = File.new()
  f.open(world[map_name], f.READ)
  var json_string = f.get_as_text()
  var json = JSON.parse(json_string)
  if json.error == OK:
    maps[map_name] = json.result
  else:
    print("error with json in map", map_name)

# Spawn player object
func add_player(map_name):
  player = player_tile.instance()
  player.key = "player"
  #player.map = maps[map_name]
  player.update_pos(maps[map_name]["mapsize"]["x"] / 2, maps[map_name]["mapsize"]["y"] / 2)
  add_child(player)

# Contains all compatitble tiles within
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
    if maps[map_name][key]['c'] == "#": # wall_tile
      var t
      if world_level == -1:
        t = wall_black_tile.instance()
      else:
        t = wall_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == ".": # stone_floor_tile 
      var t = floor_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == "~": # water_tile
      var t = water_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == "=": # lava_tile
      var t = lava_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == ",": # sand_tile
      var t = sand_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)
    elif maps[map_name][key]['c'] == "t": # tree_tile
      # Add a ground tile under the tree
      if maps[map_name]["default_floor"]['c'] == ',': # floors under trees
        var t = sand_tile.instance()
        t.position = update_pos(x, y, map_group_x, map_group_y)
        node.add_child(t)
      elif maps[map_name]["default_floor"]['c'] == '.': # floors under trees
        var t = floor_tile.instance()
        t.position = update_pos(x, y, map_group_x, map_group_y)
        node.add_child(t)
      var t = tree_tile.instance()
      t.position = update_pos(x, y, map_group_x, map_group_y)
      node.add_child(t)

# Really hacky, relative positional calculation of tiles
# Formula: x = mapx * tile_size + (tile_size * map_size * map_group_x)
func update_pos(posx, posy, map_group_x, map_group_y):
  var mapx = posx
  var mapy = posy
  #var pos
  var map_group_offset_x = tile_size * map_size * map_group_x
  var map_group_offset_y = tile_size * map_size * map_group_y
  var pos = Vector2(mapx*tile_size+map_group_offset_x, mapy*tile_size+map_group_offset_y)
  return pos

# for collision maybe?
func is_floor(x, y, map_name):
  var key = str(x) + "x" + str(y)
  if maps[map_name][key] == ".":
    return true

func clear_level ():
  var cleanup = get_node("/root/Main/Cleanup")
  # Hide objects here
  for x in range(-world_size_x, world_size_x+1):
    for y in range(-world_size_y, world_size_y+1):
      var map_name = str(x)+"x"+str(y)+"x"+str(world_level)
      var map_child = get_node("/root/Main/Map/" + map_name)
      var map_children = map_child.get_children()
      for child in map_children:
        child.hide()
  cleanup.clear_level(world_size_x, world_size_y, world_level)




