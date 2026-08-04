local iconP2Scale = {1, 1}
local iconP1Scale = {1, 1}

function onCreate()
    get = getProperty
    getFromClass = getPropertyFromClass
    getFromGroup = getPropertyFromGroup
    set = setProperty
    setFromClass = setPropertyFromClass
    setFromGroup = setPropertyFromGroup
end

function math.framerateAdjust(input)
    return getFromClass("flixel.FlxG", "elapsed") * 60 * input
end

function math.lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function onUpdatePost(elapsed)
    iconP2Scale[1] = math.lerp(iconP2Scale[1], 1, math.framerateAdjust(0.5) * playbackRate)
    iconP2Scale[2] = math.lerp(iconP2Scale[2], 1, math.framerateAdjust(0.5) * playbackRate)

    iconP1Scale[1] = math.lerp(iconP1Scale[1], 1, math.framerateAdjust(0.5) * playbackRate)
    iconP1Scale[2] = math.lerp(iconP1Scale[2], 1, math.framerateAdjust(0.5) * playbackRate)

    updateIcons()
end

function onBeatHit(v)
    iconP2Scale[1] = iconP2Scale[1] + 0.3
    iconP2Scale[2] = iconP2Scale[2] + 0.3

    iconP1Scale[1] = iconP1Scale[1] + 0.3
    iconP1Scale[2] = iconP1Scale[2] + 0.3

    updateIcons()
end

function updateIcons()
    set("iconP2.scale.x", iconP2Scale[1])
    set("iconP2.scale.y", iconP2Scale[2])
    set("iconP2.height", math.abs(get("iconP2.scale.y")) * get("iconP2.frameHeight"))
    set("iconP2.offset.y", -0.5 * (get("iconP2.height") - get("iconP2.frameHeight")))

    set("iconP1.scale.x", iconP1Scale[1])
    set("iconP1.scale.y", iconP1Scale[2])
    set("iconP1.height", math.abs(get("iconP1.scale.y")) * get("iconP1.frameHeight"))
    set("iconP1.offset.y", -0.5 * (get("iconP1.height") - get("iconP1.frameHeight")))
end