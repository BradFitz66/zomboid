local flock = require("lib/flock")
local Vector = require("lib/Vector")
local plr=require("lib/Player")
local player

local mainFlock
local mVec;
local wave=1;
local zombieSpawn=Vector(-50,300)
function love.load()
  if arg[#arg] == "-debug" then wave=3200 end
  --initialize player and start first wave
  player=plr.new()
  start(wave)
end



function love.draw()

  player:Draw()
  mainFlock:Draw()
  love.graphics.setColor(1,1,1)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Zombies left: "..#mainFlock.boids, 10, 30)
  love.graphics.print("Wave: "..wave, 10, 50)

end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    player:Shoot()
  end
end

function start(nextWave) -- function to start a wave to clean up code.
  if (nextWave < wave) then
    -- we only reset player position if nextWave is less than current wave meaning the player has been killed
    player.position = Vector(400,300)
  end
  wave=nextWave
  mainFlock=flock.new(wave,zombieSpawn)
  mainFlock.target=player.position
end

function clearTable(t)
  if (t) then -- we can get an error saying t is null if we try to loop through an empty table
    for i = 1, #t do
      local toRemove = t[i] -- we store the value at the current index so we don't get a null/nil error when deleting it.
      if (toRemove) then
        toRemove=nil
      end
    end
  end
end

function love.update(dt)
  mVec = Vector(love.mouse.getX(),love.mouse.getY())
  mainFlock:Update(dt)
  --ugly seperate loop to check for zombie 'collision' with player
  for i3 = 1, #mainFlock.boids do
    local boid = mainFlock.boids[i3] -- this is local to this for loops scope so it won't interfer with the boid variable in the other loop.
    if boid and player and (player.position-boid.position).length < 20 then
      clearTable(mainFlock.boids)
      clearTable(plr.spawnedBullets)
      start(1)
    end
  end

  if #mainFlock.boids > 0 then
    --remove boids when they 'collide' with a bullet (since they're circles, we can use distance to check if the bullet is inside the circle via the radius*2 to get diameter. Do we even need to get diameter??).
    for i = 1, #mainFlock.boids do
      local boid = mainFlock.boids[i]
      for i2 = 1, #player.spawnedBullets do
        local bullet=player.spawnedBullets[i2]
        if boid and bullet and (boid.position-bullet.position).length <= 20 then
          table.remove(player.spawnedBullets,i2)
          table.remove(mainFlock.boids,i)
        end
      end
    end
  elseif #mainFlock<=0 then
    start(wave+1)
  end
  player:Update(dt)
end