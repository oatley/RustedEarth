extends Node
var map
var mutex
var thread
var semaphore
var exit_thread
var thread_busy = false

var world_size_x
var world_size_y
var world_level

func _ready():
  mutex = Mutex.new()
  thread = Thread.new()
  semaphore = Semaphore.new()
  exit_thread = false
  thread.start(self, "_thread_clean_map")
  map = get_node("/root/Main/Map")
 
func clear_level(world_size_x, world_size_y, world_level):
  world_size_x = world_size_x
  world_size_y = world_size_y
  world_level = world_level
  semaphore.post()

func _thread_clean_map(userdata):
  while true:
    semaphore.wait() # Wait until posted
    # Check to see if thread needs to exit
    mutex.lock()
    var should_exit = exit_thread # Protect with Mutex
    mutex.unlock()
    if should_exit:
      print("[Cleanup] -> exiting thread")
      break
    print("[Cleanup] -> starting thread")
    # Get map nodes
    for x in range(-world_size_x, world_size_x+1):
      for y in range(-world_size_y, world_size_y+1):
        var map_name = str(x)+"x"+str(y)+"x"+str(world_level)
        var map_child = get_node("/root/Main/Map/" + map_name)
        var map_children = map_child.get_children()
        # Call free on all children
        print("[Cleanup] -> free map " + map_name)
        for child in map_children:
          if child:
            call_deferred("free", child)
        call_deferred("free", map_child)
    print("[Cleanup] -> clean finished")

func _exit_tree():
    # Set exit condition to true
    mutex.lock()
    exit_thread = true # Protect with Mutex
    mutex.unlock()
    # Unblock by posting
    semaphore.post()
    # Wait until thread exits
    thread.wait_to_finish()
   
func get_thread_busy():
  mutex.lock()
  var busy = thread_busy
  mutex.unlock()
  
func set_thread_busy(busy):
  mutex.lock()
  thread_busy = busy
  mutex.unlock()
    