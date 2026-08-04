function onCreate()
    get = getProperty
    getFromClass = getPropertyFromClass
    getFromGroup = getPropertyFromGroup
    set = setProperty
    setFromClass = setPropertyFromClass
    setFromGroup = setPropertyFromGroup
end

function onCreatePost()
    local hideList = {"timeBarBG", "timeBar", "timeTxt"}
    for i = 1, #hideList do
        set(hideList[i]..".visible", false)
    end

    makeLuaText("centerMark", "- "..songName.." ["..string.upper(difficultyName).."] -", 0, 0, (downscroll and screenHeight - 40 or 10))
    setTextSize("centerMark", 24)
    setTextBorder("centerMark", 2, "000000")
    screenCenter("centerMark", "X")
    setObjectCamera("centerMark", "hud")
    set("centerMark.antialiasing", getFromClass("ClientPrefs", "globalAntialiasing"))
    addLuaText("centerMark")

    set("botplayTxt.borderSize", 2)
    set("botplayTxt.y", (downscroll and (get("centerMark.y") - 60) - 125 or (get("centerMark.y") + 60) + 125))
    set("botplayTxt.antialiasing", getFromClass("ClientPrefs", "globalAntialiasing"))
    set("botplayTxt.text", "[TU COMP JUEGA POR TI GAYmer]")
end