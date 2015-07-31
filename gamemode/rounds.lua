local roundt = fortwars.config.round_length
local endt   = fortwars.config.end_length
local buildt = fortwars.config.build_length
local minp   = fortwars.config.min_players
local maxscore = fortwars.config.winning_score
local holdt    = fortwars.config.ball_hold_length
local wpoints  = fortwars.config.points_for_winning

ROUND_WATING    = 0
ROUND_BUILDING  = 1
ROUND_PLAYING   = 2
ROUND_ENDING    = 3
ROUND_STATUS    = ROUND_WAITING

local timeleft = 0
local score = {
	[TEAM_RED] = {0, holdt},
	[TEAM_BLUE] = {0, holdt},
	[TEAM_YELLOW] = {0, holdt},
	[TEAM_GREEN] = {0, holdt},
}
local holding_team = 0

function fortwars.update_status(sStatus, iTime) //this is simulated on the client, and shouldn't be called every tick
	net.Start("fw.update_round_status")
		net.WriteString(sStatus)
		net.WriteInt(iTime)
	net.Broadcast()
end

function fortwars.addScore(team, amount)
	score[ team ][ 1 ] = score[ team ][ 1 ] + amount
end

function fortwars.begin_round()
	timeleft = roundt
	self.update_status('Playing', roundt)

	for k,v in pairs(player.GetAll()) do
		v:gameLoadout()
	end
end

function fortwars.end_round(t, type) //type is either; score == 1, ball call == 2
	timeleft = endt
	holding_team = 0
	self.update_status('Ending', endt)

	net.Start("fw.broadcast_stats")
		net.WriteInt(t)
	net.Broadcast()

	for k,v in pairs(score) do
		score[ k ][ 1 ] = 0	
		score[ k ][ 2 ] = holdt
	end

	fortwars:Notify(_, team.GetColor(t), team.GetName(t), fortwars.config.white, ' has won the game!')

	for k,v in pairs(team.GetPlayers()) do
		v:addPoints(wpoints)
		fortwars:Notify(v, 'Congratulations! You have been given ', fortwars.config.green, wpoints, fortwars.config.white, ' for winning!')
	end
end

function fortwars.build_round()
	timeleft = buildt

	for k,v in pairs(player.GetAll()) do
		v:buildLoadout()//todo prepspawn
	end
end

function fortwars:GravGunOnPickedUp(ply, ent)
	if (ent:GetClass() == 'fw_ball') then
		holding_team = ply:Team()

		self:Notify(_, team.GetColor(ply:Team()), team.GetName(ply:Team()), self.config.white, ' has picked up the ball!')
	end
end

function fortwars:GravGunOnDropped(ply, ent)
	if (ent:GetClass() == 'fw_ball') then
		holding_team = 0

		self:Notify(_, team.GetColor(ply:Team()), team.GetName(ply:Team()), self.config.white, ' has dropped the ball!')
	end
end

timer.Create('FW.RoundHandler', 1, 0, function()
	if (#player.GetAll() < minp) then 
		fortwars.update_status("Waiting...", 1)
		return 
	end

	if (timeleft == 0) then
		if (ROUND_STATUS == ROUND_WAITING or ROUND_STATUS == ROUND_ENDING) then
			fortwars.build_round()
		elseif (ROUND_STATUS == ROUND_BUILDING) then
			fortwars.begin_round()
		elseif (ROUND_STATUS == ROUND_PLAYING) then
			fortwars.end_round()			
		end

		return
	end

	for k,v in pairs(score) do
		if (v[ 1 ] >= maxscore) then
			fortwars.end_round(k, 1)

			break
		elseif (v[ 2 ] == 0) then
			fortwars.end_round(k, 2)

			break
		end
	end

	if (holding_team != 0) then
		score[ holding_team ] = score[ holding_team ] - 1
		net.Start("fw.update_ball_time")
		net.WriteInt(holding_team)
		net.Broadcast()
	end

	for k,v in pairs(player.GetAll()) do
		local v = v:getClass().energy
		v.energy = v.energy - 
	end

	timeleft = timeleft - 1
end)