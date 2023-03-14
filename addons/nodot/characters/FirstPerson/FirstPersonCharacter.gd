class_name FirstPersonCharacter extends CharacterBody3D

## A CharacterBody3D for first person games
##
## This CharacterBody3D creates a head and camera node.

@export var input_enabled := true ## Allow player input
@export var fov := 75.0 ## The camera field of view
@export var head_position := Vector3.ZERO ## The head position

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

func _enter_tree():
  var head = Node3D.new()
  head.name = "Head"
  var camera3d = Camera3D.new()
  camera3d.name = "Camera3D"
  head.add_child(camera3d)
  add_child(head)
  
func _ready():
  camera.fov = fov
  
  if has_node("HeadPosition"):
    var head_position_node = get_node("HeadPosition")
    head.position = head_position_node.position
    head_position_node.queue_free()
  else:
    head.position = head_position

func _physics_process(delta):
  move_and_slide()
  
func _input(event):
  if event.is_action_pressed("escape"):
    if input_enabled:
      disable_input()
      input_enabled = false
    else:
      enable_input()
      input_enabled = true

## Disable player input
func disable_input():
  if has_node("FirstPersonKeyboardInput"):
    get_node("FirstPersonKeyboardInput").disable()
  if has_node("FirstPersonMouseInput"):
    get_node("FirstPersonMouseInput").disable()

## Enable player input
func enable_input():
  if has_node("FirstPersonKeyboardInput"):
    get_node("FirstPersonKeyboardInput").enable()
  if has_node("FirstPersonMouseInput"):
    get_node("FirstPersonMouseInput").enable()