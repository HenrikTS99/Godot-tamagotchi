extends Marker2D

@onready var coinLabel = $CoinCounter

func _ready():
	Global.coinsChanged.connect(update_counter)
	update_counter(Global.coins)

func update_counter(value):
	coinLabel.text = str(value)
