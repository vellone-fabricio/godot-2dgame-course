extends CharacterBody2D

const MAX_SPEED = 125
const ACC_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar

var number_colliding_bodies = 0

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_timeout_interval)
	health_component.health_changed.connect(on_health_changed)
	updated_health_display()

func _process(delta):
	var mov_vector = get_movement_vector()
	var direction = mov_vector.normalized()
	
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACC_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_mov, y_mov)

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()

func updated_health_display():
	health_bar.value = health_component.get_health_percentage()

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies = max(0, number_colliding_bodies - 1)

func on_damage_timeout_interval():
	check_deal_damage()

func on_health_changed():
	updated_health_display()
