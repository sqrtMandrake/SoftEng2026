class_name MyTimer
extends Node

var start_timestamp: int
var stop_timestamp: int
var stopped: bool = true
var splits: Array[int]

func start_timer() -> void:
	stopped = false
	start_timestamp = Time.get_ticks_usec()
	splits = []

func get_ticks() -> int:
	if not stopped:
		return Time.get_ticks_usec() - start_timestamp
	return stop_timestamp - start_timestamp

func stop_timer() -> void:
	if stopped:
		return
	stopped = true
	stop_timestamp = Time.get_ticks_usec()

func add_split() -> void:
	splits.append(get_ticks())

func export_to_csv(file_name: String) -> FileAccess:
	var contents: Array[String] = []
	contents.append(str(0))
	for i in splits:
		contents.append(str(i))
	if stopped:
		contents.append(str(stop_timestamp))
	else:
		contents.append(str(get_ticks()))
	
	var file: FileAccess = FileAccess.open(file_name, FileAccess.WRITE_READ)
	file.store_csv_line(contents)
	return file

#func _process(delta: float) -> void:
	#current_timestamp = Time.get_ticks_usec()
	#label.text = str(current_timestamp)
