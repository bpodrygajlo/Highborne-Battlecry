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
var type_name = "Unit"

func reset():
  health = max_health
  emit_signal("update_max_health", max_health)
  emit_signal("update_current_health", health)
  state = NORMAL
  target = null
  velocity = Vector2.ZERO
  
func _ready():
  reset()
  var anim_body : BodyWithAnimation = $BodyWithAnimation
# warning-ignore:return_value_discarded
  anim_body.connect("hit", self, "handle_hit")
# warning-ignore:return_value_discarded
  anim_body.connect("attack_finished", self, "handle_attack_finished")
# warning-ignore:return_value_discarded
  anim_body.connect("death", self, "handle_death")

func goto(position, tolerance = 2):
  var diff : Vector2 = position - transform.origin
  if diff.length() > tolerance:
    velocity = diff.normalized() * speed
    return false
  else:
    velocity = Vector2.ZERO
    return true

func _physics_process(_delta):
  velocity = move_and_slide(velocity, Vector2.UP)
  update_animation()

func set_target(new_target):
  if typeof(target) == TYPE_OBJECT:
    target.disconnect("died", self, "target_killed")
  target = new_target
  if typeof(target) == TYPE_OBJECT:
    target.connect("died", self, "target_killed")


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
    $CollisionShape2D.set_disabled(true)
    play_animation("death")

func deal_damage_to_target():
  if typeof(target) == TYPE_OBJECT:
    target.take_damage(attack)
      
func interrupt_attack():
  state = NORMAL
  if target != null and typeof(target) == TYPE_OBJECT:
    target.disconnect("died", self, "target_killed")
    target = null
  stop_all_animation()

func target_killed():
  if state == ATTACKING:
    interrupt_attack()
  else:
    target = null

func handle_hit():
  deal_damage_to_target()

func handle_attack_finished():
  if state == ATTACKING:
    state = NORMAL

func handle_death():
  queue_free()

func play_animation(anim_name):
  $BodyWithAnimation.set_direction(velocity.normalized())
  if "attack" in anim_name:
    $BodyWithAnimation.set_animation("attack")
  elif "walk" in anim_name:
    $BodyWithAnimation.set_animation("walk")
  elif "death" == anim_name:
    $BodyWithAnimation.set_animation("death")

func stop_all_animation():
  $BodyWithAnimation.stop()


func update_animation():
  if state == NORMAL:
    if velocity.length() < 10:
      return
    if abs(velocity.x) > abs(velocity.y):
      if velocity.x > 0.1:
        play_animation("walk_right")
      elif velocity.x < -0.1:
        play_animation("walk_left")
    else:
      if velocity.y > 0.1:
        play_animation("walk_down")
      elif velocity.y < -0.1:
        play_animation("walk_up")
