local ply = FindMetaTable("Player")

function ply:getClass()
	return (SERVER and fortwars.classes[ self.class ]) or fortwars.classes[ self:GetNetVar("Class") ]
end

function ply:getPoints()
	return (SERVER and self.points) or self:GetNetVar("Score")
end

function ply:canAfford(test)
	local points = self:getPoints()
	return (points - test >= 0)
end

function ply:getMod(smod)

end

if (SERVER) then
	function ply:savePoints()
		local sql = "UPDATE playerdata SET money = '"..self.points.."' WHERE id = '"..self:SteamID().."'"

		query(sql)
	end

	function ply:setClass(id)
		if (self.class) then
			local hk_rem = fortwars.classes[ self.class ].ability[ 1 ]

			hook.Remove(hk_rem, hk_rem..'_'..self:UniqueID())
		end

		self.class = id

		local class = fortwars.classes[ id ]
		local hk = class.ability[ 1 ]

		hook.Add(hk, hk..self:UniqueID(), class.ability[ 2 ])

		self:sync('Class', id)
	end

	function ply:saveaccount()
		local id = self:SteamID()
		local class = self:getClass()
		local classes = util.TableToJSON(self.classes)
		local money = self.points
		local achievements = util.TableToJSON(self.achievements)

		local sql = string.format('UPDATE playerdata SET class = %s, classes_owned = %s, money = %s, achieviements = %s WHERE steamid = %s',
			class, classes, money, achievements, id)
		query(sql)
	end

	function ply:loadaccount()
		query('SELECT * FROM playerdata WHERE id = "'..self:SteamID()..'"', function(res)
			res = res[ 1 ]

			if (!res) then

				local def = fortwars.config.default_points
				query("INSERT INTO playerdata (id, money) VALUES ('"..self:SteamID().."', '"..def.."')", function(data) if data then fortwars:Notify(self, "Account created!") end end)

				self:setClass(fortwars.config.default_class)
				self.classes = {}
				self.points = def
				self.acheivements = {}

				return
			end

			self:setClass(res['class'])
			self.classes = util.JSONToTable(res['classes'])
			self.points = tonumber(res['money'])
			self.achievements = util.JSONToTable(res['achievements'])

			fortwars:Notify(self, "Account loaded!")
		end)
	end

	function ply:sync(thing, toset)
		self:SetNetVar(thing, toset)
	end

	function ply:addPoints(amt)
		self.points = self.points + amt
		self:sync("Score", self.points)

		self:savePoints()
	end

	function ply:takePoints(amt)
		self.points = self.points - amt
		self:sync("Score", self.points)

		self:savePoints()
	end

	function ply:gameLoadout()
		self:StripWeapons()

		local weps = fortwars.config.game_loadout(self)

		for k,v in pairs(weps) do
			self:Give(v)
		end

		for k,v in pairs(self:getClass().loadout or {}) do
			self:Give(v)
		end

		local class = self:getClass()

		self:SetJumpPower(class.jump * self:getMod("Jump"))
		self:SetHealth(class.health)
		self:SetArmor(class.armor)
		self:SetWalkSpeed(fortwars.config.walkspeed + class.speed)
		self:SetRunSpeed(fortwars.config.runsped + class.speed)
		self:setEnergy(class.energy)
		self:setEnergyRegen(class.regen)
		self:SetModel(Model(class.model))
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