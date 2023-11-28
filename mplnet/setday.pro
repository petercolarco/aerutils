;  Bryon Baumstarck
;  7/2/2009

; Procedure to set the Date field in filename
pro setday, vFile, vDate
	d=strsplit(vFile, '_', /extract)
	d[3]=string(vDate, format='(I8)')
	vFile=strjoin(d, '_')
end
