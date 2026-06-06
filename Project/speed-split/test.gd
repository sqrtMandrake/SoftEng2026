class_name Test
extends Node

var export_file_path: String

func run_tests() -> void:
	await test_timer_start()
	test_timer_precision()
	await test_timer_stops()
	await test_timer_splits()
	print("I'm about to export to CSV...")
	await test_export_timer_to_csv()
	print("All tests completed! Quitting...")
	queue_free()

func create_new_timer() -> MyTimer:
	var timer: MyTimer = MyTimer.new()
	add_child(timer)
	return timer

func test_timer_start() -> void:
	var timer: MyTimer = create_new_timer()
	timer.start_timer()
	await get_tree().physics_frame
	assert(timer.get_ticks() > 0, "Timer didn't start!")
	timer.queue_free()

func test_timer_precision() -> void:
	var timer: MyTimer = create_new_timer()
	var start_timestamp: int = Time.get_ticks_usec()
	timer.start_timer()
	
	while Time.get_ticks_usec() - start_timestamp < 1000000:
		pass
	assert(abs(timer.get_ticks() - 1000000) < 1000, "Timer is more than 1ms imprecise!")
	timer.queue_free()

func test_timer_stops() -> void:
	var timer: MyTimer = create_new_timer()
	timer.start_timer()
	await get_tree().physics_frame
	timer.stop_timer()
	var time_1 = timer.get_ticks()
	await get_tree().physics_frame
	var time_2 = timer.get_ticks()
	assert(time_1 == time_2, "Timer didnt stop")
	timer.queue_free()

func test_timer_splits() -> void:
	var timer: MyTimer = create_new_timer()
	timer.start_timer()
	await get_tree().physics_frame
	timer.add_split()
	await get_tree().physics_frame
	timer.add_split()
	await get_tree().physics_frame
	assert(timer.splits.size() == 2, "Splits were not created")
	timer.queue_free()

func test_export_timer_to_csv() -> void:
	var timer: MyTimer = create_new_timer()
	print("Created a timer")
	timer.start_timer()
	await get_tree().physics_frame
	print("Waited a frame")
	timer.add_split()
	print("Added a split")
	timer.stop_timer()
	print("Gonna save the file to: " + export_file_path)
	var file: FileAccess = timer.export_to_csv(export_file_path)
	file.close()
	file = FileAccess.open(export_file_path, FileAccess.READ)
	if FileAccess.file_exists(export_file_path):
		print("Exists! Asserting...")
		assert(not file.get_as_text().is_empty(), "file is empty")
	else:
		print("Doesnt. fuck my stupid chungus life")
	print("I've saved the file.")
	file.close()
	print("I've closed the file.")
	timer.queue_free()
