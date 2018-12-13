local boid = {}
boid.__index=boid
Vector = require("lib/Vector")

--[[
Author:Bradley Bath
Description: Base module for boids
Date:13/12/18
]]
function boid.new()
  local newBoid=setmetatable({},boid)
  newBoid.position = Vector(200,200)
  newBoid.velocity = Vector(math.random(10,35),math.random(10,35))

  newBoid.acceleration = Vector(0,0)
  newBoid.maxForce = 10000;
  newBoid.maxSpeed = 20;
  newBoid.boids = {}
  newBoid.target=nil
  newBoid.id = math.random()*1e10;
  newBoid.color = {47/255,(53+math.random(10,50))/255,42/255}
  return newBoid
end


function boid:calc(boids)
  local alignRadius = 100;
  local seperateRadius=20;
  local cohesionRadius=100;
  local steeringAlign = Vector(0,0);
  local steeringSeperate = Vector(0,0);
  local steeringCohese = Vector(0,0);
  local steeringAvoid = Vector(0,0)

  local total = 0;
  for i = 1, #boids do
    local d = (self.position - boids[i].position).length
    if (boids[i]~=self and d < seperateRadius) then
      local diff = (self.position- boids[i].position);
      if (diff.length>0) then diff=diff/(d^2) end
      steeringSeperate=steeringSeperate+diff

      total=total+1;
    elseif (boids[i]~=self and d < cohesionRadius) then
      steeringCohese=steeringCohese+boids[i].position
    elseif (boids[i]~= self and d< alignRadius) then
      steeringAlign=steeringAlign+boids[i].velocity
    end
  end
  if (total > 0) then


    steeringAlign=steeringAlign/total
    steeringAlign.length=self.maxSpeed
    steeringAlign=steeringAlign-(self.velocity);
    if(steeringAlign.length > self.maxForce) then steeringAlign.length = self.maxForce end

    steeringCohese=steeringCohese/total
    steeringCohese=(steeringCohese-self.position)
    steeringCohese.length=self.maxSpeed
    steeringCohese=steeringCohese-self.velocity
    if(steeringCohese.length > self.maxForce) then steeringCohese.length = self.maxForce end

    steeringSeperate=steeringSeperate/total
    steeringSeperate.length=self.maxSpeed
    steeringSeperate=steeringSeperate-(self.velocity);
    if(steeringSeperate.length > self.maxForce) then steeringSeperate.length = self.maxForce end



  end

  return steeringAlign,steeringCohese,steeringSeperate;
end

function boid:update(dt)
  local alignment,cohesion,seperation = self:calc(self.boids);
  self.acceleration=self.acceleration + alignment
  self.acceleration=self.acceleration + cohesion.normalized
  self.acceleration=self.acceleration + seperation
  self.acceleration=self.acceleration + (self.target-self.position).normalized*self.maxSpeed


  self.position=self.position + self.velocity*dt;
  self.velocity=self.velocity+self.acceleration*dt
  if (self.velocity.length > self.maxSpeed) then
    self.velocity.length = self.maxSpeed
  end
  self.acceleration=self.acceleration * 0;
end

function boid:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("fill",self.position.x,self.position.y,10)
end

return boid