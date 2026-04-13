require "math"

-----------------------------------------------------
--
-- drawRotatedRectangle
-- 
-- Draws a rectangle that is rotated based on the
-- input angle
--
-----------------------------------------------------
function drawRotatedRectangle(mode, x, y, width, height, angle)
	-- We cannot rotate the rectangle directly, but we
	-- can move and rotate the coordinate system.
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	-- love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the middle
	love.graphics.pop()
end


-----------------------------------------------------
--
-- newSemiCircleShape
-- 
-- Draws a semicircle
--
-----------------------------------------------------
function newSemiCircleShape(xStartPoint, yStartPoint, radius, numDegrees)
	angleSegmentRad = numDegrees * 3.14 / 180

	xpoints = {
		x1 = startPoint,
		x2 = startPoint + radius * 1 / 7,
		x3 = startPoint + radius * 2 / 7,
		x4 = startPoint + radius * 3 / 7,
		x5 = startPoint + radius * 4 / 7,
		x6 = startPoint + radius * 5 / 7,
		x7 = startPoint + radius * 6 / 7,
		x8 = startPoint + 2 * radius
	}

	ypoints = {
		y1 = math.sin(),
		y2 = 0,
		y3 = 0,
		y4 = 0,
		y5 = 0,
		y6 = 0,
		y7 = 0,
		y8 = 0
	}

	for i = 1, 8 do
		
	end

	arcShape = love.physics.newPolygonShape(
		points.x1, points.y1,
		points.x2, points.y2,
		points.x3, points.y3,
		points.x4, points.y4,
		points.x5, points.y5,
		points.x6, points.y6,
		points.x7, points.y7,
		points.x8, points.y8
	)

	return arcShape

end


-----------------------------------------------------
--
-- Load_xy_from_txt
-- 
-- Loads x,y coordinates from a text file and outputs
-- the coordinates as a table of points
--
-----------------------------------------------------
function load_xy_from_txt(filepath)
    local points = {}
    for line in love.filesystem.lines(filepath) do
        line = line:match("^%s*(.-)%s*$")
        if line ~= "" then
            local x, y = line:match("([^,%s]+)[,%s]+([^,%s]+)")
            if x and y then
                table.insert(points, {x = tonumber(x), y = tonumber(y)})
            end
        end
    end
    return points
end


-----------------------------------------------------
--
-- Numeric Limit Test
-- 
-- Returns true if the value is within the bounds
--
-----------------------------------------------------
function numericLimitTest(value, lowerBound, upperBound)
	-- Tests that the value is between the specified bounds
	if value >= lowerBound and value <= upperBound then
		return true
	else
		return false
	end
end