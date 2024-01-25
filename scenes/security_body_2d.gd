extends CharacterBody2D



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var speed = 50
var dead = false
var hp = 50
var isBeingDamaged = false
var countOfDamaged = 0;

@onready var buka = $MainCaracter

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = 'hp : ' + str(hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Label.text = 'hp : ' + str(hp)
	if hp <= 0:
		dead = true
		$AnimatedSprite2D.play("fall")
		$SecurityDamaged.disabled = true
		
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta
	var player = $"../MainCaracter"
	var direction = (player.position - self.position).normalized()
	if chase == true and dead == false and isBeingDamaged == false:
		velocity.x = direction.x * speed
		if direction.x > 0:
			$AnimatedSprite2D.play("run1")
			$AnimatedSprite2D.flip_h = false
		elif dead == false:
			$AnimatedSprite2D.play("run1")
			$AnimatedSprite2D.flip_h = true
	elif dead == false and isBeingDamaged == false:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == "MainCaracter":
		chase = true


func _on_detector_body_exited(body):
	if body.name == "MainCaracter":
		chase = false


func _on_detector_area_entered(area):
	pass


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "fall":
		queue_free();
	if $AnimatedSprite2D.animation == "IsBeingDamaged":
		isBeingDamaged = false


func _on_would_be_damaged_area_entered(area):
	if area.name == "damagArea":
		isBeingDamaged = true
		countOfDamaged = area.get_parent().damage
		$TimerCanGottinDamage.start(0.25)
		
	elif area.name == "DamageAreaInFFlight":
		isBeingDamaged = true
		countOfDamaged = area.get_parent().damage
		$TimerCanGottinDamage.start(0.15)
		
	elif area.name == "AreaOfGiperAtake":
		isBeingDamaged = true
		countOfDamaged = area.get_parent().gigaDamage
		$TimerCanGottinDamage.start(0.01)
		
		


func _on_timer_can_gottin_damage_timeout():
	$AnimatedSprite2D.play("IsBeingDamaged")
	hp -= countOfDamaged
	countOfDamaged = 0
	$TimerCanGottinDamage.stop()
	
