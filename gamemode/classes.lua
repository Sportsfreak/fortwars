fortwars:registerClass("Default", {
	health = 100,
	armor  = 0,
	damage = 0, //modifier. will be used to multiply. so to do 150 damage do 1.5
	speed  = nil //leave nil for default
	energy  = 100,
	regen  = 1, //variable per second
	jump   = nil,
	model  = 'path/to/model.mdl',
	loadout = {} //leave blank for default gm loadout
	ability = function(ply) //this is called in a think hook. basically, check before you do, here.
		return
	end,
	canbuy = function(ply)
		return false //return whether or not this can be bought
	end,
	price = function(ply)
		return nil //return nothing for free
	end
})