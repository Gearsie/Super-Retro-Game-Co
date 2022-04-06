pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- All of these global variables really upset me but like WHATEVER --
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
local background_sprCount 
local background_pix
local player
local obstacles
local gametime
local player_hit
local hit_anim_state
local score
local speed


function _init()
	-- This part turns off the delay/refresh on btnp --
	-- It's for the movement controls I swear --
	poke(0x5f5c,255)
	poke(0x5f5d,255)
	--
	
	background_sprCount=5
	background_pix={}
	
	
	--gumball = make_object(004, 60, 60, 1, 1 )
	lollipop = make_pop()
	obstacles = {}
	add( obstacles, lollipop )
	player = make_player()
	
	gametime=0
	
	player_hit=false
	hit_anim_state=0
	score=0
	
	speed=60
	
	sfx(1, 1)
	
end

function _update()
	if (player_hit == false) then
		-- Run the Background --
		if background_sprCount%7==0 then
			add( background_pix, make_pix(64,64,(flr(rnd(6))-3),(flr(rnd(6))-3),5,10) )
		end
		
		for obj in all(background_pix) do
			obj:update()
			
			if obj.life<=0 then
				del(background_pix,obj)
			end
		end
		
		background_sprCount+=1
		--
		
		-- Handle the Player --
		player:update()
		--
		
		-- Handle obstacles --
		for obj in all( obstacles ) do
			obj:update()
			
			if obj.distance>200 then
				del( obstacles,obj )
			end
			
		end
		--
		
		gametime+=1
		
		
		if gametime%speed==0 then
			lollipop = make_pop()
			add( obstacles, lollipop )
			score+=10
		end
		
		if gametime==300 then
			speed = 30
		end
		
		if gametime==600 then
			speed = 15
		end
		
		if gametime==900 then
			speed = 10
		end
		
		if gametime==1200 then
			speed = 5
		end
		
		if gametime==1500 then
			speed = 1
		end
	end	
	
end

function _draw()
	if (player_hit == false) then
		cls()
		
		print( "Score: ", 85, 5, 7 )
		print( score, 110, 5, 7 )
		
		-- Draw Debug stuff --
		--print(gametime)
		--
		
		-- Draw Background --
		for obj in all(background_pix) do
			obj:draw()
		end
		--

		-- Draw Player --
		player:draw()
		--
		
		-- Draw obstacles --
		for obj in all(obstacles) do
			
			obj:check_collide(player)
		
			obj:draw()
		end
		--
		
		if speed==1 then
			print( "LOLLIPOCALYPSE", 30, 40, 8)
		end
		
	elseif (player_hit == true) and (hit_anim_state<=100) then
		x = (centreX + radius*cos(position))
		y = (centreY + radius*sin(position))
		if hit_anim_state%5==0 then
			circfill(  (x+flr(rnd(8)-4))   ,(y+flr(rnd(8)-4)),( 2 + flr(rnd(2)) ),( 8 + flr(rnd(3)) ))
		end
		hit_anim_state+=1
	end
	
	
	
	
end

function make_player()
	local obj={
		collide_upper_x=90,
		collide_upper_y=90,
		collide_lower_x=90,
		collide_lower_y=90,
		update=function(self)
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
			
		end,
		draw=function(self)
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
					self.collide_upper_x=x-3
					self.collide_upper_y=y-2
					self.collide_lower_x=x
					self.collide_lower_y=y+1
				elseif ( x >= 17 ) and ( x < 47 ) then
					spr( 002, x-4, y-4, 1, 1, true, false )
					self.collide_upper_x=x-3
					self.collide_upper_y=y-2
					self.collide_lower_x=x
					self.collide_lower_y=y+1
				elseif ( x >= 47 ) and ( x < 81 ) then
					spr( 001, x-4, y-4 )
					self.collide_upper_x=x-2
					self.collide_upper_y=y-1
					self.collide_lower_x=x+1
					self.collide_lower_y=y+2
				elseif ( x >= 81 ) and ( x < 111 ) then
					spr( 002, x-4, y-4 )
					self.collide_upper_x=x-1
					self.collide_upper_y=y-2
					self.collide_lower_x=x+2
					self.collide_lower_y=y+1
				else
					spr( 003, x-4, y-4 )
					self.collide_upper_x=x-1
					self.collide_upper_y=y-2
					self.collide_lower_x=x+2
					self.collide_lower_y=y+1
				end
			else
				if ( x > 0 ) and ( x < 17 ) then
					spr( 003, x-4, y-4, 1, 1, true, false )
					self.collide_upper_x=x-3
					self.collide_upper_y=y-2
					self.collide_lower_x=x
					self.collide_lower_y=y+1
				elseif ( x >= 17 ) and ( x < 47 ) then
					spr( 002, x-4, y-4, 1, 1, true, true )
					self.collide_upper_x=x-3
					self.collide_upper_y=y-2
					self.collide_lower_x=x
					self.collide_lower_y=y+1
				elseif ( x >= 47 ) and ( x < 81 ) then
					spr( 001, x-4, y-4, 1, 1, false, true )
					self.collide_upper_x=x-2
					self.collide_upper_y=y-3
					self.collide_lower_x=x+1
					self.collide_lower_y=y
				elseif ( x >= 81 ) and ( x < 111 ) then
					spr( 002, x-4, y-4, 1, 1, false, true )
					self.collide_upper_x=x-1
					self.collide_upper_y=y-2
					self.collide_lower_x=x+2
					self.collide_lower_y=y+1
				else
					spr( 003, x-4, y-4, 1, 1, false, true )
					self.collide_upper_x=x-1
					self.collide_upper_y=y-2
					self.collide_lower_x=x+2
					self.collide_lower_y=y+1
				end
			end
				
				
		
			-- Draw collision Box for debugging --
			--rect(self.collide_upper_x,self.collide_upper_y,self.collide_lower_x,self.collide_lower_y,10)
			--
			
			
		end
	}
	
	return obj
end

function make_pop()
	local vx=0
	local vy=0
	while vx==0 and vy==0 do
		vx=rnd(2)-1
		vy=rnd(2)-1
	end
	

	local obj=make_object(012, 59, 59, vx, vy, {
	
		update=function(self)
		
			if self.lifetime <= 30 then
				self.sprite=012
				
				-- Twist around the center point --
				if self.lifetime%6==0 then
					if self.obj_x == 59 and self.obj_y == 59 then
						self.obj_x = 59
						self.obj_y = 60
					elseif self.obj_x == 59 and self.obj_y == 60 then
						self.obj_x = 60
						self.obj_y = 60
					elseif self.obj_x == 60 and self.obj_y == 60 then
						self.obj_x = 60
						self.obj_y = 59
					elseif self.obj_x == 60 and self.obj_y == 59 then
						self.obj_x = 59
						self.obj_y = 59
					end
				end
			else
				-- Start moving to the edge of the screen --
				self.distance+=1
				self.obj_x+=self.vel_x
				self.obj_y+=self.vel_y
			end
			
			if self.lifetime > 30 then
				if self.distance == 0 then
					self.sprite=012
				elseif self.distance >= 5 and self.distance < 15 then
					self.sprite=010
				elseif self.distance >= 15 then 
					self.sprite=008
				end
			end
		
			self.lifetime+=1
			
			if self.lifetime%5==0 then
				self.spin+=1
				if self.spin>4 then
					self.spin=1
				end
			end
			
			if self.spin==1 then
				self.collide_upper_x=self.obj_x+1
				self.collide_upper_y=self.obj_y
				self.collide_lower_x=self.obj_x+5
				self.collide_lower_y=self.obj_y+8
			elseif self.spin==2 then
				self.collide_upper_x=self.obj_x
				self.collide_upper_y=self.obj_y+2
				self.collide_lower_x=self.obj_x+8
				self.collide_lower_y=self.obj_y+6
			elseif self.spin==3 then
				self.collide_upper_x=self.obj_x+1
				self.collide_upper_y=self.obj_y
				self.collide_lower_x=self.obj_x+5
				self.collide_lower_y=self.obj_y+8
			elseif self.spin==4 then
				self.collide_upper_x=self.obj_x
				self.collide_upper_y=self.obj_y+2
				self.collide_lower_x=self.obj_x+8
				self.collide_lower_y=self.obj_y+6
			end
			
		end,
		draw=function(self)
			-- A generic draw function for debugging, I'll overwrite this in the --
			--  unique make functions for the different obstacles --
			
			if self.spin==1 then
				spr( self.sprite, self.obj_x, self.obj_y )
			elseif self.spin==2 then
				spr( self.sprite+1, self.obj_x, self.obj_y )
			elseif self.spin==3 then
				spr( self.sprite, self.obj_x, self.obj_y, 1, 1, false, true  )
			elseif self.spin==4 then
				spr( self.sprite+1, self.obj_x, self.obj_y, 1, 1, true, false )
			end
			
			-- Draw collision Box for debugging --
			--rect(self.collide_upper_x,self.collide_upper_y,self.collide_lower_x,self.collide_lower_y,10)
			--
		end
	
	} )

	return obj
end

-- Make gumball obstacle that bounces once off the edge of the screen -
function make_gumball()
	local obj=make_object(004, 60, 60, 1, 1, {} )
	
	return obj
end

-- Generic make function for obstacles --
function make_object(sprite_num, start_x, start_y, vel_x, vel_y, props )
	local obj={
		sprite=sprite_num,
		obj_x=start_x,
		obj_y=start_y,
		vel_x=vel_x,
		vel_y=vel_y,
		collide_upper_x=1,
		collide_upper_y=1,
		collide_lower_x=1,
		collide_lower_y=1,
		spin=1,
		distance=0,
		lifetime=0,
		update=function(self)
			-- Generic update function --
			self.obj_x+=self.vel_x
			self.obj_y+=self.vel_y
		end,
		draw=function(self)
			-- A generic draw function for debugging, I'll overwrite this in the --
			--  unique make functions for the different obstacles --
			spr( self.sprite, self.obj_x, self.obj_y )
		end,
		check_collide=function(self,obj)
			-- This will need to be override by the unique make functions --
			-- Since all of the obstacles have different shapes --
			--print(obj.collide_upper_x, 0, 10 )
			--print(obj.collide_upper_y, 40, 10 )
			--print(obj.collide_lower_x, 0, 20 )
			--print(obj.collide_lower_y, 40, 20 )
			
			--print(self.collide_upper_x, 0, 30 )
			--print(self.collide_upper_y, 40, 30 )
			--print(self.collide_lower_x, 0, 40 )
			--print(self.collide_lower_y, 40, 40 )
			
			if obj_overlap(self, obj) == true then
			
				sfx(-1, 1)
				sfx(2, -1, 4)
				player_hit=true
				hit_anim_state=1
			end
			
		end
	}
	
	local key,value
	for key,value in pairs(props) do
		obj[key]=value
	end
	
	return obj
end

-- Make function for powerups --
-- We can have this extend make_object()
function make_powerup()
	local obj={
	}
	
	return obj
end

-- Make function for simple particles --
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

function line_overlap(min1,max1,min2,max2)
    return max1>min2 and max2>min1
end

function obj_overlap(obj1, obj2)
    return line_overlap(obj1.collide_upper_x,obj1.collide_lower_x,obj2.collide_upper_x,obj2.collide_lower_x) and line_overlap(obj1.collide_upper_y,obj1.collide_lower_y,obj2.collide_upper_y,obj2.collide_lower_y)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000088800000000000000000000000000000000000000000000000000000000000
0000000000055000055500000000550000eeee0000eeee0000000000000000000888880000000000000800000000000000000000000000000000000000000000
007007000056650005668800005588500e77eee00e77eee0000ee0000000e0000222220008200000008880000000000000000000000000000000000000000000
00077000005885000568e78005687e850e7eeee00e7eeee000e7ee00000eee000088800088280000000800000080000000008000000000000000000000000000
00077000058e78500058ee800568ee850eeeeee00eeeeee000eeee000000e0000007000088287777000700000888770000007000000870000000000000000000
00700700058ee85000568850005588500eeeeee00eeeeee0000ee000000000000007000088280000000700000080000000000000000000000000000000000000
0000000000588500000555000000550000eeee0000eeee0000000000000000000007000008200000000000000000000000000000000000000000000000000000
00000000000550000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000550000555000000005500000000000000000000000000000000000000000000000000000000000000000000000000000009a00000000000000000
0000000000566500056655000055665000000000000000000000000000000000000000000000000000000000000000000aaaaa00000799a00000000000000000
00000000005665000566665005666665000aaa0000099000000aa0000008800000000000000cc000000000000080080009999900007799a0007799a000007900
0000000005666650005666500566666500cc0bb000099000000aa00000088000000bb000000cc00000c00c000008800000999000000799a00000000000000000
000000000566665000566650005566500ee00099000000000000000000000000000bb00000000000000cc0000000000000777000000009a00000000000000000
00000000005665000005550000005500000000000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000
00000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088800000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000088888000700c000000000004000004080000080000000000000000000000000000000000000000000000000
0000000000000000000000000000000000bbb00002222200e00e0000000000000444440888aa88000aaaaa000000000000000000000000000000000000000000
000000000000000000000000000000000bb0bb00008880000070000000400000447774408aaaa880099999000000000000000000000000000000000000000000
000000000000000000000000000000000b000b0000070000c0000e0004440000044444088aaaa800009990000000000000000000000000000000000000000000
000000000000000000000000000000000bb0bb000007000000e0c000004000004000004088aa8880007770000000000000000000000000000000000000000000
0000000000000000000000000000000000bbb0000007000007000000000000000000000800000800000700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000650000007770000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000505600088888000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e00e0000b00b0000505556007777700000b00000000900000080000000c000000b00000000000000000000000000000
0000000000000000000000000000000000ee000000bb0000055650000888880000bbb000000999000088800000ccc00000b00000000000000000000000000000
0000000000000000000000000000000000000000000000000060000000777000000b00000000900000080000000c000000b00000000000000000000000000000
__gff__
0000000000000000010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000002004021040240400000029040000002e04000000330002f02029040210502105024040270402c020310002a040260102a0302b0102604026020260100000000000000000000000000
4c120020107101371015710187101c7101d7101d7101c7101a710187101671015710147101171012710147101571016710197101a7101c7101d7101c7101a7101771014710117100e7100d7100e7101071012710
36100000004000360006600006003965027650366502f650246501b6501265035650326502b6501f65018650106501c650186500c650066500365001650006502060005600036000160009600016000000000000
