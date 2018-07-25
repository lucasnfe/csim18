local csim_math = {}

function csim_math.clamp(value, min, max)
    if value < min then
        value = min
    end

    if value > max then
        value = max
    end

    return value
end

function csim_math.distance(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

return csim_math
