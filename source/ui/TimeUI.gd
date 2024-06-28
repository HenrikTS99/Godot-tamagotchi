extends Control

@onready var daysLabel = get_node("%DaysLabel")
@onready var hoursLabel = get_node("%HoursLabel")
@onready var minutesLabel = get_node("%MinutesLabel")

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

@export var INGAME_SPEED = 1.0
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR
var time = 0.0
var past_minute = -1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	recalculate_time()

func recalculate_time():
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if minute != past_minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)
		set_time(day, hour, minute)
	
func set_time(day, hour, minute):
	daysLabel.text = 'Day'+ str(day+1)
	hoursLabel.text = str(hour) + ':' + str(minute)
