-------------------------------------------------------------------
--	Author		= SlownLS, enzoFR60, la_ref
-------------------------------------------------------------------

AddCSLuaFile()

include("autorun/sh_wallet.lua")

SWEP.PrintName = "Porte-Monnaie"
SWEP.Author = "SlownLS, enzoFR60, la_ref"
SWEP.Category = "Porte-Monnaie"
SWEP.Instructions = ""

SWEP.AnimPrefix  = ""
SWEP.WorldModel = ""
SWEP.Slot = 1

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType( "normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:DrawWorldModel() end

function SWEP:PreDrawViewModel(vm)
    return true
end

--[[-------------------------------------------------------------------------
	Primary Attack
---------------------------------------------------------------------------]]

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.2 )

	if Wallet.openmenu then
		if SERVER then
			net.Start( "Wallet:Player:OpenMenu" )
			net.Send( self.Owner )
		end
		else
		self.Owner:ChatPrint("Wallet is off" )
	end
end

--[[-------------------------------------------------------------------------
	Secondary Attack 
---------------------------------------------------------------------------]]

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.2 )

	if Wallet.openmenu then
		if SERVER then
			net.Start( "Wallet:Player:OpenMenu" )
			net.Send( self.Owner )
		end
		else
		self.Owner:ChatPrint("Wallet is off" )
	end
end
