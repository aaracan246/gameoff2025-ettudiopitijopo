extends Control

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
const next_scene_path: String = "res://Scenes/demo.tscn"

@export var loading_time: float

func _ready() -> void:
	start_loading()


func start_loading():
	call_deferred("load_scene_in_background")
	#No funciona en web los hilos
	#var thread = Thread.new()
	#thread.start(load_scene_in_background)
	#thread.wait_to_finish()


func load_scene_in_background():
	#var loader = 
	ResourceLoader.load_threaded_request(next_scene_path)
	var progress := []
	var elapsed_time := 0.0
	var loaded := false

	while true:
		var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100
			await get_tree().process_frame
			elapsed_time += get_process_delta_time()

		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			loaded = true
			break

		else:
			push_error("Error al cargar escena: " + next_scene_path)
			return
		
	# Esperar a que pase al menos el tiempo mínimo de carga
	while elapsed_time < loading_time:
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
		progress_bar.value = lerp(progress_bar.value, 100.0, 0.05)  # suaviza el avance
		$IconoJuego.rotate(0.1)
	# Cuando haya terminado la carga y pasado el tiempo mínimo:
	if loaded:
		Global.cont = 0
		var new_scene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().root.call_deferred("add_child", new_scene.instantiate())
		queue_free()  # eliminamos la pantalla de carga
