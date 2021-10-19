extends Unit
class_name Archer

var projectile = preload("res://scenes/core/Arrow.tscn")

var portrait : Texture = load("res://graphics/k\'inh humans assets/k\'inh unit portraits/jungle archer icon.png")

func _ready():
  ._ready()
  speed = 250
  health = 20
  attack_range = 1000
  view_range = 1000

func handle_hit(projectile_sprite : Sprite):
  var sprite = projectile_sprite.duplicate()
  sprite.visible = true
  var arrow = projectile.instance()
  arrow.add_child(sprite)
  arrow.attacker = self
  arrow.position = position
  arrow.destination = target.position
  get_parent().add_child(arrow)

func play_animation(anim_name):
  $BodyWithAnimation.set_direction(velocity.normalized())
  if "attack" in anim_name:
    $BodyWithAnimation.set_animation("bow")
  elif "walk" in anim_name:
    $BodyWithAnimation.set_animation("walk")
  elif "death" == anim_name:
    $BodyWithAnimation.set_animation("death")
