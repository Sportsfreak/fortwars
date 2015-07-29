local ent = FindMetaTable('Entity')

if (SERVER) then
	function ent:setOwner(ply)
		self.owner = ply
		self:SetNWInt("OwnerIndex", ply:EntIndex())
	end

	function ent:canModify(modifier)
		return (modifier == self.owner) or (self.owner.buddies and self.owner.buddies[ modifier ])
	end

	function fortwars:PlayerSpawnProp(ply, model)
		local tbl = self.config.prop_list(ply)

		if (ROUND_STATUS != ROUND_BUILDING) then return false end

		local mprops = self.config.max_props(ply) or 25

		if (ply:getPropCount() >= mprops) then return false end
		
		if (tbl and !table.HasValue(tbl, model)) then return false end
	end

	function fortwars:PlayerSpawnedProp(ply, mdl, ent)
		ent:setOwner(ply)
	end

	function fortwars:PhysgunPickup(ply, ent)
		return (ply:IsAdmin() and ply.is_administrating) or ent:canModify(ply)
	end

end

function ent:getOwner()
	return (SERVER and self.owner) or Entity(self:GetNWInt('OwnerIndex'))
end