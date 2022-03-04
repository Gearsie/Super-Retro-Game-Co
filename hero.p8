pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
local player
local map_objects

function _init()
	map_objects={}
	player=make_knight(60,60)
	plat3=make_platform(68,100)
	plat2=make_platform(60,100)
	plat1=make_platform(52,100)
	add(map_objects,plat3)
	add(map_objects,plat2)
	add(map_objects,plat1)
end

function _update()
	-- Called 30 times a second --
    local obj
	for obj in all(map_objects) do
	    obj:update()
	end
	player:update()
	
end

function _draw()
	-- Called 30 times a second, this function writes from the draw buffer --
    cls()
    local obj
	for obj in all(map_objects) do
	    obj:draw()
	end
	player:draw()
	
end

function make_knight(x,y)
    return make_game_object(001,"knight",x,y,16,16,{
		draw=function(self)
			palt(0,false)
			palt(9,true)
			spr(self.sprite,self.x,self.y,2,2)
			palt(0,true)
			palt(9,false)
		end
	})
end

function make_platform(x,y)
    return make_game_object(064,"block",x,y,8,8,{})
end
	
function make_game_object(sprite,name,x,y,width,height,props)
	local obj={
		-- The top left sprite --
		sprite=sprite,
		-- Game object name --
		name=name,
		-- The top left (x,y)
		x=x,
		y=y,
		-- These are velocity values --
		x_v=0,
		y_v=0,
		-- The full width and height of the complete sprite i.e. 16x16 or 8x8 etc.
		width=width,
		height=height,
		update=function(self)
			-- flag 0 sprites are stationary --
			if(fget(self.sprite,0)==false) then
				-- The force of gravity is 30 px per second, 1 px per update() call --
				if(self.y_v<=0) then
					self.y_v+=1
				end
				
				-- The following is collision code --
				self.x=mid(0,(self.x+self.x_v),120)
				self.y=mid(0,(self.y+self.y_v),96)
				
				for obj in all(map_objects) do
					local hit_dir=self:check_for_collision(obj)
					if hit_dir=="top" and fget(obj.sprite,0) then
						self.y=obj.y+obj.height
					elseif hit_dir=="bottom" and fget(obj.sprite,0) then	
						self.y=obj.y-self.height
					elseif hit_dir=="left" and fget(obj.sprite,0) then	
						self.x=obj.x+obj.width
					elseif hit_dir=="right" and fget(obj.sprite,0) then	
						self.x=obj.x-self.width
					end
				end
				
			end
			
		end,
		draw=function(self)
			spr(self.sprite,self.x,self.y,1,1)
		end,
		check_for_hit=function(self,obj)
			-- Helper function for check_for_collision()
			return obj_overlap(self,obj) 
		end,
		check_for_collision=function(self,obj)
			-- Check to see if this obj has collided with something --
			local top_hitbox={
			    x=self.x+2,
				y=self.y,
				width=self.width-4,
				height=self.height/2
			}
			local bottom_hitbox={
			    x=self.x+2,
				y=self.y+self.height/2,
				width=self.width-4,
				height=self.height/2
			}
			local left_hitbox={
			    x=self.x,
				y=self.y+2,
				width=self.width/2,
				height=self.height-4
			}
			local right_hitbox={
			    x=self.x+self.width/2,
				y=self.y+2,
				width=self.width/2,
				height=self.height-4
			}
			if obj_overlap(top_hitbox, obj) then
				return "top"
			end
			if obj_overlap(bottom_hitbox, obj) then
				return "bottom"
			end
			if obj_overlap(left_hitbox, obj) then
				return "left"
			end
			if obj_overlap(right_hitbox, obj) then
				return "right"
			end
		end,
	}
	local key,value
	for key,value in pairs(props) do
		obj[key]=value
	end
	return obj
end

function line_overlap(min1,max1,min2,max2)
    return max1>min2 and max2>min1
end

function obj_overlap(obj1, obj2)
    return line_overlap(obj1.x,(obj1.x+obj1.width),obj2.x,(obj2.x+obj2.width)) and line_overlap(obj1.y,(obj1.y+obj1.height),obj2.y,(obj2.y+obj2.height))
end

__gfx__
00000000900090000009999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003b006d7d7d0999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000300d6d6d7d09b9999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000d6677709bb999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000906d0000000b3b999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700990d60111109b39999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000990d601c1c09b3b999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009906d01c1c0993b999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009990d0111109b3b999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000900000ddd000b39999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d6706776705555599999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000090d00d67170d069999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000011161d0d69999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003b00d666709059999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003b001100109999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000090090dd00dd0999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76777765000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76766565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76766565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76555565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000001020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000011120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
