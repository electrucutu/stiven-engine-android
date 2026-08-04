utils = {
    ["centerOrigin"] = function(obj)
        set(obj..".origin.x", get(obj..".frameWidth") * 0.5)
        set(obj..".origin.y", get(obj..".frameHeight") * 0.5)
    end,

    ["updateHitbox"] = function(obj)
        set(obj..".width", math.abs(get(obj..".scale.x")) * get(obj..".frameWidth"))
        set(obj..".height", math.abs(get(obj..".scale.y")) * get(obj..".frameHeight"))

        set(obj..".offset.x", -0.5 * (get(obj..".width") - get(obj..".frameWidth")))
        set(obj..".offset.y", -0.5 * (get(obj..".height") - get(obj..".frameHeight")))

        utils.centerOrigin(obj)
    end
}

function onCreate()
    get = getProperty
    getFromClass = getPropertyFromClass
    getFromGroup = getPropertyFromGroup
    set = setProperty
    setFromClass = setPropertyFromClass
    setFromGroup = setPropertyFromGroup

    string.startsWith = stringStartsWith
    string.endsWith = stringEndsWith
    string.split = stringSplit

    if getFromClass("PlayState", "isPixelStage") then
        close()
    end
end

function onUpdatePost()
    for i = 0, get("notes.length") - 1 do
        if string.endsWith(getFromGroup("notes", i, "animation.name"), "holdend") then
            setFromGroup("notes", i, "scale.y", 0.75)
            utils.updateHitbox("notes.members["..i.."]")
            setFromGroup("notes", i, "offsetY", (downscroll and 17 or 0))
        end
    end
end