;  Bryon Baumstarck
;  7/2/2009

; Procedure to decrease the day
pro daydec, vDate, vNewDate
	year = strmid(vDate, 0, 4)
	month = strmid(vDate, 4, 2)
	day = strmid(vDate, 6, 2)
	myJulDate = julday(month, day, year)
	myJulDate--
	caldat, myJulDate, newMonth, newDay, newYear
	vNewDate = string(newYear, format='(I04)')+string(newMonth, format='(I02)')+string(newDay, format='(I02)')
end
