-- 39_image_convolution.lua - 2D Image Kernel Filter & Convolution in Lua

local Image = {}
Image.__index = Image

function Image.new(w, h, initial)
    local self = setmetatable({}, Image)
    self.w = w
    self.h = h
    self.data = {}
    for i = 1, w * h do
        self.data[i] = (initial and initial[i]) or 0
    end
    return self
end

function Image:get(x, y)
    -- Clamp to border (x, y are 0-based)
    local cx = x
    if cx < 0 then
        cx = 0
    elseif cx >= self.w then
        cx = self.w - 1
    end

    local cy = y
    if cy < 0 then
        cy = 0
    elseif cy >= self.h then
        cy = self.h - 1
    end

    -- 1-based indexing for data: cy * self.w + cx + 1
    return self.data[cy * self.w + cx + 1]
end

function Image:set(x, y, val)
    if x >= 0 and x < self.w and y >= 0 and y < self.h then
        self.data[y * self.w + x + 1] = val
    end
end

local function clamp(val, minVal, maxVal)
    if val < minVal then return minVal end
    if val > maxVal then return maxVal end
    return val
end

function Image:convolve(k)
    local res = Image.new(self.w, self.h)

    for y = 0, self.h - 1 do
        for x = 0, self.w - 1 do
            local sum = 0
            local idx = 1
            for ky = -1, 1 do
                for kx = -1, 1 do
                    local pixel = self:get(x + kx, y + ky)
                    sum = sum + pixel * k.weights[idx]
                    idx = idx + 1
                end
            end

            local val = sum
            if k.divisor and k.divisor ~= 0 and k.divisor ~= 1 then
                val = math.floor(sum / k.divisor)
            end
            val = val + (k.bias or 0)
            res:set(x, y, clamp(val, 0, 255))
        end
    end

    return res
end

function Image:printMatrix(title)
    print(string.format("%s (%dx%d):", title, self.w, self.h))
    for y = 0, self.h - 1 do
        local parts = {}
        for x = 0, self.w - 1 do
            table.insert(parts, string.format("%4d", self:get(x, y)))
        end
        print(table.concat(parts, ""))
    end
end

function Image:printAscii(title)
    local ramp = { " ", ".", ":", "-", "*", "#" }
    print(string.format("%s (ASCII):", title))
    for y = 0, self.h - 1 do
        local parts = {}
        for x = 0, self.w - 1 do
            local val = self:get(x, y)
            -- Map [0, 255] to [1, 6]
            local shadeIdx = math.floor((val * 5) / 255) + 1
            table.insert(parts, ramp[shadeIdx] .. " ")
        end
        print(table.concat(parts, ""))
    end
end

local function main()
    print("=== 2D Image Convolution & Kernel Filter ===")

    -- 5x5 image with a central 3x3 bright square
    local srcData = {
          0,   0,   0,   0,   0,
          0, 200, 200, 200,   0,
          0, 200, 200, 200,   0,
          0, 200, 200, 200,   0,
          0,   0,   0,   0,   0
    }

    local img = Image.new(5, 5, srcData)
    img:printMatrix("Source Image")
    img:printAscii("Source Image")
    print("")

    -- Kernel 1: Laplacian Edge Detection
    local laplacian = {
        weights = { -1, -1, -1, -1, 8, -1, -1, -1, -1 },
        divisor = 1,
        bias = 0
    }

    local edges = img:convolve(laplacian)
    edges:printMatrix("Laplacian Edge Detection")
    edges:printAscii("Laplacian Edge Detection")
    print("")

    -- Kernel 2: Box Blur 3x3 (uniform 1/9)
    local blur = {
        weights = { 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        divisor = 9,
        bias = 0
    }

    local blurred = img:convolve(blur)
    blurred:printMatrix("Box Blur (3x3)")
    blurred:printAscii("Box Blur (3x3)")
    print("")

    print("Convolution pipeline completed successfully.")
end

main()
