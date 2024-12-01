extends Node

var day: int = 1
var ending_status: Dictionary = {
	"jester": {
		1: false,
		2: false,
		3: false
	},
	"noble":
		{
			1: false,
			2: false,
			3: false
		},
	"mistress":
		{
			1: false,
			2: false,
			3: false
		},
	"general":
		{
			1: false,
			2: false,
			3: false
		},
	"queen":
		{
			1: false,
			2: false,
			3: false
		}
}

var flips: int = 10:
	set(value):
		flips = value
		if flips <= 0:
			Signals.shatter.emit()