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

function csim_math.checkBoxCollision(a, b)
    if(a.max.x < b.min.x or b.max.x < a.min.x) then
        return false
    end

    if(a.max.y < b.min.y or b.max.y < a.min.y) then
        return false
    end

    return true
end

return csim_math
