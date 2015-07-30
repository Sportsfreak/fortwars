fortwars:registerClass("Default", {
	health = 100,
	armor  = 0,
	damage = 0, //modifier. will be used to multiply. so to do 150 damage do 1.5
	speed  = nil //leave nil for default
	energy  = 100,
	regen  = 1, //variable per second
	jump   = nil,
	model  = 'path/to/model.mdl',
	desc   = '',
	loadout = {} //leave blank for default gm loadout
	ability = {'hookName', function(args_for_hook)
		return
	end},
	canbuy = function(ply)
		return false //return whether or not this can be bought
	end,
	price = function(ply)
		return nil //return nothing for free 
	end
})