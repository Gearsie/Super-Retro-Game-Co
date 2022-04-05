pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
local centreX = 64
local centreY = 64
local radius = 60
local position = 0
local timing = 0
local x_v = 0
local circle_wedge = 0.125
local start_wedge = 0.062
local holding_Left_Up = false
local holding_Right_Up = false
local holding_Left_Down = false
local holding_Right_Down = false
local debug_buffer
local logo_sprCount 
local logo_pix

function _init()
	poke(0x5f5c,255)
	poke(0x5f5d,255)
	logo_sprCount=5
	logo_pix={}
end

function _update()
	-- run the Background --
	if logo_sprCount%7==0 then
		add( logo_pix, make_pix(60,60,(flr(rnd(6))-3),(flr(rnd(6))-3),5,10) )
	end
	
	for obj in all(logo_pix) do
		obj:update()
		
		if obj.life<=0 then
			del(logo_pix,obj)
		end
	end
	
	logo_sprCount+=1
	
	-- Manage Buttons --

	if btnp (⬅️) then
		if ( y >= 64 ) then
			holding_Left_Up = true
		else
			holding_Left_Down = true
		end
	elseif btnp (➡️) then
		if ( y >= 64 ) then
			holding_Right_Up = true
		else
			holding_Right_Down = true
		end
	end
	
	if btn(⬅️) then
		if (( y >= 64 ) or ( holding_Left_Up == true )) and ( holding_Left_Down == false )  then
			x_v=-0.01
		elseif ( y < 64 ) or ( holding_Left_Down == true ) then
			x_v=0.01
		end
		holding_Right_Up = false
		holding_Right_Down = false
	elseif btn(➡️) then
		if (( y >= 64 ) or ( holding_Right_Up == true )) and ( holding_Right_Down == false )   then
			x_v=0.01
		elseif ( y < 64 ) or ( holding_Right_Down == true ) then
			x_v=-0.01
		end
		holding_Left_Up = false
		holding_Left_Down = false
	else
		x_v=0
		holding_Left_Up = false
		holding_Left_Down = false
		holding_Right_Up = false
		holding_Right_Down = false
	end	
end

function _draw()
	cls()
	
	for obj in all(logo_pix) do
		obj:draw()
	end

	position = position + x_v

	if position >= 1.0 then
		position = position - 1.0
	elseif position <= -1.0 then
		position = position + 1.0
	end

	x = (centreX + radius*cos(position))
	y = (centreY + radius*sin(position))
	
	if ( y >= 64 ) then
		if ( x > 0 ) and ( x < 17 ) then
			spr( 003, x-4, y-4, 1, 1, true, false )
		elseif ( x >= 17 ) and ( x < 47 ) then
			spr( 002, x-4, y-4, 1, 1, true, false )
		elseif ( x >= 47 ) and ( x < 81 ) then
			spr( 001, x-4, y-4 )
		elseif ( x >= 81 ) and ( x < 111 ) then
			spr( 002, x-4, y-4 )
		else
			spr( 003, x-4, y-4 )
		end
	else
		if ( x > 0 ) and ( x < 17 ) then
			spr( 003, x-4, y-4, 1, 1, true, false )
		elseif ( x >= 17 ) and ( x < 47 ) then
			spr( 002, x-4, y-4, 1, 1, true, true )
		elseif ( x >= 47 ) and ( x < 81 ) then
			spr( 001, x-4, y-4, 1, 1, false, true )
		elseif ( x >= 81 ) and ( x < 111 ) then
			spr( 002, x-4, y-4, 1, 1, false, true )
		else
			spr( 003, x-4, y-4, 1, 1, false, true )
		end
	end
	
end


function make_pix(x,y,v_x,v_y,colour,life)
	local obj={
		x=x,
		y=y,
		v_x=v_x,
		v_y=v_y,
		colour=colour,
		life=life,
		update=function(self)
			x+=v_x
			y+=v_y
			life-=1
		end,
		draw=function(self)
			line(x, y, x, y, colour)
		end
	}
	return obj
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000550000555000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700005665000566550000556650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000005665000566665005666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000056666500056665005666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700056666500056665000556650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005665000005550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
