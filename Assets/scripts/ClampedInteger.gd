extends Object
class_name ClampedInteger

var _max_value := 0
var _min_value := 0
var _value := 0

# Called whenever the current value changes.
signal on_value_changed(old_value, new_value)

func _init(min_value, max_value):
	set_min_value(min_value)
	set_max_value(max_value)


# Raise the current value.
func raise_value(amount : int) -> void:
	set_value(_value + amount)

# Lower the current value.
func lower_value(amount : int) -> void:
	set_value(_value - amount)

# Set the current value.
func set_value(new_value : int) -> void:
	pass


# Raise the max value.
func raise_max_value(amount : int) -> void:
	set_max_value(_max_value + amount)

# Lower the max value.
func lower_max_value(amount : int) -> void:
	set_max_value(_max_value - amount)

# Set the max value.
func set_max_value(new_value : int) -> void:
	pass


# Raise the min value.
func raise_min_value(amount : int) -> void:
	set_min_value(_min_value + amount)

# Lower the min value.
func lower_min_value(amount : int) -> void:
	set_min_value(_min_value - amount)

# Set the min value.
func set_min_value(new_value : int) -> void:
	pass