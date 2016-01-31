Trail = class('Trail', Entity)
Trail.static.EDGE_TIME = 0.1
Trail.static.LIFETIME = 3
Trail.static.FADE_TIME = 1

function Trail:initialize(pos, color)
  Entity.initialize(self, 'trail', 1, pos)
  self.color = color
  self.finish = pos
  self.edgeTime = 0
  self.time = 0
end

function Trail:start()
  self.body = self:includeComponent(PhysicsBodyComponent('static'))
end

function Trail:draw()
  Entity.draw(self)
  if self.time < Trail.LIFETIME - Trail.FADE_TIME then self.color:use()
  else
    local alpha = ((Trail.LIFETIME - self.time)/Trail.FADE_TIME)*255
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, alpha)
  end

  love.graphics.setLineWidth(5)
  love.graphics.line(self.pos.x, self.pos.y, self.finish.x, self.finish.y)
  love.graphics.setLineWidth(1)
end

function Trail:update(dt)
  Entity.update(self, dt)
  if self:getBody():isDestroyed() then return end

  self.edgeTime = self.edgeTime + dt
  self.time = self.time + dt
  if self.edgeTime > Trail.EDGE_TIME then
    local delta = self.finish - self.pos
    self:newFixture(love.physics.newEdgeShape(0, 0, delta.x, delta.y))
    self.edgeTime = 0
  end

  if self.time > Trail.LIFETIME then
    self:destroy()
  end
end
