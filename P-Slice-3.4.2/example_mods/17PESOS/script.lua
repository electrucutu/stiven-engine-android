function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') >0.001 then
        setProperty('health', health- 0.20);
    end
end
