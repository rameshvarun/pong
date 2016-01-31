-- Basic color class, in order to cut down on verbosity.
local Color = class('Color')

function Color:initialize(r, g, b, a)
  assert(type(r) == "number", "'r' must be a number.")
  assert(type(g) == "number", "'g' must be a number.")
  assert(type(b) == "number", "'b' must be a number.")

  self.r = r
  self.g = g
  self.b = b
  self.a = a or 255
end

-- Unpack color.
function Color:rgb() return self.r, self.g, self.b end
function Color:rgba() return self.r, self.g, self.b, self.a end

-- Use this color globally.
function Color:use() love.graphics.setColor(self.r, self.g, self.b, self.a) end

Color.static.WHITE = Color(255, 255, 255, 255)
Color.static.BLACK = Color(0, 0, 0, 255)

Color.static.GREY = Color(128, 128, 128, 255)
Color.static.GRAY = Color.static.GREY

Color.static.TRANSPARENT = Color(0, 0, 0, 0)

Color.static.RED = Color(255, 0, 0, 255)
Color.static.GREEN = Color(0, 255, 0, 255)
Color.static.BLUE = Color(0, 0, 255, 255)

Color.static.YELLOW = Color(255, 255, 0, 255)
Color.static.PURPLE = Color(255, 0, 255, 255)
Color.static.CYAN = Color(0, 255, 255, 255)

return Color
