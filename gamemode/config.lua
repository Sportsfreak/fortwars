fortwars.config = fortwars.config or {}

fortwars.config.round_length = 10 // minutes
fortwars.config.build_length = 4
fortwars.config.prep_length  = .1
fortwars.config.end_length   = .5
fortwars.config.min_players  = 2
fortwars.config.max_props = function(ply)
	return 25 //return a modified value based on usergroup etc
end
fortwars.config.prop_list = function(ply)
	return {} //return a table of allowed props here
end
fortwars.config.game_loadout = function(ply)
	return {} //return a table of fighting weapons here
end
fortwars.config.build_loadout = function(ply)
	return {} //return a table of fighting weapons here
end
fortwars.config.winning_score = 100
fortwars.config.ball_hold_length = 2.5
fortwars.config.points_for_winning = 100