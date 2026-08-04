function onCreate()
    for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == '3rd Strum' then
			setPropertyFromGroup('unspawnNotes', i, 'extraData.thirdStrum', true, true)
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end
end