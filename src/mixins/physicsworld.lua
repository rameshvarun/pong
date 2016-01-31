local PhysicsWorld = {
  createPhysicsWorld = function(self, gravity, sleep)
    assert(vector.isvector(gravity), 'gravity is a vector')
    self.world = love.physics.newWorld(gravity.x, gravity.y, sleep)
  end,
  updatePhysicsWorld = function(self, dt) self.world:update(dt) end,
  -- Last case function to simply get the physics world object.
  getPhysicsWorld = function(self) return self.world end
}
return PhysicsWorld
