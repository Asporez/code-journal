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

