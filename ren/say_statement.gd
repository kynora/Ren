## This is RenAPI ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

extends "statement.gd"

func _init():
	type = "say"
	kws = ["how", "what"]

func use(dbg = true):
	if dbg:
		debug(kws)
	
	if "how" in kwargs:
		if kwargs.how in ren.values:
			if ren.values[kwargs.how].type == "Character":
				var how = ren.values[kwargs.how].value
				kwargs.how = how.parse_character()
				
				if "avatar" in ren.values[org_kwargs.how].value.kwargs:
					kwargs["avatar"] = ren.values[org_kwargs.how].value.kwargs.avatar
				
				if "what" in kwargs:
					kwargs.what = how.parse_what(kwargs.what)
	
	if "how" in kwargs:
		kwargs.how = text_passer(kwargs.how)
	
	if "what" in kwargs:
		kwargs.what = text_passer(kwargs.what)
	
	.use(false)
	kwargs = org_kwargs
	