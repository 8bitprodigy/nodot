@tool
class_name ProjectileEmitter3D extends Nodot3D

## Launches an object or objects at the specified rotation

## Whether to enable the projectile emitter or not
@export var enabled = true
## The accuracy of the emission (0.0 = emit with 100% accuracy, 50.0 = emit in any forward direction, 100.0 = emit in any direction)
@export var accuracy := 0.0

@onready var initial_rotation = rotation
var rng = RandomNumberGenerator.new()
var projectiles: Array[Projectile3D] = []
var is_editor = Engine.is_editor_hint()

func _get_configuration_warnings() -> PackedStringArray:
  var warnings: PackedStringArray = []
  if !(get_parent() is FirstPersonItem):
    warnings.append("Parent should be a FirstPersonItem")
  return warnings
  
func _enter_tree():
  if !is_editor:
    for child in get_children():
      if child is Projectile3D:
        projectiles.append(child)
        remove_child(child)

## Apply the accuracy to the emitter
func aim_emitter():
  if enabled and accuracy > 0.0:
    var accuracy_radians = accuracy * PI / 100
    var new_x = rng.randf_range(-accuracy_radians, accuracy_radians)
    var new_y = rng.randf_range(-accuracy_radians, accuracy_radians)
    var new_z = rng.randf_range(-accuracy_radians, accuracy_radians)
    rotation = initial_rotation + Vector3(new_x, new_y, new_z)

## Execute the emitter
func action():
  if enabled:
    for projectile in projectiles:
      if accuracy > 0.0:
        aim_emitter()
      var new_projectile = projectile.duplicate(15)
      get_tree().root.add_child(new_projectile)
      new_projectile.global_position = global_position
      new_projectile.global_rotation = global_rotation
      new_projectile.propel()