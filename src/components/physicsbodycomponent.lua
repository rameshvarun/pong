PhysicsBodyComponent = class('PhysicsBodyComponent', Component)

function PhysicsBodyComponent:initialize(type)
  Component.initialize(self)
  self.type = type
end

function PhysicsBodyComponent:destroy() self.body:destroy() end

function PhysicsBodyComponent:start()
  self.body = love.physics.newBody(self:getEntity():getGameState():getPhysicsWorld(),
    self:getEntity():getPos().x, self:getEntity():getPos().y, self.type)
end

function PhysicsBodyComponent:newFixture(shape, density)
  return love.physics.newFixture(self.body, shape, density)
end

-- Get and set the position of the body.
function PhysicsBodyComponent:setBodyPosition(pos)
  self.body:setX(pos.x)
  self.body:setY(pos.y)
end
function PhysicsBodyComponent:getBodyPosition()
  return vector(self.body:getX(), self.body:getY())
end

function PhysicsBodyComponent:getBody() return self.body end
function PhysicsBodyComponent:getLinearVelocity()
  local x, y = self.body:getLinearVelocity()
  return vector(x, y)
end
function PhysicsBodyComponent:setLinearVelocity(vel)
  self.body:setLinearVelocity(vel.x, vel.y)
end

function PhysicsBodyComponent:debugDraw()
  Component.debugDraw(self)
  if self.body:isDestroyed() then return end

  Color.GREEN:use()
  for _, fixture in ipairs(self.body:getFixtureList()) do
    local shape = fixture:getShape()
    if shape:getType() == "circle" then
      love.graphics.circle('line', self.body:getX(), self.body:getY(), shape:getRadius(), 16)
    elseif shape:getType() == "polygon" then
      -- TODO: translate points by the body position.
      love.graphics.polygon('line', shape:getPoints())
    elseif shape:getType() == "edge" then
      -- TODO: translate points by the body position.
      love.graphics.line(shape:getPoints())
    else
      error("Unkown shape type: " .. shape:getType())
    end
  end
end
