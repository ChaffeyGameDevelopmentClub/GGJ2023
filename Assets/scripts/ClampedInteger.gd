# Represents an integer that is clamped between a minimum and maximum range.

extends Object
class_name ClampedInteger

# The maximum value this integer can be. Do not set this directly, use set_max_value() instead.
var _max_value := 0

# The lowest value this integer can be. Do not set this directly, use set_min_value() instead.
var _min_value := 0

# The current value of this integer. Do not set this directly, use set_value() instead.
var _value := 0

# Called whenever the current value changes.
signal on_value_changed(old_value, new_value)


func _init(min_value, max_value):
	set_min_value(min_value)
	set_max_value(max_value)


# Returns the current value.
func get_value() -> int:
	return _value

# Raise the current value. Will be clamped between the minimum and maximum value.
func raise_value(amount : int) -> void:
	set_value(_value + amount)

# Lower the current value. Will be clamped between the minimum and maximum value.
func lower_value(amount : int) -> void:
	set_value(_value - amount)

# Set the current value. Will be clamped between the minimum and maximum value.
func set_value(new_value : int) -> void:
	var old_value = _value
	_value = clamp(new_value, _min_value, _max_value)

	if _value != old_value:
		emit_signal("on_value_changed", old_value, _value)


# Set the max value. Will lower current value if the new max value is lower than the current value.
func set_max_value(new_value : int) -> void:
	if new_value < _min_value:
		printerr("Warning, ClampedInteger can't set the max value to lower than the minimum value.")
		return

	_max_value = new_value

	if _value > _max_value:
		set_value(_max_value)

# Set the min value. Will raise current value if the new min value is higher than the current value.
func set_min_value(new_value : int) -> void:
	if new_value > _max_value:
		printerr("Warning, ClampedInteger can't set the minimum value higher than the maximum value.")
		return

	_min_value = new_value

	if _value < _min_value:
		set_value(_min_value)
