fortwars = fortwars or GAMEMODE

TEAM_RED = 1
TEAM_BLUE = 2
TEAM_YELLOW = 3
TEAM_GREEN = 4

team.SetUp(TEAM_RED, "Team Red", Color(255, 25, 25))
team.SetUp(TEAM_BLUE, "Team Blue", Color(25, 25, 255))

if (fortwars.y_g_enabled) then
	team.SetUp(TEAM_YELLOW, "Team Yellow", Color(255, 255, 25))
	team.SetUp(TEAM_GREEN, "Team Green", Color(25, 255, 25))
end

fortwars.classes = fortwars.classes or {}

local con = fortwars.config

function fortwars:registerClass(index, tbl)
	fortwars.classes[ index ] = {
		health = tbl.health or con.def_health,
		armor  = tbl.armor  or con.def_armor,
		dmg    = tbl.damage or con.def_damage,
		speed  = tbl.speed  or con.def_speed,
		energy = tbl.energy or con.def_energy,
		regen  = tbl.energy_regen or con.def_enery_regen,
		jump   = tbl.jump   or con.def_jump,
		model  = tbl.model,
		loadout = tbl.loadout or {},
		ability = tbl.ability or function() end,
		canbuy = tbl.canbuy or function() return true end,
		price = tbl.price
	}
end