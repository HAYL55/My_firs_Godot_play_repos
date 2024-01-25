extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -370.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer11 = $Timer1
var damage = 40;
var gigaDamage = 100;
var isAtacing = false;
var isGigaAtacing = false;
var isFucfly = 0;
var isJumping = false;
var isScreaming = false;
var hitPoints = 100;
var foo = 0;
var megagoga1 = 'megagoga'

@onready var anim = $AnimatedSprite2D

func _ready():
	$Timer1.start(1)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and isFucfly == 0:
		velocity.y += (gravity * delta)
		
	$Label.text = 'hp : ' + str(hitPoints)
	
	if foo == 2:
		$Timer1.stop()

	# Handle Jump.
	if (Input.is_action_just_pressed("jump")) and is_on_floor() and isFucfly == 0 and isAtacing == false and isGigaAtacing == false and isScreaming == false:
		velocity.y = JUMP_VELOCITY
		anim.play("jump1")
		isJumping = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("right") and isAtacing == false and isJumping == false and isFucfly == 0 and isGigaAtacing == false and isScreaming == false:
		velocity.x = SPEED
		if velocity.y == 0:
			$AnimatedSprite2D.flip_h = false
			anim.play("run")
	elif Input.is_action_pressed("left") and isAtacing == false and isJumping == false and isFucfly == 0 and isGigaAtacing == false and isScreaming == false:
		velocity.x = -SPEED
		if velocity.y == 0:
			$AnimatedSprite2D.flip_h = true
			anim.play("run")
	elif isFucfly == 0 and isScreaming == false:
		if velocity.y == 0:
			velocity.x = 0
			if isAtacing == false and isJumping == false:
				anim.play("idle")
		
	if (Input.is_action_just_pressed("strike")) and velocity.y == 0 and isFucfly == 0 and isGigaAtacing == false and isScreaming == false:
		anim.play("strike1");
		isAtacing = true;
		$damagArea/CollisionShape2D.disabled = false;
		
		
	if (Input.is_action_just_pressed("Fflight")) and isJumping == false:
		anim.play("fukingFly");
		velocity.x = 0;
		velocity.y = 0;
		isFucfly += 1;
		if (Input.is_action_just_pressed("Fflight")) and isFucfly == 2:
			anim.stop();
			isFucfly = 0
			
			
	if (Input.is_action_just_pressed("strike")) and isFucfly == 1:
		anim.play("FukingFlightStrike1");
		$DamageAreaInFFlight/CollisionShape2D.disabled = false;		
		
		
		
	
		
	if Input.is_action_pressed("right") and isAtacing == false and isJumping == false and isFucfly == 1 and isGigaAtacing == false :
		velocity.x = SPEED
	if Input.is_action_pressed("left") and isAtacing == false and isJumping == false and isFucfly == 1 and isGigaAtacing == false :
		velocity.x = -SPEED
	if (Input.is_action_pressed("Fup")) and isFucfly == 1 and isGigaAtacing == false :
		velocity.y = -SPEED
	if (Input.is_action_pressed("Fdown")) and isFucfly == 1 and isGigaAtacing == false :
		velocity.y = SPEED
		
		
	if Input.is_action_just_released("right") or Input.is_action_just_released("left") and isFucfly == 1 and isGigaAtacing == false :
		velocity.x = 0
	if Input.is_action_just_released("Fup") or Input.is_action_just_released("Fdown") and isFucfly == 1 and isGigaAtacing == false :
		velocity.y = 0
		
	if Input.is_action_just_released("Gigastrike") and isFucfly == 1:
		$AnimatedSprite2D.play("GiperStrike")
		isGigaAtacing = true
		$AreaOfGiperAtake/CollisionShape2D.disabled = false
		if $AnimatedSprite2D.flip_h == false:
			velocity.x = 300
		elif $AnimatedSprite2D.flip_h == true:
			velocity.x = -300
			
		
		
	
	
	if velocity.y > 0 and isFucfly == 0:
		anim.play("fall1")
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false;
		$damagArea/CollisionShape2D.position.x = 70
		$damagArea/CollisionShape2D.rotation = -68
		$DamageAreaInFFlight/CollisionShape2D.position.x = 70
		$AreaOfGiperAtake/CollisionShape2D
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true;
		$damagArea/CollisionShape2D.position.x = -32
		$damagArea/CollisionShape2D.rotation = 68
		$DamageAreaInFFlight/CollisionShape2D.position.x = -32
		
	
	
	
	move_and_slide()







func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "strike1":
		$damagArea/CollisionShape2D.disabled = true;
		isAtacing = false;
	if anim.animation == "fall1":
		isJumping = false;
	elif anim.animation == "jump1":
		isJumping = false;
	elif anim.animation == "FukingFlightStrike1":
		$AnimatedSprite2D.play("fukingFly")
		$DamageAreaInFFlight/CollisionShape2D.disabled = true;
	elif anim.animation == "GiperStrike":
		$AnimatedSprite2D.play("fukingFly")
		velocity.x = 0
		isGigaAtacing = false
		$AreaOfGiperAtake/CollisionShape2D.disabled = true
		
	


func _on_timer_1_timeout():
	foo += 1
