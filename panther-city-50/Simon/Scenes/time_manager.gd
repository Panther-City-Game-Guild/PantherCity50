extends HBoxContainer

var time : int = 0

func _process(delta: float) -> void:
	var num_seconds = time % 60
	var num_minutes = int(time/60)
	var seconds = str(num_seconds) if num_seconds > 9 else ("0"+str(num_seconds))
	var minutes = str(num_minutes) if num_minutes > 9 else ("0"+str(num_minutes))
	$TimeData.text = minutes +":"+ seconds

func _on_timer_timeout() -> void:
	time += 1
