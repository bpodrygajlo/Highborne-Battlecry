extends KinematicBody2D
class_name Unit

enum {NORMAL, ATTACKING, HURT, DEAD}

signal update_max_health(max_health)
signal update_current_health(current_health)

var speed = 3
var velocity = Vector2.ZERO
var target_position = null
var target_enemy = null
var health = 3
var max_health = 3
var state = NORMAL
var animation_player = null
var type_name = "Unit"
var time_since_last_damage_attack = 10
var time_since_last_wander = 10

var strength = 2
var dexterity = 2
var vitality = 2
var level = 1

func _set_max_health():
  max_health = 20 + vitality * 10
  
func _calc_damage():
  return strength * 2 + randi() % 5
  
func get_defense():
  return dexterity * 2
  
func get_attack():
  return dexterity * 4
  
func is_in_combat():
  return time_since_last_damage_attack < 5
  
func chance_to_hit(enemy):
  var ar = get_attack()
  var dr = enemy.get_defense()
  var to_hit = 2 * (ar / (ar + dr)) * (level / (level + enemy.level))
  return max(min(to_hit, 0.95), 0.05)
  
func regen():
  var regen = 0.5 + vitality/10.0
  if is_in_combat():
    regen /= 2
  health = min(regen + health, max_health)
  emit_signal("update_current_health", health)

func reset():
  health = max_health
  emit_signal("update_max_health", max_health)
  emit_signal("update_current_health", health)
  
  state = NORMAL
  target_position = null
  velocity = Vector2.ZERO
  target_enemy = null

func _ready():
  animation_player = $AnimationPlayer
  var timer = Timer.new()
  timer.set_autostart(true)
  timer.connect("timeout", self, "regen")
  add_child(timer)
  _set_max_health()
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

func _physics_process(delta):
  velocity = move_and_slide(velocity, Vector2.UP)
  time_since_last_damage_attack += delta
  time_since_last_wander += delta
  update_animation()
  
func update_animation():
  if state == NORMAL:
    var magnitude = velocity.length()
    if magnitude > 0.5 and animation_player.has_animation("run"):
      pass #animation_player.play("run")
    elif magnitude > 0.1:
      pass #animation_player.play("walk")
    else:
      pass #animation_player.play("idle")

func set_target(position):
  target_position = position
  target_enemy = null

func set_target_monster(monster):
  if state == NORMAL:
    target_enemy = monster
    target_position = null

func _on_AnimationPlayer_animation_finished(anim_name : String):
  if "attack" in anim_name and state == ATTACKING:
    state = NORMAL

func get_max_health():
  return max_health
  
func get_current_health():
  return health

func damage(val = 1, attacker: Unit = null):
  health -= val
  time_since_last_damage_attack = 0
  emit_signal("update_current_health", health)
  if health <= 0:
    state = DEAD
    velocity = Vector2.ZERO
    animation_player.play("dead")
    $CollisionShape2D.set_disabled(true)

func get_pos():
  return transform.origin

func wander():
  var new_pos : Vector2 = transform.origin
  new_pos.x += randi() % 51 - 25
  new_pos.y += randi() % 51 - 25
  target_position = new_pos
  time_since_last_wander = randf() * 10
