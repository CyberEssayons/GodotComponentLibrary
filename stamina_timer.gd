class_name StaminaTimer extends Timer

@export var health_component: HealthComponent
@export var exhaust_time_rate: float = 1.0
@export var recover_time_rate: float = 2.0
var exhaustion_rate: float = 2.0
var recovery_rate: float = 1.0
var is_exhausting: bool = false

signal exhausted
signal recovered
signal updated


func start_sprint() -> void:
	if not is_exhausting:
		start(exhaust_time_rate)
		timeout.connect(_on_exhaust_timeout)
		is_exhausting = true
	
func stop_sprint() -> void:
	if is_exhausting:
		stop()
		if timeout.is_connected(_on_exhaust_timeout):
			timeout.disconnect(_on_exhaust_timeout)
		start(recover_time_rate)
		timeout.connect(_on_recovery_timeout)
		is_exhausting = false
	
func _on_exhaust_timeout():
	if health_component.current_stamina > 0:
		health_component.current_stamina = clampi(health_component.current_stamina - exhaustion_rate, 0, health_component.total_stamina)
	if health_component.current_stamina <= 0:
		stop_sprint()
		exhausted.emit()
	updated.emit()
		
func _on_recovery_timeout():
	if health_component.current_stamina < health_component.total_stamina:
		health_component.current_stamina = clampi(health_component.current_stamina + recovery_rate, recovery_rate, health_component.total_stamina)
	else:
		stop()
		timeout.disconnect(_on_recovery_timeout)
		recovered.emit()
	updated.emit()
