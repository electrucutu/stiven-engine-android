local prefs = {
    fakeForever = true
}

function onCreate()
    get = getProperty
    getFromClass = getPropertyFromClass
    getFromGroup = getPropertyFromGroup
    set = setProperty
    setFromClass = setPropertyFromClass
    setFromGroup = setPropertyFromGroup
end

function onCreatePost()
    makeLuaText("cornerMark", prefs.fakeForever and "TIVEN ENGINE 2.0.0" or "PSYCH ENGINE "..version, 0, 0, 5)
    setTextSize("cornerMark", 18)
    setTextBorder("cornerMark", 2, "000000")
    screenCenter("cornerMark", "X")
    setObjectCamera("cornerMark", "hud")
    set("cornerMark.antialiasing", getFromClass("ClientPrefs", "globalAntialiasing"))
    set("cornerMark.x", screenWidth - (get("cornerMark.width") + 5))
    addLuaText("cornerMark")
end