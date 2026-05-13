extends CanvasLayer

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var secondary_progress_bar: TextureProgressBar = $SecondaryProgressBar


@onready var player = $"../Player"

func _ready() -> void:
	player.change_progress_bar.connect(change_val)

func _process(delta: float) -> void:
		change_val(player.sugar_level)

func change_val(progress_value: int) -> void:
	progress_bar.value = progress_value
	secondary_progress_bar. value = progress_value
