extends Control

@onready var scoreLable = $"MarginContainer/Score Lable"
@onready var errorLable = $"MarginContainer/Error Console"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scoreLable.text = str(Manager.SCORE)
