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

