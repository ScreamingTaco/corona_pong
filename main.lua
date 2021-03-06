-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

math.randomseed(os.time())

composer.recycleOnSceneChange = true

-- load menu screen
composer.gotoScene( "scenes.menu" )
