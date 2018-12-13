local player={}
player.__index=player
Vector = require("lib/Vector")
bullet = require("lib/bullet")
function player.new()
	local plr = setmetatable({},player)
	plr.position = Vector(400,300)
	plr.spawnedBullets={}
	return plr
end

function player:Draw()
	love.graphics.rectangle("fill",self.position.x,self.position.y,20,20)
	for i, bullet in pairs(self.spawnedBullets) do
		bullet:Draw()
	end

end

function player:Update(dt)
	
	--input checking
	if love.keyboard.isDown('a') then self.position.x = self.position.x - dt * 55 end
	if love.keyboard.isDown('d') then self.position.x = self.position.x + dt * 55 end
	if love.keyboard.isDown('w') then self.position.y = self.position.y - dt * 55 end
	if love.keyboard.isDown('s') then self.position.y = self.position.y + dt * 55 end
	
	--despawn bullets
	
	for i, bullet in pairs(self.spawnedBullets) do
		bullet:Update(dt)
		if bullet.position.x > 800 or bullet.position.y > 600 or bullet.position.y < 0 or bullet.position.x < 0 then
			table.remove(self.spawnedBullets,i)
		end
	end
end

function player:Shoot()
	local mVec = Vector(love.mouse.getX(),love.mouse.getY())
	local b = bullet.new(Vector(self.position.x,self.position.y))
	b.velocity = (Vector(love.mouse.getX(),love.mouse.getY())-self.position).normalized * 50;
	table.insert(self.spawnedBullets,b)
end

return player