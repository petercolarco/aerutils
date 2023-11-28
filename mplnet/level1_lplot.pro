;  Bryon Baumstarck
;  6/29/2009

; This file is for PLOTTING a Level 1 MPLNET file that is in .cdf format.
; This file will graph the Normalized Relative Backscatter variable for a level1 file.
; The Filename is given to the level1_read, and the variables are inputs
; here.
; This plot is for a given Range

; Procedure to create a graph of the Normalized Relative Backscatter variable
pro level1_lplot, vFileArray, vRange
	;Loop for creating expanding arrays of all relavant variables
	for index=0, n_elements(vFileArray)-1 do begin
		level1_read, vFileArray[index], nrb, time, range
		if(index EQ 0) then begin
			nrbArray = transpose(nrb)
			timeArray = time
		endif else begin
			nrbArray = [nrbArray, transpose(nrb)]
			timeArray = [timeArray, time]
		endelse
	endfor
	
	datestring, vRange, date
	
	;Setup the site name
	nameArray=strsplit(vFileArray[0], '_', /extract)
	site=strupcase(nameArray[1])
	
	;Plot format info
	contourLevels=[ 0, 0.16, 0.33, 0.49, 0.67, 0.83, 1, 1.16, 1.33, 1.49, 1.67, 1.83, 2]
	contourColors=[ 0, 19, 38, 57, 76, 95, 114, 133, 152, 171, 190, 209, 228]
	s_contourLabels=string(format='(f)', contourLevels)
	
	;To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/nrb_range_output.ps', /color
	loadct, 39
	
	;Explicitly set the infinite values to the Floating point value NaN
	a=where(finite(nrbArray) NE 1)
	if(max(a) NE -1) then nrb[a]=!values.f_nan

	;To make the Normalized Relative Backscatter plot
	contour, nrbArray, xrange=[min(timeArray),max(timeArray)], yrange=[0,20], xstyle=1, ystyle=1, ticklen=-0.02, /nodata, $
		xtitle='Percent time of day', ytitle='Altitude (km)', title='Normalized Relative Backscatter; '+site+' '+date, $
		position=[0.075,0.1,0.8,0.925], levels=contourLevels, c_colors=contourColors
	
        dx = timeArray[1]-timeArray[0]
	dy = .075
	plotgrid, nrbArray, contourLevels, contourColors, timeArray, range, dx, dy
	
	makekey, 0.83, 0.1, 0.05, 0.825, 0.1, 0, colors=contourColors, labels=s_contourLabels, orientation=1
	
	;To create a string at an arbitrary location within the graph window
	xyouts, 0.83, 0.02, '(cnts/(uSec*uJ))*km^2)', /normal
	
	device, /close
end
