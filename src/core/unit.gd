extends KinematicBody2D
class_name Unit

enum {NORMAL = 0, ATTACKING, HURT, DEAD}

signal update_max_health(max_health)
signal update_current_health(current_health)
signal died()

export var speed = 3
export var attack = 3
export var max_health = 30
export var defense = 1
export var attack_range = 30

var velocity = Vector2.ZERO
var target = null
var health = 3
var state = NORMAL
var animation_player = null
var type_name = "Unit"

func reset():
  health = max_health
  emit_signal("update_max_health", max_health)
  emit_signal("update_current_health", health)
  
  state = NORMAL
  target = null
  velocity = Vector2.ZERO

func _ready():
  animation_player = $AnimationPlayer
  reset()
  
func flip(face_right):
  $Flippable.scale.x = -1 if face_right else 1
  
func goto(position, tolerance = 2):
  var diff : Vector2 = position - transform.origin
  if diff.length() > tolerance:
    flip(diff.x < 0)
    velocity = diff.normalized() * speed
    return false
  else:
    velocity = Vector2.ZERO
    return true

func _physics_process(_delta):
  velocity = move_and_slide(velocity, Vector2.UP)
  update_animation()
  
func update_animation():
  if state == NORMAL:
    $AnimationPlayer.play("idle")

func set_target(new_target):
  if typeof(target) == TYPE_OBJECT:
    target.disconnect("died", self, "target_killed")
  target = new_target
  if typeof(target) == TYPE_OBJECT:
    target.connect("died", self, "target_killed")

func _on_AnimationPlayer_animation_finished(anim_name : String):
  if "attack" in anim_name and state == ATTACKING:
    state = NORMAL
  elif "death" in anim_name:
    queue_free()

func is_within_range(point : Vector2, distance):
  return (position - point).length_squared() < (distance * distance)

func get_max_health():
  return max_health
  
func get_current_health():
  return health

func take_damage(val):
  health -= max((val - defense), 1)
  emit_signal("update_current_health", health)
  if health <= 0:
    interrupt_attack()
    emit_signal("died")
    state = DEAD
    velocity = Vector2.ZERO
    animation_player.play("death")
    $CollisionShape2D.set_disabled(true)

func deal_damage_to_target():
  if typeof(target) == TYPE_OBJECT:
    target.take_damage(attack)
      
func interrupt_attack():
  state = NORMAL
  if target != null and typeof(target) == TYPE_OBJECT:
    target.disconnect("died", self, "target_killed")
    target = null
  animation_player.stop()

func target_killed():
  print("target_killed")
  if state == ATTACKING:
    interrupt_attack()
  else:
    target = null
