Player = class('Player', Entity)
Player:include(Stateful)

Player.static.SPEED = 200
Player.static.DASHING_SPEED = 800
Player.static.DASHING_LENGTH = 0.3
Player.static.RESPAWN_TIME = 4.0

Player.static.RADIUS = 20
Player.static.TEAM = { RED = 0, BLUE = 1 }

function Player:initialize(team, binding)
  Entity.initialize(self, 'player', 1, vector(0, 0))
  self.team, self.binding = team, binding
  self.action = self.binding:getButton('action')

  if self.team == Player.TEAM.RED then self.color = Color.RED else self.color = Color.BLUE end
end

function Player:setSpawnPosition(pos) self.spawnPos = pos end
function Player:reset()
  self.pos = self.spawnPos
  self:gotoState(nil)
end
function Player:isSpawned() return true end

function Player:draw()
  Entity.draw(self)
  self.color:use()
  love.graphics.circle('fill', self.pos.x, self.pos.y, Player.RADIUS, 16)
end

function Player:movement()
  return vector(self.binding:getAxis('right'):getValue() - self.binding:getAxis('left'):getValue(),
    self.binding:getAxis('down'):getValue() - self.binding:getAxis('up'):getValue())
end

function Player:clampPosition()
  self.pos.x = lume.clamp(self.pos.x, Player.RADIUS, Arena.SIZE.x - Player.RADIUS)
  self.pos.y = lume.clamp(self.pos.y, Player.RADIUS, Arena.SIZE.y - Player.RADIUS)
end

function Player:update(dt)
  Entity.update(self, dt)
  self.pos = self.pos + self:movement() * Player.SPEED * dt

  -- Collide with other players.
  for _, other in ipairs(self:getGameState():getEntitiesByTag('player')) do
    if other:isSpawned() then
      local delta = self.pos - other.pos
      local direction = delta:normalized()
      local center = (self.pos + other.pos)/2
      if delta:len() < Player.RADIUS*2 then
        self.pos = center + direction*Player.RADIUS
      end
    end
  end
  self:clampPosition()

  local puck = self:getGameState():getEntityByTag('puck')
  if (puck.pos - self.pos):len() < (Player.RADIUS + Puck.RADIUS)*0.5 then self:gotoState('Dead') end

  self.action:update()
  if self.action:pressed() then self:gotoState('Dashing', self:movement():normalized()) end
end

local DashingState = Player:addState('Dashing')
function DashingState:enteredState(direction)
  self.dashTime, self.dashDirection = 0, direction
  self.trail = self:getGameState():addEntity(Trail(self.pos, self.color))
end
function DashingState:update(dt)
  Entity.update(self, dt)

  self.trail.finish = self.pos
  self.pos = self.pos + self.dashDirection * Player.DASHING_SPEED * dt
  self:clampPosition()

  self.dashTime = self.dashTime + dt
  if self.dashTime > Player.DASHING_LENGTH then self:gotoState(nil) end

  local puck = self:getGameState():getEntityByTag('puck')
  if (puck.pos - self.pos):len() < Player.RADIUS + Puck.RADIUS then
    local velocity = puck:getLinearVelocity()
    local magnitude = velocity:len() + 200
    puck:setLinearVelocity(self.dashDirection * magnitude)
    self:gotoState(nil)
  end
end

local DeadState = Player:addState('Dead')
function DeadState:enteredState() self.deadTime = 0 end
function DeadState:isSpawned() return false end

function DeadState:draw() end
function DeadState:update(dt)
  self.deadTime = self.deadTime + dt
  if self.deadTime > Player.RESPAWN_TIME then self:reset() end
end
