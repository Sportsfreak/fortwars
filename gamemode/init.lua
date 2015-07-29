include "mysql/sql.lua"

include "extensions/net.lua"
include "shared.lua"
include "config.lua"
include "rounds.lua"
include "classes.lua"
include "props.lua"
include "extensions/player.lua"
include "extensions/entity.lua"

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "extensions/net.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "classes.lua"
AddCSLuaFile "props.lua"
AddCSLuaFile "extensions/player.lua"
AddCSLuaFile "extensions/entity.lua"
AddCSLuaFile "config.lua"

util.AddNetworkString('fw.update_round_status') //note: sends both time and status
util.AddNetworkString("fw.broadcast_stats")
util.AddNetworkString('fw.update_ball_time') //sends the time every second they have the ball
