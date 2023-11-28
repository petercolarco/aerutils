;  Bryon Baumstarck
;  6/29/2009

; This file is for PLOTTING a Level 15a MPLNET file that is in .cdf format.
; This file will graph the Extinction variable for a level15a file.
; The Filename is given to the level15a_Read, and the variables are inputs
; here.
; This plot is for a given Range

; Procedure to create a graph of the Gridded Extinction variable
pro level15a_ex_lplot, vFileArray, vRange
	;Loop for creating expanding arrays of all relavant variables
	for index=0, n_elements(vFileArray)-1 do begin
		level15a_read, vFileArray[index], bs, extinction, od, time, range
		if(index EQ 0) then begin
			exArray = transpose(extinction)
			timeArray = time
		endif else begin
			exArray = [exArray, transpose(extinction)]
			timeArray = [timeArray, time]
		endelse
	endfor

	datestring, vRange, date
	
	;Setup the site name
	nameArray=strsplit(vFileArray[0], '_', /extract)
	site=strupcase(nameArray[1])

	; Plot format info
	contourLevels=[ -1, 0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, $
			0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.2, 0.3, $
			0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
	contourColors=[ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, $
			136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232]
	s_contourLabels=string(format='(f)', contourLevels)
	
	; To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/ex_range_output.ps', /color
	loadct, 39

	; To make the plot
	contour, exArray, xrange=[min(timeArray),max(timeArray)], yrange=[0,20], xstyle=1, ystyle=1, ticklen=-0.02, /nodata, $
		xtitle='Percent time of day', ytitle='Altitude (km)', title='Aerosol Extinction; '+site+' '+date, $
		position=[0.075,0.1,0.8,0.925], levels=contourLevels, c_colors=contourColors
		
        dx = timeArray[1]-timeArray[0]
	dy = .075
	plotgrid, exArray, contourLevels, contourColors, timeArray, range, dx, dy
	
	makekey, 0.83, 0.1, 0.05, 0.825, 0.1, 0, colors=contourColors, labels=s_contourLabels, orientation=1

	; To create a string at an arbitrary location within the graph window
	xyouts, 0.83, 0.02, '(1/km)', /normal
	
	device, /close
end
