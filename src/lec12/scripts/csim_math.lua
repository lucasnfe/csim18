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

function csim_math.distance(v1, v2)
	return math.sqrt((v1.x-v2.x)^2 + (v1.y-v2.y)^2)
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
