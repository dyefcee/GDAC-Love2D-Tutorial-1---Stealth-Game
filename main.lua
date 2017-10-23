local colors = require 'libs/colors'; -- colors library
local bump = require 'libs/bump'; -- collision engine

local player = {x = 720, y = 520, w = 80, h  = 80, id = 'player'}; -- player object
local walls = require 'libs/walls'; -- array of walls (try opening the file!)
local lasers = require 'libs/lasers'; -- array of lasers (also try opening the file!)

local lasersOn = false; -- used to set lasers on and off
local timer = 0; -- used to turn timers on and off

world = bump.newWorld(); -- initialize physics engine by creating world

function love.load()
	world:add(player, player.x, player.y, player.w, player.h); -- add player to physics world
	
	for i = 1,#walls do -- #walls = length of walls
		world:add(walls[i], walls[i].x, walls[i].y, walls[i].w, walls[i].h);
	end -- add every wall to world
end

function love.update(dt)
	-- movement, (0, 0) is in the top-left corner, y increase going down
	local dx, dy = 0,0; -- used for direction we'll move
	local spd = 3; -- how much we'll move by
	
	if love.keyboard.isDown('up') then dy = -spd; end -- if up, decrease y
	if love.keyboard.isDown('down') then dy = spd; end
	if love.keyboard.isDown('left') then dx = -spd; end
	if love.keyboard.isDown('right') then dx = spd; end
	
	player.x, player.y = world:move(player, player.x + dx, player.y + dy); -- ask physics engine to move player
																											

	-- timer
	timer = timer + dt; -- increase timer, dt is passed intp update()
	if timer > 3 then
		timer = 0; -- reset timer
		lasersOn = not lasersOn; -- lasers switch state
	end -- toggle lasers
	
	-- lasers
	if lasersOn then
		for i = 1, #lasers do
			local items, len = world:querySegment(lasers[i].x1,lasers[i].y1,lasers[i].x2,lasers[i].y2); -- check if anything is hitting the ith laser
			if len > 0 then
					world:update(player, 720, 520, player.w, player.h); -- change position of player's collider in physics engine
					player.x, player.y = 720, 520; -- change what we save the player's positions as
			end -- if the segment has hit anything, len = #items
		end -- every laser
	end
	
end

function love.draw()
	-- draw player
	love.graphics.setColor(colors.green); -- set drawing color
	love.graphics.rectangle('fill', player.x, player.y, player.w, player.h); -- draw a filled-in rectangle
	
	-- draw walls
	love.graphics.setColor(colors.gray); -- set drawing color
	for i = 1, #walls do
		love.graphics.rectangle('fill', walls[i].x, walls[i].y, walls[i].w, walls[i].h); -- draw a filled-in rectangle
	end -- do this for every wall in our wall array 
	
	-- draw lasers
	if lasersOn then
		love.graphics.setColor(colors.red); -- set drawing color
		for i = 1, #lasers do
			love.graphics.line(lasers[i].x1, lasers[i].y1, lasers[i].x2, lasers[i].y2); -- draw a line
		end -- do this for every laser in our laser array
	end -- only draw if lasers are on
end