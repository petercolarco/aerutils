;  Bryon Baumstarck
;  7/15/2009

pro datestring, vNum, vString
	;Setup of the date range for graph title
	dateRange=strsplit(vNum, '-', /extract)
	if(dateRange[1] EQ dateRange[0]) then begin
		vString=strmid(dateRange[0], 4, 2)+'/'+strmid(dateRange[0], 6, 2)+'/'+strmid(dateRange[0], 0, 4)
	endif else begin
		startDate=strmid(dateRange[0], 4, 2)+'/'+strmid(dateRange[0], 6, 2)+'/'+strmid(dateRange[0], 0, 4)
		endDate=strmid(dateRange[1], 4, 2)+'/'+strmid(dateRange[1], 6, 2)+'/'+strmid(dateRange[1], 0, 4)
		vString=startDate+'-'+endDate
	endelse
end
