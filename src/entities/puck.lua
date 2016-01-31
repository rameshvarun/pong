Puck = class('Puck', Entity)
Puck.static.RADIUS = 40

function Puck:initialize()
  Entity.initialize(self, 'puck', 2, vector(0, 0))
end

function Puck:start()
  self.body = self:includeComponent(PhysicsBodyComponent('dynamic'))
  self.fixture = self:newFixture(love.physics.newCircleShape(Puck.RADIUS), 1.0)
  self.fixture:setRestitution(1.0)
end

function Puck:draw()
  self.pos = self:getBodyPosition()
  Entity.draw(self)

  Color.WHITE:use()
  love.graphics.circle('fill', self.pos.x, self.pos.y, Puck.RADIUS, 16)
end
