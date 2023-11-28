;  Bryon Baumstarck
;  6/29/2009

;  This file is the MAIN file for creating graphs for a date range.
;  After entering in the full .cdf file you wish to graph, you will be prompted
;  for the date range to be graphed.

; Function to get the date range
function getRange
	dateRange=' '
	print, 'DATE MUST BE IN THIS FORMAT: yyyymmdd-yyyymmdd'
	read, dateRange, prompt='Enter the date range you want: '
	return, dateRange
end

pro rangeplot, vFilename, varName
	index=0
	
	;Code to get the date range, and set the start/end dates
	myRange=getRange()
	sDate=strsplit(myRange, '-', /extract)
	currentDate=long(sDate[0])
	endDate=long(sDate[1])
	
	;Loop to get all filenames in the range of dates
	while(currentDate LE endDate) do begin
		setday, vFilename, currentDate
		
		;Loop for creating a dynamic array of strings that expands dynamically
		if(index EQ 0) then begin
			fileArray=vFilename
		endif else fileArray=[fileArray, vFilename]
		
		index=index+1
		tempDate = currentDate
		dayinc, string(tempDate, format='(I08)'), currentDate
	endwhile
	
	;Case statement to call correct plotting procedure
	CASE varName OF
		"nrb": level1_lplot, fileArray, myRange
		"bs": level15a_bs_lplot, fileArray, myRange
		"ex": level15a_ex_lplot, fileArray, myRange
		"od": level15a_od_lplot, fileArray, myRange
		"layers": level15b_lplot, fileArray, myRange
		ELSE: print,'Please enter "nrb", "bs", "ex", "od", or "layers".'
	ENDCASE
end
