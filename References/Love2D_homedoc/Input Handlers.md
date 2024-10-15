# Input Handlers
## Index

* [Terminal](#terminal)
* [Input Handling](#input-handling)


# Terminal

Creating a terminal in Love2D involves setting up a few components, including a defined area for input, handling command history, and implementing scrolling for the command history. Here’s a structured guide to help you write the code step by step.

### Step-by-Step Guide to Create a Terminal in Love2D

#### **1. Set Up Basic Love2D Structure**
Start by creating a basic Love2D project. Your `main.lua` file will contain all the necessary code.

#### **2. Define Terminal Variables**
At the beginning of your `main.lua`, define the variables needed for your terminal. These will include dimensions, command history, and input handling.

```lua
-- main.lua

function love.load()
    -- Terminal dimensions
    terminalWidth = 600
    terminalHeight = 400

    -- Command history
    commandHistory = {}
    commandHistoryIndex = 0

    -- Terminal input state
    currentInput = ""
    maxInputLength = 100 -- Maximum length of input
    inputOffsetX = 10 -- X offset for input
    inputOffsetY = terminalHeight - 30 -- Y position of input

    -- Font setup (optional, you can use default)
    terminalFont = love.graphics.newFont(12)
    love.graphics.setFont(terminalFont)
end
```

**Explanation**:
- `terminalWidth` and `terminalHeight` define the size of the terminal.
- `commandHistory` will store the executed commands.
- `currentInput` holds the current command being typed.
- `inputOffsetX` and `inputOffsetY` define where the input line appears in the terminal.
- You can set a custom font or use the default one for better visibility.

#### **3. Draw the Terminal**
In the `love.draw()` function, draw the terminal's background and the command history.

```lua
function love.draw()
    -- Draw terminal background
    love.graphics.setColor(0, 0, 0) -- Black background
    love.graphics.rectangle("fill", 0, 0, terminalWidth, terminalHeight)

    -- Draw command history
    love.graphics.setColor(1, 1, 1) -- White text
    local historyStartY = 10 -- Starting Y position for command history
    local lineHeight = terminalFont:getHeight()

    for i, command in ipairs(commandHistory) do
        love.graphics.print(command, inputOffsetX, historyStartY + (i - 1) * lineHeight)
    end

    -- Draw current input
    love.graphics.print("> " .. currentInput, inputOffsetX, inputOffsetY)
end
```

**Explanation**:
- This function sets the background color of the terminal and then prints out each command stored in `commandHistory`.
- The current input line is also displayed at the specified offsets.

#### **4. Handle Input**
To capture user input, use the `love.textinput` and `love.keypressed` functions. 

```lua
function love.textinput(text)
    if #currentInput < maxInputLength then
        currentInput = currentInput .. text
    end
end

function love.keypressed(key)
    if key == "return" then
        -- Store the current input in the command history
        if currentInput ~= "" then
            table.insert(commandHistory, currentInput)
            commandHistoryIndex = #commandHistory -- Update index to the last command
            currentInput = "" -- Clear input
        end
    elseif key == "up" then
        -- Scroll up in command history
        if commandHistoryIndex > 0 then
            commandHistoryIndex = commandHistoryIndex - 1
            currentInput = commandHistory[commandHistoryIndex + 1] or ""
        end
    elseif key == "down" then
        -- Scroll down in command history
        if commandHistoryIndex < #commandHistory then
            commandHistoryIndex = commandHistoryIndex + 1
            currentInput = commandHistory[commandHistoryIndex + 1] or ""
        else
            currentInput = "" -- Clear input if at the bottom
        end
    elseif key == "backspace" then
        -- Handle backspace for input
        currentInput = currentInput:sub(1, -2)
    end
end
```

**Explanation**:
- `love.textinput` captures each character typed, ensuring it doesn't exceed `maxInputLength`.
- In `love.keypressed`, pressing `return` adds the current input to the command history, while the `up` and `down` keys allow scrolling through the command history.
- The backspace key removes the last character from the input.

#### **5. Set Input Focus**
Ensure the terminal can receive text input. You can add a simple check to determine if the input is focused (e.g., by clicking on the terminal).

```lua
local inputFocused = true -- Track input focus state

function love.mousepressed(x, y, button)
    if button == 1 and x >= 0 and x <= terminalWidth and y >= 0 and y <= terminalHeight then
        inputFocused = true -- Focus the input when clicking inside the terminal
    else
        inputFocused = false -- Lose focus when clicking outside
    end
end
```

**Explanation**:
- This function checks if the mouse was clicked within the terminal's bounds. If so, it sets `inputFocused` to `true`, allowing input to be accepted.

#### **6. Modify Input Handling Based on Focus**
Update the `love.textinput` and `love.keypressed` functions to consider the `inputFocused` state.

```lua
function love.textinput(text)
    if inputFocused and #currentInput < maxInputLength then
        currentInput = currentInput .. text
    end
end

function love.keypressed(key)
    if inputFocused then
        -- Existing key handling code...
    end
end
```

### **Final Code Structure**
Here’s how your `main.lua` should look at the end:

```lua
-- main.lua

function love.load()
    terminalWidth = 600
    terminalHeight = 400
    commandHistory = {}
    commandHistoryIndex = 0
    currentInput = ""
    maxInputLength = 100
    inputOffsetX = 10
    inputOffsetY = terminalHeight - 30
    terminalFont = love.graphics.newFont(12)
    love.graphics.setFont(terminalFont)
    inputFocused = true
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, terminalWidth, terminalHeight)
    love.graphics.setColor(1, 1, 1)
    local historyStartY = 10
    local lineHeight = terminalFont:getHeight()
    for i, command in ipairs(commandHistory) do
        love.graphics.print(command, inputOffsetX, historyStartY + (i - 1) * lineHeight)
    end
    love.graphics.print("> " .. currentInput, inputOffsetX, inputOffsetY)
end

function love.textinput(text)
    if inputFocused and #currentInput < maxInputLength then
        currentInput = currentInput .. text
    end
end

function love.keypressed(key)
    if inputFocused then
        if key == "return" then
            if currentInput ~= "" then
                table.insert(commandHistory, currentInput)
                commandHistoryIndex = #commandHistory
                currentInput = ""
            end
        elseif key == "up" then
            if commandHistoryIndex > 0 then
                commandHistoryIndex = commandHistoryIndex - 1
                currentInput = commandHistory[commandHistoryIndex + 1] or ""
            end
        elseif key == "down" then
            if commandHistoryIndex < #commandHistory then
                commandHistoryIndex = commandHistoryIndex + 1
                currentInput = commandHistory[commandHistoryIndex + 1] or ""
            else
                currentInput = ""
            end
        elseif key == "backspace" then
            currentInput = currentInput:sub(1, -2)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and x >= 0 and x <= terminalWidth and y >= 0 and y <= terminalHeight then
        inputFocused = true
    else
        inputFocused = false
    end
end
```

### **Conclusion**
You now have a functional terminal in Love2D with defined dimensions, command history, and input handling. This setup provides a solid foundation for further enhancements, such as executing commands, adding syntax highlighting, or expanding command history with additional features.

Absolutely! Here’s a list of the technical terms for the types of functions and elements you’ll need to implement for your terminal in Love2D, along with brief descriptions. You can look up each term to understand how to implement them in your project:

### 1. **love.load**
- **Purpose**: This function initializes your variables and sets up the state of your game or application when it starts. 

### 2. **love.draw**
- **Purpose**: This function is responsible for rendering graphics on the screen. You’ll use it to draw the terminal's background, command history, and the current input.

### 3. **love.textinput**
- **Purpose**: This callback function handles text input from the keyboard. You’ll use it to capture characters as they are typed.

### 4. **love.keypressed**
- **Purpose**: This callback function is triggered when a key is pressed. It’s where you’ll handle actions like pressing the Enter key to submit commands, scrolling through command history with arrow keys, and handling backspace.

### 5. **love.mousepressed**
- **Purpose**: This function handles mouse input. You'll use it to determine if the terminal is clicked to focus on input.

### 6. **Table Manipulation Functions**
- **Purpose**: Functions for manipulating tables in Lua, such as `table.insert()`, which adds elements to your command history.

### 7. **Drawing Functions**
- **Purpose**: Functions like `love.graphics.rectangle()` and `love.graphics.print()` that handle drawing shapes and text on the screen.

### 8. **Input Handling Logic**
- **Purpose**: The logic to manage the state of the input (like whether it’s focused) and how to handle text input and command history navigation.

### 9. **Font Management**
- **Purpose**: Functions for creating and managing fonts in Love2D, which might include `love.graphics.newFont()` for custom fonts.

### 10. **Color Management**
- **Purpose**: Functions for setting colors in Love2D, such as `love.graphics.setColor()`, which controls the color of the text and background.

### 11. **Event Loop Management**
- **Purpose**: Understanding the general structure of how Love2D’s event loop works to ensure your functions respond to user input correctly.

By researching these terms, you’ll gain a better understanding of how to implement each part of your terminal. If you have any specific areas you’d like more guidance on, feel free to ask!

# Input Handling
[back to index](#index)

In Love2D, handling input from the keyboard, mouse, and other devices is essential for creating interactive applications. Below are the main ways Love2D registers input and how you can structure your input handling system in a separate module for better organization and encapsulation.

### Input Registration in Love2D

1. **Keyboard Input**
   - **`love.keypressed(key)`**: Called when a key is pressed. You can use this to handle actions like moving a character or toggling menus.
   - **`love.keyreleased(key)`**: Called when a key is released. This can be useful for stopping an action when the key is no longer pressed.
   - **`love.textinput(text)`**: Called when a character is typed. This is useful for capturing text input in fields, like in your terminal.

2. **Mouse Input**
   - **`love.mousepressed(x, y, button)`**: Called when a mouse button is pressed. You can check the mouse position and which button was pressed to interact with objects on the screen.
   - **`love.mousereleased(x, y, button)`**: Called when a mouse button is released.
   - **`love.mousemoved(x, y, dx, dy, istouch)`**: Called when the mouse is moved, useful for tracking cursor movement.

3. **Gamepad Input**
   - **`love.joystickpressed(joystick, button)`**: Called when a joystick button is pressed.
   - **`love.joystickreleased(joystick, button)`**: Called when a joystick button is released.
   - **`love.joystickaxis(joystick, axis, value)`**: Called when a joystick axis is moved.

### Structuring Input Handling in a Separate Module

To encapsulate input handling in its own module, you can create a new Lua file (e.g., `input.lua`) that will manage all input-related functions and state. Here’s how to do it step by step:

#### **1. Create the Input Module**

Create a file named `input.lua` in your project directory. In this file, you can define the necessary functions and state to manage input.

```lua
-- input.lua

local Input = {}

-- Table to store the state of keys
Input.keyState = {}

-- Initialize the input system
function Input.load()
    -- You can initialize any variables here if needed
end

-- Called when a key is pressed
function Input.keypressed(key)
    Input.keyState[key] = true -- Mark the key as pressed
end

-- Called when a key is released
function Input.keyreleased(key)
    Input.keyState[key] = false -- Mark the key as released
end

-- Called when text input occurs
function Input.textinput(text)
    -- Handle text input (e.g., for a terminal)
end

-- Function to check if a key is pressed
function Input.isKeyPressed(key)
    return Input.keyState[key] or false
end

return Input
```

**Explanation**:
- The `Input` table encapsulates all input-related functions and variables.
- The `keyState` table keeps track of which keys are currently pressed.
- The `load()` function can initialize variables or settings for input.
- The `keypressed()` and `keyreleased()` functions update the `keyState` table.
- The `isKeyPressed()` function allows other modules to easily check the state of specific keys.

#### **2. Load the Input Module in Main**

In your `main.lua`, load the input module and set up the necessary callbacks.

```lua
-- main.lua

local Input = require("input")

function love.load()
    Input.load() -- Initialize the input module
end

function love.keypressed(key)
    Input.keypressed(key) -- Pass keypresses to the input module
end

function love.keyreleased(key)
    Input.keyreleased(key) -- Pass key releases to the input module
end

function love.textinput(text)
    Input.textinput(text) -- Pass text input to the input module
end

function love.update(dt)
    -- You can check input states here if needed
    if Input.isKeyPressed("space") then
        -- Do something when the space key is pressed
    end
end
```

**Explanation**:
- The `input.lua` module is required at the top of `main.lua`.
- The `love.keypressed()`, `love.keyreleased()`, and `love.textinput()` functions are redirected to the input module to keep input handling centralized.
- The `love.update()` function can utilize the `isKeyPressed()` method to respond to key presses as needed.

#### **3. Expanding the Input Module**

You can expand the `input.lua` module to include mouse and gamepad input as well. Here’s an example of how you can do that:

```lua
-- input.lua

local Input = {}

Input.keyState = {}
Input.mouseState = {}
Input.mouseX, Input.mouseY = 0, 0

function Input.load()
    -- Initialize input states if necessary
end

function Input.keypressed(key)
    Input.keyState[key] = true
end

function Input.keyreleased(key)
    Input.keyState[key] = false
end

function Input.textinput(text)
    -- Handle text input
end

function Input.mousepressed(x, y, button)
    Input.mouseState[button] = true
end

function Input.mousereleased(x, y, button)
    Input.mouseState[button] = false
end

function Input.mousemoved(x, y, dx, dy, istouch)
    Input.mouseX, Input.mouseY = x, y
end

function Input.isKeyPressed(key)
    return Input.keyState[key] or false
end

function Input.isMousePressed(button)
    return Input.mouseState[button] or false
end

return Input
```

### **Conclusion**

By organizing your input handling in a separate module, you encapsulate all the input-related logic, making your main program cleaner and easier to manage. You can expand the module as needed to include additional features, such as handling mouse movement, storing mouse states, or even handling gamepad input.

If you have any questions or want to dive deeper into any specific part, feel free to ask!