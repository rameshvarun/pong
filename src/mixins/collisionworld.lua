local CollisionWorld = {
  createCollisionWorld = function(self, cell_size)
    self.collider = HC.new(cell_size) -- A collision detection 'world'.
  end
}

-- Delegate methods to the collider.
local METHODS_TO_DELEGATE = { 'rectangle', 'polygon', 'circle', 'point', 'remove', 'collisions', 'neighbors' }
for _, method in ipairs(METHODS_TO_DELEGATE) do
  CollisionWorld[method] = function(self, ...)
    self.collider[method](self.collider, ...)
  end
end

return CollisionWorld
