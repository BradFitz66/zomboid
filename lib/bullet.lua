bullet={}
bullet.__index=bullet
Vector = require("lib/Vector")
function bullet.new(position)
	local projectile=setmetatable({},bullet)
	projectile.position=position
	projectile.velocity=Vector(0,0)
	
	return projectile
end

function bullet:Update(dt)
	print("!!")
	self.position=self.position+self.velocity*5*dt;
end

function bullet:Draw()
	love.graphics.rectangle("fill",self.position.x,self.position.y,5,5)
end


return bullet
