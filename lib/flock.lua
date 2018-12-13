local flock ={}
flock.__index=flock
local boid = require("lib/boid")
local Vector = require("lib/Vector")

--[[
Author: Bradley Bath
Description: A module to easily store all boids
Date: 13/12/18
]]
function flock.new(amount, position)
  local flock = setmetatable({},flock)
  flock.boids = {} -- store boids inside a table
  flock.target=Vector(0,0)
  for i = 1, amount do
    -- create boids at position (+ a random value to spread them out) and add them to the boids table.
    local b = boid.new()
    local side = math.random(1,4) -- 1=left side, 2=right side, 3=top, 4=bottom
    if(side==1) then
      b.position=Vector(-25,300)+Vector(0,math.random(-300,300))
    elseif side==2 then
      b.position=Vector(825,300)+Vector(0,math.random(-300,300))
    elseif side==3 then
      b.position=Vector(400,-25)+Vector(math.random(-400,400),0)
    elseif side==4 then
      b.position=Vector(400,625)+Vector(math.random(-400,400),0)
    end
    b.target=flock.target
    b.boids=flock.boids
    table.insert(flock.boids,b)
  end
  return flock
end

function flock:Draw()
  -- draw all the boids
  for i = 1, #self.boids do
    self.boids[i]:draw()
  end
end

function flock:Update(dt)
  for i = 1, #self.boids do
    self.boids[i]:update(dt)
    self.boids[i].target=self.target
  end
end

return flock;