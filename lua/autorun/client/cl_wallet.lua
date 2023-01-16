-------------------------------------------------------------------
--	Author		= SlownLS, enzoFR60, la_ref
-------------------------------------------------------------------

include("autorun/sh_wallet.lua")

--[[-------------------------------------------------------------------------
	Blur
---------------------------------------------------------------------------]]

local blur = Material 'pp/blurscreen' function drawBlur( pan, amt ) local x, y = pan:LocalToScreen( 0, 0 ) surface.SetDrawColor( 255, 255, 255 ) surface.SetMaterial( blur ) for i = 1, 3 do blur:SetFloat( '$blur', ( i / 3 ) * ( amt or 6 ) ) blur:Recompute(  ) render.UpdateScreenEffectTexture(  ) surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() ) end end

--[[-------------------------------------------------------------------------
	Wallet Menu
---------------------------------------------------------------------------]]

surface.CreateFont( "portemonnaie_darkrpfr", {
	font = "Montserrat Medium",
	extended = false,
	size = 28,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

surface.CreateFont( "portemonnaie_darkrpfr_titre", {
	font = "Readex Pro Bold",
	extended = false,
	size = 28,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

net.Receive( "Wallet:Player:OpenMenu", function()
	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 500, 162 )
	Base:Center()
	Base:SetTitle( "" )
	Base:SetDraggable( false )
	Base:ShowCloseButton(false)
	Base:MakePopup()
	Base.Paint = function( self, w, h )
		drawBlur( self, 8 )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 35, 35, 40, 245 ) )
		draw.RoundedBox( 1, 0, 0, w, 48, Color( 28, 28, 33, 255 ) )    
		 
	  if Wallet.ArgentIllegal then
		draw.SimpleText( Wallet.LanguageHave.." "..LocalPlayer():GetNWInt("player_money_illegal")..Wallet.LanguageSignMoney.." "..Wallet.LanguageMoneyIllegal, "portemonnaie_darkrpfr", w / 2 , 63, color_white, TEXT_ALIGN_CENTER )
		draw.SimpleText( Wallet.LanguageHave.." " .. LocalPlayer():getDarkRPVar( 'money' ) ..Wallet.LanguageSignMoney.. " "..Wallet.LanguageMoney, "portemonnaie_darkrpfr", w / 2 , 43, color_white, TEXT_ALIGN_CENTER )
	  else
	  draw.SimpleText( Wallet.LanguageHave.." " .. LocalPlayer():getDarkRPVar( 'money' ) .. Wallet.LanguageSignMoney.." "..Wallet.LanguageMoney, "portemonnaie_darkrpfr", w / 2 , 53, color_white, TEXT_ALIGN_CENTER )
	end
	end

    local monnaie_darkrp_img = vgui.Create( "DImage", Base )
	monnaie_darkrp_img:SetPos( 8, 8 )
	monnaie_darkrp_img:SetSize( 128, 32 )
	monnaie_darkrp_img:SetImage( "darkrpfrlogo" )

	local monnaie_darkrp_titre = vgui.Create( "DLabel", Base )
	monnaie_darkrp_titre:SetPos( (500/2)-14, 8 )
	monnaie_darkrp_titre:SetSize( 146, 32 )
	monnaie_darkrp_titre:SetColor(color_white)
	monnaie_darkrp_titre:SetFont("portemonnaie_darkrpfr_titre")
	monnaie_darkrp_titre:SetText("Portes-monnaie")

	local monnaie_closeButton = vgui.Create("DButton" , Base)
	monnaie_closeButton:SetPos(500-34,12)
	monnaie_closeButton:SetSize(24,24)
	monnaie_closeButton:SetText("")
	monnaie_closeButton:SetFont("rhc_darkrp_close")
	monnaie_closeButton.Paint = function(self, w, h)
		if monnaie_closeButton:IsHovered() then
			draw.RoundedBox(0,0,0, w, h, color_white )
			draw.SimpleText( "✖", "rhc_darkrp_close", 12, 11, Color(28, 28, 33), 1,1 )
		else
			draw.SimpleText( "✖", "rhc_darkrp_close", 12, 11, color_white, 1,1 )
			surface.SetDrawColor(255,255,255,255)
			surface.DrawOutlinedRect( 0, 0, w, h, 2 )
		end
	end
	monnaie_closeButton.DoClick = function()
		Base:Close()
	end 

	local Money = vgui.Create( "DTextEntry", Base )
	Money:SetSize( Base:GetWide() - 10, 25 )
	Money:SetPos( 5, 88 )
	Money:SetText( Wallet.LanguageEnterAmount )
	Money:SetNumeric( true )
	Money.OnGetFocus = function( self ) if self:GetText() == Wallet.LanguageEnterAmount then self:SetText( '' ) end end
	Money.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( Wallet.LanguageEnterAmount ) end end

	local DropMoney = vgui.Create( "DButton", Base )
	DropMoney:SetSize( 240, 35 )
	DropMoney:SetPos( 5, Base:GetTall() - 42 )
	DropMoney:SetText( Wallet.LanguageDropMoney )
	DropMoney:SetFont( 'portemonnaie_darkrpfr' )
	DropMoney:SetTextColor(  Color( 255, 255, 255, 200 ) )
	DropMoney.OnCursorEntered = function( self ) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
	DropMoney.OnCursorExited = function( self ) self.hover = false end
	DropMoney.Slide = 0
	DropMoney.Paint = function( self, w, h )
		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.RoundedBox(4, 0, 0, w, h, Color( 35, 35, 40, 255 ) )
			draw.RoundedBox(4, 0, 0, self.Slide, h, Color( 147, 13, 13, 255 ) )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )
			draw.RoundedBox(4, 0, 0, w, h, Color( 35, 35, 40, 255 ) )
			draw.RoundedBox(4, 0, 0, self.Slide, h, Color( 147, 13, 13, 255 ) )
		end
	end	
	DropMoney.DoClick = function()
		if Money:GetValue() == "" || Money:GetValue() == Wallet.LanguageEnterAmount then return end

		net.Start( "Wallet:Player:DropMoney" )
		net.WriteInt( Money:GetValue(), 32 )
		net.SendToServer()

		Base:Remove()
	end

	local GiveMoney = vgui.Create( "DButton", Base )
	GiveMoney:SetSize( 245, 35 )
	GiveMoney:SetPos( 250, Base:GetTall() - 42 )
	GiveMoney:SetText( Wallet.LanguageGiveMoney )
	GiveMoney:SetFont( 'portemonnaie_darkrpfr' )
	GiveMoney:SetTextColor(  Color( 255, 255, 255, 200 ) )
	GiveMoney.OnCursorEntered = function( self ) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
	GiveMoney.OnCursorExited = function( self ) self.hover = false end
	GiveMoney.Slide = 0
	GiveMoney.Paint = function( self, w, h )
		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.RoundedBox(4, 0, 0, w, h, Color( 35, 35, 40, 255 ) )
			draw.RoundedBox(4, 0, 0, self.Slide, h, Color( 147, 13, 13, 255 ) )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )
			draw.RoundedBox(4, 0, 0, w, h, Color(35, 35, 40, 255 ) )
			draw.RoundedBox(4, 0, 0, self.Slide, h, Color( 147, 13, 13, 255 ) )
		end
	end
	GiveMoney.DoClick = function()
		if Money:GetValue() == "" || Money:GetValue() == Wallet.LanguageEnterAmount then return end
		
		net.Start( "Wallet:Player:GiveMoney" )
		net.WriteInt( Money:GetValue(), 32 )
		net.SendToServer()

		Base:Remove()
	end
end)
