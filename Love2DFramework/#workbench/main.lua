local love = require( 'love' )

local program = {
    state = {
        intro = true,
        menu = false,
    }
}

local function enableMenu()
    program.state[ 'intro' ] = false
    program.state[ 'menu' ] = true
end

local function isIntro()
    return program.state[ 'intro' ]
end

local function isMenu()
    return program.state[ 'menu' ]
end

function love.load()
    
end

function love.update(dt)
    
end

function love.draw()
    
end