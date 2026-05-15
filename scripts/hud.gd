extends CanvasLayer

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var secondary_progress_bar: TextureProgressBar = $SecondaryProgressBar
@onready var message: Label = $Message

@onready var player = $"../Player"

var message_tween: Tween

func _ready() -> void:
	player.change_progress_bar.connect(change_val)
	player.Message_update.connect(_on_message_update)
	message.text = ""

func change_val(progress_value: float) -> void:
	progress_bar.value = progress_value
	secondary_progress_bar.value = progress_value

func _on_message_update(msg: String, display_time: float = 1.5) -> void:
	if message_tween and message_tween.is_valid():
		message_tween.kill()

	if msg == "":
		message.text = ""
		return
	message.text = msg
	message.modulate.a = 1.0 

	if display_time > 0:
		message_tween = create_tween()
		message_tween.tween_interval(display_time)
		message_tween.tween_property(message, "modulate:a", 0.0, 0.25)
		message_tween.tween_callback(func(): message.text = "")
