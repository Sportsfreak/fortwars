local ply = FindMetaTable("Player")

if (SERVER) then
	function ply:sync(thing, toset)
		self:SetNetVar(thing, toset)
	end

	function ply:addPoints(amt)
		self.points = self.points + amt
		self:sync("Score", self.points)
	end

	function ply:gameLoadout()
		self:StripWeapons()

		local weps = fortwars.config.game_loadout(self)

		for k,v in pairs(weps) do
			self:Give(v)
		end

		for k,v in pairs(ply:getClass().Loadout or {}) do
			self:Give(v)
		end
	end
	
	function ply:buildLoadout()
		self:StripWeapons()

		local weps = fortwars.config.build_loadout(self)

		for k,v in pairs(weps) do
			self:Give(v)
		end
	end

	nw.Register('Score', {
		Read = function()
			return net.ReadUInt(8)
		end,
		Write = function(v)
			return net.WriteUInt(v, 8)
		end,
		LocalVar = true,
	})
end