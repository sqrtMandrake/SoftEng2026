extends Panel

var my_timer: MyTimer

@onready var timer_label: Label = %TimerLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var split_container: VBoxContainer = %SplitContainer

var split_count: int = 0

func _ready() -> void:
	my_timer = MyTimer.new()
	if OS.get_name() == "Android":
		OS.request_permissions()

func _process(_delta: float) -> void:
	update_text()

func update_text() -> void:
	var time_sec: float = my_timer.get_ticks() / 1000000.0
	timer_label.text = "%02d:%02d:%02d.%03.0f" % [time_sec/3600, fmod(time_sec/60, 60), fmod(time_sec, 60), floorf(fmod(time_sec, 1) * 1000)]

func scroll_split_container_down() -> void:
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)

func _on_start_button_pressed() -> void:
	my_timer.start_timer()
	split_count = 0
	for node: Node in split_container.get_children():
		node.queue_free()

func _on_split_button_pressed() -> void:
	my_timer.add_split()
	var split: Label = Label.new()
	var time_sec: float = my_timer.splits[split_count] / 1000000.0
	split.text = "%02d:%02d:%02d.%03.0f" % [time_sec/3600, fmod(time_sec/60, 60), fmod(time_sec, 60), floorf(fmod(time_sec, 1) * 1000)]
	split_count += 1
	split.add_theme_font_size_override(&"font_size", 30)
	split_container.add_child(split)
	get_tree().process_frame.connect(scroll_split_container_down, 4)

func _on_stop_button_pressed() -> void:
	my_timer.stop_timer()


func _on_tests_button_pressed() -> void:
	%FileDialog2.popup()
	

func _on_export_button_pressed() -> void:
	%FileDialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	var close_this: FileAccess = my_timer.export_to_csv(path)
	close_this.close()


func _on_file_dialog_2_file_selected(path: String) -> void:
	var timer_tester: Test = Test.new()
	timer_tester.export_file_path = path
	add_child(timer_tester)
	timer_tester.run_tests()
