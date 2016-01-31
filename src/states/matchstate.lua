MatchState = class('MatchState', GameState)
MatchState.static.SPAWN_DISTANCE = 200

-- Use the PhysicsWorld mixin.
local PhysicsWorld = require('src.mixins.physicsworld')
MatchState:include(PhysicsWorld)

function MatchState:initialize(players)
  GameState.initialize(self)

  self:createPhysicsWorld(vector(0, 0), false)
  self.arena = self:addEntity(Arena())
  self.puck = self:addEntity(Puck())

  self.players = players
  self.redTeam = _.select(players, function(player) return player.team == Player.TEAM.RED end)
  self.blueTeam = _.select(players, function(player) return player.team == Player.TEAM.BLUE end)
  for _, player in ipairs(self.players) do self:addEntity(player) end

  self.redscore = 0
  self.bluescore = 0

  self:setSpawnPositions()
  self:reset()

  self.cam:lookAt((Arena.SIZE / 2):unpack())
  local xzoom = love.graphics.getWidth() / (Arena.SIZE.x + 50)
  local yzoom = love.graphics.getHeight() / (Arena.SIZE.y + 50)
  self.cam:zoomTo(math.min(xzoom, yzoom))
end

function MatchState:setSpawnPositions()
  -- Set player spawn positions.
  local center = Arena.SIZE / 2
  if table.getn(self.redTeam) == 2 then
    self.redTeam[1]:setSpawnPosition(center + vector(MatchState.SPAWN_DISTANCE,
      -MatchState.SPAWN_DISTANCE))
    self.redTeam[2]:setSpawnPosition(center + vector(MatchState.SPAWN_DISTANCE,
      MatchState.SPAWN_DISTANCE))
  else
    self.redTeam[1]:setSpawnPosition(center + vector(MatchState.SPAWN_DISTANCE, 0))
  end
  if table.getn(self.blueTeam) == 2 then
    self.blueTeam[1]:setSpawnPosition(center + vector(-MatchState.SPAWN_DISTANCE,
      -MatchState.SPAWN_DISTANCE))
    self.blueTeam[2]:setSpawnPosition(center + vector(-MatchState.SPAWN_DISTANCE,
      MatchState.SPAWN_DISTANCE))
  else
    self.blueTeam[1]:setSpawnPosition(center + vector(-MatchState.SPAWN_DISTANCE, 0))
  end
end

function MatchState:getRedScore() return self.redscore end
function MatchState:getBlueScore() return self.bluescore end

function MatchState:update(dt)
  GameState.update(self, dt)
  self:updatePhysicsWorld(dt) -- Simulate physics.

  local x, y, width, height = self.arena:getRedGoalBounds()
  if self.puck.pos.x > x and self.puck.pos.y > y and self.puck.pos.x < x + width
    and self.puck.pos.y < y + height then
    self.redscore = self.redscore + 1
    self:reset()
  end

  local x, y, width, height = self.arena:getBlueGoalBounds()
  if self.puck.pos.x > x and self.puck.pos.y > y and self.puck.pos.x < x + width
    and self.puck.pos.y < y + height then
    self.bluescore = self.bluescore + 1
    self:reset()
  end
end

function MatchState:reset()
  self.puck:setBodyPosition(vector(Arena.SIZE.x / 2, Arena.SIZE.y / 2))
  self.puck:setLinearVelocity(vector(0, 0))
  _.invoke(self.players, 'reset')
  _.invoke(self:getEntitiesByTag('trail'), 'destroy')
end
