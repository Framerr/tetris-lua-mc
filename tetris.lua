-- Tetris game in Lua

-- Define the Tetris class
Tetris = {}
Tetris.__index = Tetris

-- Tetris constructor
function Tetris.new()
    local self = setmetatable({}, Tetris)
    self.grid = {}
    self.width = 10
    self.height = 20
    self.currentPiece = nil
    self.gameOver = false
    return self
end

-- Initialize the Tetris grid
function Tetris:initGrid()
    for i = 1, self.height do
        self.grid[i] = {}
        for j = 1, self.width do
            self.grid[i][j] = 0
        end
    end
end

-- Check if a piece can be placed at the given position
function Tetris:canPlacePiece(piece, row, col)
    for i = 1, piece.size do
        for j = 1, piece.size do
            if piece.shape[i][j] ~= 0 then
                local newRow = row + i - 1
                local newCol = col + j - 1
                if newRow < 1 or newRow > self.height or newCol < 1 or newCol > self.width or self.grid[newRow][newCol] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

-- Place a piece at the given position
function Tetris:placePiece(piece, row, col)
    for i = 1, piece.size do
        for j = 1, piece.size do
            if piece.shape[i][j] ~= 0 then
                local newRow = row + i - 1
                local newCol = col + j - 1
                self.grid[newRow][newCol] = piece.shape[i][j]
            end
        end
    end
end

-- Remove completed rows from the grid
function Tetris:removeCompletedRows()
    local rowsToRemove = {}
    for i = 1, self.height do
        local rowComplete = true
        for j = 1, self.width do
            if self.grid[i][j] == 0 then
                rowComplete = false
                break
            end
        end
        if rowComplete then
            table.insert(rowsToRemove, i)
        end
    end
    for _, row in ipairs(rowsToRemove) do
        table.remove(self.grid, row)
        table.insert(self.grid, 1, {})
        for j = 1, self.width do
            self.grid[1][j] = 0
        end
    end
end

-- Check if the game is over
function Tetris:checkGameOver()
    for j = 1, self.width do
        if self.grid[1][j] ~= 0 then
            self.gameOver = true
            break
        end
    end
end

-- Tetris piece class
Piece = {}
Piece.__index = Piece

-- Tetris piece constructor
function Piece.new(shape)
    local self = setmetatable({}, Piece)
    self.shape = shape
    self.size = #shape
    return self
end

-- Tetris piece shapes
local shapes = {
    {
        {1, 1, 1, 1},
    },
    {
        {1, 1},
        {1, 1},
    },
    {
        {1, 1, 0},
        {0, 1, 1},
    },
    {
        {0, 1, 1},
        {1, 1, 0},
    },
    {
        {1, 1, 1},
        {0, 1, 0},
    },
    {
        {0, 1, 0},
        {1, 1, 1},
    },
    {
        {1, 0, 0},
        {1, 1, 1},
    },
}

-- Function to generate a random Tetris piece
function generateRandomPiece()
    local shape = shapes[math.random(#shapes)]
    return Piece.new(shape)
end

-- Function to print the Tetris grid
function printGrid(grid)
    for i = 1, #grid do
        local row = ""
        for j = 1, #grid[i] do
            row = row .. grid[i][j] .. " "
        end
        print(row)
    end
end

-- Function to play the Tetris game
function playTetris()
    local tetris = Tetris.new()
    tetris:initGrid()

    while not tetris.gameOver do
        local piece = generateRandomPiece()
        local row = 1
        local col = math.random(tetris.width - piece.size + 1)
        
        if tetris:canPlacePiece(piece, row, col) then
            tetris:placePiece(piece, row, col)
            tetris:removeCompletedRows()
            tetris:checkGameOver()
            printGrid(tetris.grid)
            print("---------------")
        end
    end

    print("Game Over!")
end

-- Start the Tetris game
playTetris()
