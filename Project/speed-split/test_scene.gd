extends Node2D

const MAIN = preload("uid://b6q4d3vsu6ry8")

var timer: Node2D

func _ready() -> void:
	test_timer_start()
	test_timer_precision()

func create_new_timer() -> void:
	timer = MAIN.instantiate()
	add_child(timer)

func test_timer_start() -> void:
	create_new_timer()
	timer.start_timer()
	await get_tree().process_frame
	assert(timer.get_ticks() > 0, "Timer didn't start!")

func test_timer_precision() -> void:
	create_new_timer()
	var start_timestamp: int = Time.get_ticks_usec()
	timer.start_timer()
	
	while Time.get_ticks_usec() - start_timestamp < 1000000:
		pass
	print(timer.get_ticks())
	assert(abs(timer.get_ticks() - 1000000) < 1000, "Timer is more than 1ms imprecise!")
