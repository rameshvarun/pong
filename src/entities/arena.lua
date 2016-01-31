Arena = class('Arena', Entity)
Arena.static.SIZE = vector(2000, 1200)
Arena.static.GOAL_SIZE = vector(150, 300)
Arena.static.MARGIN = 100
Arena.static.SCORE_FONT = love.graphics.newFont(80)

function Arena:initialize()
  Entity.initialize(self, 'arena', 0, vector(0, 0))
end

function Arena:start()
  self.bounds = self:addComponent(PhysicsBodyComponent('static'))

  self.bounds:newFixture(love.physics.newRectangleShape(self.pos.x + Arena.SIZE.x/2, self.pos.y + Arena.SIZE.y + Arena.MARGIN / 2,
    Arena.SIZE.x, Arena.MARGIN, 0), 1.0)
  self.bounds:newFixture(love.physics.newRectangleShape(self.pos.x + Arena.SIZE.x/2, self.pos.y - Arena.MARGIN / 2,
    Arena.SIZE.x, Arena.MARGIN, 0), 1.0)

  self.bounds:newFixture(love.physics.newRectangleShape(self.pos.x + Arena.SIZE.x + Arena.MARGIN / 2,
    self.pos.y + Arena.SIZE.y / 2, Arena.MARGIN, Arena.SIZE.y, 0), 1.0)
  self.bounds:newFixture(love.physics.newRectangleShape(self.pos.x - Arena.MARGIN / 2,
    self.pos.y + Arena.SIZE.y / 2, Arena.MARGIN, Arena.SIZE.y, 0), 1.0)
end

function Arena:getRedGoalBounds()
  return self.pos.x, self.pos.y + Arena.SIZE.y / 2 - Arena.GOAL_SIZE.y / 2,
    Arena.GOAL_SIZE.x, Arena.GOAL_SIZE.y
end

function Arena:getBlueGoalBounds()
  return self.pos.x + Arena.SIZE.x - Arena.GOAL_SIZE.x,
    self.pos.y + Arena.SIZE.y / 2 - Arena.GOAL_SIZE.y / 2, Arena.GOAL_SIZE.x, Arena.GOAL_SIZE.y
end

function Arena:draw()
  Entity.draw(self)

  -- Draw red team goal.
  love.graphics.setLineWidth(5)
  Color.RED:use()
  love.graphics.rectangle('line', self:getRedGoalBounds())

  -- Draw blue team goal.
  love.graphics.setLineWidth(5)
  Color.BLUE:use()
  love.graphics.rectangle('line', self:getBlueGoalBounds())

  -- Draw arena boundaries.
  love.graphics.setLineWidth(10)
  Color.WHITE:use()
  love.graphics.rectangle('line', self.pos.x, self.pos.y, Arena.SIZE.x, Arena.SIZE.y)

  love.graphics.setLineWidth(1)

  Color.RED:use()
  love.graphics.setFont(Arena.SCORE_FONT)
  love.graphics.printf(self:getGameState():getRedScore(), self.pos.x,
    self.pos.y + Arena.SIZE.y/2 - Arena.GOAL_SIZE.y/2 - 100, Arena.GOAL_SIZE.x, "center")

  Color.BLUE:use()
  love.graphics.setFont(Arena.SCORE_FONT)
  love.graphics.printf(self:getGameState():getBlueScore(), self.pos.x + Arena.SIZE.x - Arena.GOAL_SIZE.x,
    self.pos.y + Arena.SIZE.y/2 - Arena.GOAL_SIZE.y/2 - 100, Arena.GOAL_SIZE.x, "center")
end
