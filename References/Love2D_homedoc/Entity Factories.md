# Entity Factories

For your `graphicEntityFactory.lua` in Love2D, you can implement a factory pattern that generates small visual effects like pixel particles with varying shades of grey and transparency. These effects could serve as subtle visual indicators of movement or environmental effects, especially useful when the camera is focused on a player ship within a dark background. Here's how you could structure this pattern.

### Step 1: Define the Factory Pattern
We will create a Lua table (`graphicEntityFactory`) that includes a method for generating pixel entities with varying attributes such as position, size, color, and transparency. The entities will be stored in a table for later rendering.

**File: `src/graphicEntityFactory.lua`**
```lua
-- src/graphicEntityFactory.lua
local graphicEntityFactory = {}

-- Table to store all the pixel entities
local pixelEntities = {}

-- Function to create a new pixel entity
function graphicEntityFactory.createPixel(x, y, size, lifetime)
    -- Each pixel will have its own properties
    local pixel = {
        x = x or math.random(0, love.graphics.getWidth()),
        y = y or math.random(0, love.graphics.getHeight()),
        size = size or math.random(1, 3), -- Random pixel size
        color = { -- Random greyscale color with transparency
            math.random(50, 200) / 255, -- Random shade of grey
            math.random(50, 200) / 255, -- Same value for R, G, B
            math.random(50, 200) / 255,
            math.random(20, 150) / 255  -- Random transparency
        },
        lifetime = lifetime or 3, -- Lifetime in seconds
        timeAlive = 0 -- Tracks how long the pixel has been alive
    }

    -- Add the new pixel entity to the table
    table.insert(pixelEntities, pixel)
end

-- Function to update all pixel entities (decrease lifetime and remove expired)
function graphicEntityFactory.update(dt)
    for i = #pixelEntities, 1, -1 do
        local pixel = pixelEntities[i]
        pixel.timeAlive = pixel.timeAlive + dt

        -- Remove pixel if its lifetime is over
        if pixel.timeAlive > pixel.lifetime then
            table.remove(pixelEntities, i)
        end
    end
end

-- Function to render all pixel entities on the screen
function graphicEntityFactory.draw()
    for _, pixel in ipairs(pixelEntities) do
        love.graphics.setColor(pixel.color)
        love.graphics.rectangle("fill", pixel.x, pixel.y, pixel.size, pixel.size)
    end

    -- Reset color back to white for other drawings
    love.graphics.setColor(1, 1, 1, 1)
end

return graphicEntityFactory
```

### Step 2: Integrate with `main.lua`
Now, in your `main.lua`, you would use this factory to generate and update pixel effects.

**File: `main.lua`**
```lua
-- main.lua
local graphicEntityFactory = require("src/graphicEntityFactory")

function love.load()
    -- Example of creating initial pixel effects when the game starts
    for i = 1, 50 do
        graphicEntityFactory.createPixel(math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()), 2, math.random(1, 5))
    end
end

function love.update(dt)
    -- Update the pixel entities (handle their lifetimes)
    graphicEntityFactory.update(dt)
end

function love.draw()
    -- Draw the pixel effects on the screen
    graphicEntityFactory.draw()
end
```

### Step 3: Explanation
- **Pixel Creation**: The `createPixel` function generates a small rectangle at a random (or provided) position with a size between 1 and 3 pixels. The color is a random greyscale value, and the alpha (transparency) is randomly assigned for a subtle effect.
- **Pixel Lifetime**: Each pixel has a limited lifetime, and once it surpasses this time, it is removed from the entity table to prevent infinite accumulation.
- **Update & Draw**: The `update` function manages the pixels' lifetimes, and the `draw` function renders them as small rectangles.

### Step 4: Visual Movement Indicator
Later, you can enhance this by:
- Attaching pixels to the camera so they move relative to the player ship.
- Modifying pixel attributes (e.g., color or position) to respond to in-game events like movement or environmental changes.

Here are the methods used in the provided code:

### 1. **`graphicEntityFactory.createPixel(x, y, size, lifetime)`**
   - **Purpose**: Creates a new pixel entity with optional position (`x`, `y`), size, and lifetime.
   - **Calls used within the method**:
     - `math.random(a, b)`: Generates a random number between `a` and `b`.
     - `love.graphics.getWidth()`: Returns the width of the window.
     - `love.graphics.getHeight()`: Returns the height of the window.
     - `table.insert(table, value)`: Inserts a value into a table (`pixelEntities` in this case).

### 2. **`graphicEntityFactory.update(dt)`**
   - **Purpose**: Updates each pixel's lifetime and removes expired pixels.
   - **Calls used within the method**:
     - `#pixelEntities`: Gets the number of elements in the `pixelEntities` table.
     - `pixel.timeAlive = pixel.timeAlive + dt`: Increases the `timeAlive` property of each pixel by `dt` (delta time).
     - `table.remove(table, index)`: Removes the pixel entity from the table when its lifetime is exceeded.

### 3. **`graphicEntityFactory.draw()`**
   - **Purpose**: Renders all pixel entities on the screen.
   - **Calls used within the method**:
     - `love.graphics.setColor(color)`: Sets the color to draw the pixels.
     - `love.graphics.rectangle(mode, x, y, width, height)`: Draws a rectangle (in this case, the pixels are represented as tiny rectangles).
     - `love.graphics.setColor(1, 1, 1, 1)`: Resets the color back to white after drawing.

### External Methods Used in the Code:
- **`math.random(a, b)`**: Generates random numbers for various properties like position, size, color, and transparency.
- **`love.graphics.getWidth()` and `love.graphics.getHeight()`**: Get the dimensions of the window for random pixel positioning.
- **`table.insert(table, value)`**: Inserts a new pixel into the `pixelEntities` table.
- **`table.remove(table, index)`**: Removes expired pixel entities from the `pixelEntities` table.
- **`love.graphics.setColor(r, g, b, a)`**: Sets the drawing color, in this case for each pixel's greyscale shade and transparency.
- **`love.graphics.rectangle(mode, x, y, width, height)`**: Draws a filled rectangle (used here to represent the pixel).

This combination allows pixel creation, updating, and rendering on the screen with varying colors and transparencies.

# MINMAX AGAIN HERE!!?!?

Absolutely! AI in a game doesn't have to be limited to NPCs; it can also represent devices or systems, such as a fuel cell that manages energy or a radio signal emitter that influences gameplay. These AI systems can still utilize algorithms like Minimax with Alpha-Beta pruning to optimize their behaviors based on their interactions with the player or the game environment.

### **Example Scenario**
Let's create a simple hypothetical scenario in a Love2D game where two entities, **FuelCell** and **SignalEmitter**, interact with each other. The FuelCell can provide energy to the SignalEmitter, and the SignalEmitter emits signals that can affect the FuelCell's efficiency. 

We'll use the Minimax algorithm with Alpha-Beta pruning to determine the best action for each entity during their turn.

### **Hypothetical Entities**
1. **FuelCell**:
   - Generates energy.
   - Can be boosted or hindered by the SignalEmitter.

2. **SignalEmitter**:
   - Emits signals to influence the FuelCell's performance.
   - Can boost or disrupt energy generation.

### **Implementation in Love2D**
Below is a simplified example of how to implement a Minimax algorithm with Alpha-Beta pruning in Love2D. This example won't be a complete game, but it will illustrate the concepts.

```lua
-- main.lua

local function minimax(node, depth, isMaximizing, alpha, beta)
    if depth == 0 or node:isTerminal() then
        return node:evaluate() -- Evaluate the node
    end

    if isMaximizing then
        local maxEval = -math.huge
        for _, child in ipairs(node:getChildren()) do
            local eval = minimax(child, depth - 1, false, alpha, beta)
            maxEval = math.max(maxEval, eval)
            alpha = math.max(alpha, eval)
            if beta <= alpha then
                break -- Beta cut-off
            end
        end
        return maxEval
    else
        local minEval = math.huge
        for _, child in ipairs(node:getChildren()) do
            local eval = minimax(child, depth - 1, true, alpha, beta)
            minEval = math.min(minEval, eval)
            beta = math.min(beta, eval)
            if beta <= alpha then
                break -- Alpha cut-off
            end
        end
        return minEval
    end
end

-- Hypothetical game node class representing the game state
local GameNode = {}
GameNode.__index = GameNode

function GameNode:new(state)
    local obj = { state = state, children = {} }
    setmetatable(obj, self)
    return obj
end

function GameNode:isTerminal()
    -- Check if the game state is terminal (game over)
    return self.state.isGameOver
end

function GameNode:evaluate()
    -- Evaluate the state and return a score
    return self.state.score
end

function GameNode:getChildren()
    -- Generate child nodes based on possible actions
    return self.children
end

-- Create initial game state
local initialState = {
    isGameOver = false,
    score = 0 -- Placeholder score
}

-- Example function to simulate game state changes
local function simulateGame()
    local root = GameNode:new(initialState)

    -- Create child nodes with hypothetical game states
    for i = 1, 3 do
        local childState = {
            isGameOver = false,
            score = math.random(-10, 10) -- Random score for illustration
        }
        local childNode = GameNode:new(childState)
        table.insert(root.children, childNode)
    end

    -- Run Minimax with Alpha-Beta pruning
    local bestValue = minimax(root, 3, true, -math.huge, math.huge)
    print("Best Value:", bestValue)
end

function love.load()
    simulateGame()
end

function love.draw()
    love.graphics.print("Check the console for the Minimax result!", 10, 10)
end
```

### **Explanation of the Code**
1. **Minimax Function**: The `minimax` function takes the current node (game state), the depth of the tree, whether the maximizing player is to move, and the alpha-beta values. It evaluates the best possible score for the maximizing player while pruning branches that won’t provide a better outcome.

2. **GameNode Class**: Represents the game state. It has methods to check if the state is terminal, evaluate the score, and retrieve possible child nodes.

3. **simulateGame Function**: This function initializes the game state, creates child nodes with random scores, and runs the Minimax algorithm.

4. **love.load**: This Love2D function initializes the game by calling `simulateGame`.

5. **love.draw**: Displays a message to the screen indicating that the results can be found in the console.

### **Customization**
You can extend this example by:
- Defining specific actions for the **FuelCell** and **SignalEmitter**.
- Creating more complex game states and evaluation logic.
- Adding real game mechanics based on how these entities interact.

### **Conclusion**
Using Minimax with Alpha-Beta pruning allows your entities, whether NPCs or devices, to make informed decisions based on the current game state. This approach not only makes your AI more competitive but also provides a framework for various strategies depending on the game's design. Feel free to adapt this example to suit the specific needs of your project in Love2D!

We can achieve the turret aiming system by making each turret on a hardpoint rotate towards the mouse cursor, each with its own turn speed. To visualize where each turret is aiming, we’ll draw dots at varying distances (100 to 400 pixels) along the turret's current facing direction.

Here's how we can implement this:

### 1. **Updating `hardwareModule.lua` for Turrets**

We’ll add logic for turret modules to rotate towards the mouse cursor and allow a different turn speed for each turret based on the hardpoint.

```lua
local hardwareModule = {}
hardwareModule.__index = hardwareModule

-- Constructor for creating a new hardware module (turrets)
function hardwareModule.new(name, type, hardpointType, turnSpeed)
    local self = setmetatable({}, hardwareModule)

    self.name = name
    self.type = type  -- e.g., "weapon"
    self.hardpointType = hardpointType  -- "external" or "internal"
    self.turnSpeed = turnSpeed or 1  -- Different turn speeds for different hardpoints
    self.angle = 0  -- Current turret angle (in radians)
    self.attached = false  -- Is it attached to a hardpoint?

    return self
end

-- Function to attach the module to a specific hardpoint
function hardwareModule:attach(hardpoint)
    if hardpoint.type == self.hardpointType then
        self.attached = true
        self.hardpoint = hardpoint  -- Store reference to the hardpoint
        print(self.name .. " attached to hardpoint: " .. hardpoint.name)
    else
        print("Error: Cannot attach " .. self.name .. " to " .. hardpoint.name)
    end
end

-- Update function to rotate turret towards the mouse cursor
function hardwareModule:updateRotation(dt)
    if self.attached then
        local mouseX, mouseY = love.mouse.getPosition()
        local dx = mouseX - (self.hardpoint.x + self.hardpoint.shipX)
        local dy = mouseY - (self.hardpoint.y + self.hardpoint.shipY)

        -- Desired angle towards the mouse
        local targetAngle = math.atan2(dy, dx)

        -- Gradually rotate towards the target angle based on turn speed
        local deltaAngle = targetAngle - self.angle
        deltaAngle = (deltaAngle + math.pi) % (2 * math.pi) - math.pi  -- Normalize the angle
        self.angle = self.angle + math.min(math.abs(deltaAngle), self.turnSpeed * dt) * (deltaAngle < 0 and -1 or 1)
    end
end

-- Draw where the turret is pointing (dots between 100 to 400 pixels)
function hardwareModule:drawAim()
    if self.attached then
        local baseX = self.hardpoint.x + self.hardpoint.shipX
        local baseY = self.hardpoint.y + self.hardpoint.shipY

        for dist = 100, 400, 100 do
            local dotX = baseX + math.cos(self.angle) * dist
            local dotY = baseY + math.sin(self.angle) * dist
            love.graphics.circle("fill", dotX, dotY, 5)
        end
    end
end

return hardwareModule
```

### 2. **Modifying `playerShip.lua` to Pass Ship Position**

We need to ensure each hardpoint knows its ship’s position, so we pass `shipX` and `shipY` when attaching modules.

```lua
local playerShip = {}
playerShip.__index = playerShip

function playerShip.new()
    local self = setmetatable({}, playerShip)
    
    -- Basic ship properties
    self.x = 100
    self.y = 100
    self.width = 128
    self.height = 256
    self.angle = 0
    
    -- External hardpoints on the ship
    self.externalHardpoints = {
        { name = "Front Left Hardpoint", x = -50, y = -120, type = "external" },
        { name = "Front Right Hardpoint", x = 50, y = -120, type = "external" },
        { name = "Rear Left Hardpoint", x = -50, y = 120, type = "external" },
        { name = "Rear Right Hardpoint", x = 50, y = 120, type = "external" }
    }

    -- Modules attached to the ship
    self.modules = {}

    return self
end

-- Attach a hardware module to a specific hardpoint
function playerShip:attachModule(moduleName, moduleType, hardpointIndex, turnSpeed)
    local module = hardwareModule.new(moduleName, moduleType, "external", turnSpeed)
    local hardpoint = self.externalHardpoints[hardpointIndex]
    hardpoint.shipX = self.x + self.width / 2  -- Pass ship's position
    hardpoint.shipY = self.y + self.height / 2
    module:attach(hardpoint)
    table.insert(self.modules, module)
end

-- Update the ship and its modules
function playerShip:update(dt)
    for _, module in ipairs(self.modules) do
        module:updateRotation(dt)
    end
end

-- Draw the ship and its modules
function playerShip:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Draw each module’s aim
    for _, module in ipairs(self.modules) do
        module:drawAim()
    end
end

return playerShip
```

### 3. **Example Usage in `main.lua`**

Finally, we integrate everything in `main.lua`, adding different turn speeds for each turret and drawing the ship and its modules.

```lua
local playerShip = require('src/playerShip')

function love.load()
    -- Create player ship
    player = playerShip.new()

    -- Attach turrets with different turn speeds
    player:attachModule("Front Laser", "weapon", 1, 0.5)  -- Slow turning front left
    player:attachModule("Right Blaster", "weapon", 2, 1)  -- Faster front right
    player:attachModule("Rear Cannon", "weapon", 3, 0.7)  -- Moderate rear left
    player:attachModule("Rear Laser", "weapon", 4, 0.3)  -- Very slow rear right
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end
```

### Summary of Key Elements:
1. **Turret Rotation**: Each turret rotates towards the mouse cursor based on its turn speed, with slower speeds for certain hardpoints as requested.
2. **Aim Visualization**: Dots are drawn at 100, 200, 300, and 400 pixels away from the ship in the direction each turret is pointing, visualizing their aim.
3. **Slow Turret Turn Speed**: Each turret’s `turnSpeed` can be adjusted to suit your preference, allowing for slower rotation for easier visualization.

This setup gives you full control over turret behavior and ensures the aim is clearly visible even at different speeds.

