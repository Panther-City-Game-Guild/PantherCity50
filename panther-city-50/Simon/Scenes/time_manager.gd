extends HBoxContainer

var time: int = 0

func _process(_delta: float) -> void:
	var num_seconds: int = time % 60
	@warning_ignore("integer_division")
	var num_minutes: int = int(time/60)
	var seconds: String = str(num_seconds) if num_seconds > 9 else ("0"+str(num_seconds))
	var minutes: String = str(num_minutes) if num_minutes > 9 else ("0"+str(num_minutes))
	$TimeData.text = minutes +":"+ seconds

func _on_timer_timeout() -> void:
	time += 1
