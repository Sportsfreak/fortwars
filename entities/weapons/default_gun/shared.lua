if SERVER then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType = "pistol"

if CLIENT then
	SWEP.PrintName = "The Get off my Lawn Gun"
	SWEP.Author	= "Sportsfreak"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Glock.Single")
SWEP.Primary.Recoil			= 1.0
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.18
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 2.5


function SWEP:SecondaryAttack()
		if CLIENT then return end
		self.Owner:EmitSound ("vo/npc/male01/hacks0" .. math.random( 1, 2 ) .. ".wav", 100, 100)
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end


