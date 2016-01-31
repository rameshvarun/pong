-- Global 'DEBUG' flag
DEBUG = true 

require 'utils' -- Load in utilities.

-- Install some libraries into the global namespace.
_ = require 'vendor.underscore' -- Underscore.lua, for misc. functional programming utils.
inspect = require 'vendor.inspect' -- Inspect.lua, for pretty printing tables.
class = require 'vendor.middleclass' -- Middleclass, for following OOP patterns.
vector = require 'vendor.vector' -- HUMP.vector, for the vector primitive.
lume = require 'vendor.lume' -- LUME, for misc utilties.
Timer = require 'vendor.timer' -- HUMP.timer, for delayed events and tweening.
Signal = require 'vendor.signal' -- HUMP.signal, for the observer pattern.
Stateful = require 'vendor.stateful' -- Stateful.lua, for state-based classes.
Camera  = require 'vendor.camera' -- HUMP.camera for a camera abstraction.
Actions = require 'vendor.actions' -- HUMP.timer.actions, for composable actions.
debugGraph = require 'vendor.debugGraph' -- debugGraph, for FPS and Memory graphs.
assets = require('vendor.cargo').init('assets') -- Cargo, for asset management.
HC = require 'vendor.hc' -- HardonCollider, for collision detection.

Color = require 'src.color' -- Load in the color library.
input = require 'src.input' -- Load in the input handling library.

require "src.component" -- Load in components.
require "src.entity" -- Load in entities.
require "src.gamestate" -- Load in game states.

function love.load(arg)
  -- Debug graphs.
  FPSGraph = debugGraph:new('fps', 0, 0)
  MemGraph = debugGraph:new('mem', 0, 40)

  GameState.switchTo(ControllerSelect(function(bindings)
    local players = {}
    local teams = { Player.TEAM.RED, Player.TEAM.BLUE }
    for i, binding in ipairs(bindings) do
      table.insert(players, Player(teams[(i % 2) + 1], binding))
    end
    GameState.switchTo(MatchState(players))
  end))
  --GameState.switchTo(MatchState({
  --  Player(Player.TEAM.RED, ControllerSelect.KEYBOARD_DEFAULT()),
  --  Player(Player.TEAM.RED, ControllerSelect.KEYBOARD_DEFAULT()),
  --  Player(Player.TEAM.BLUE, ControllerSelect.KEYBOARD_DEFAULT()),
  --  Player(Player.TEAM.BLUE, ControllerSelect.KEYBOARD_DEFAULT())
  --})) -- Switch to controller select menu.
end

function love.draw()
  -- If there is a current gamestate, draw it.
  if GameState.currentState ~= nil then
    GameState.currentState:draw()
  end

  if DEBUG then
    FPSGraph:draw()
    MemGraph:draw()
  end
end

function love.update(dt)
  if DEBUG then
    FPSGraph:update(dt)
    MemGraph:update(dt)
    require("vendor.lurker").update() -- Update lurker (live code-reloading).
    require("vendor.lovebird").update() -- Update lovebird (web console).
  end

  Timer.update(dt) -- Update global timer events.

  -- If there is a current GameState, update it.
  if GameState.currentState ~= nil then
    GameState.currentState:update(dt)
  end
end

-- Use 'f1' to toggle DEBUG
function love.keypressed(key, isrepeat)
  if key == 'f1' then DEBUG = not DEBUG
  elseif GameState.currentState ~= nil then
    GameState.currentState:keypressed(key, isrepeat)
  end
end
