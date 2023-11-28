;  Bryon Baumstarck
;  7/30/2009

; This procedure is for overlaying the plot of the layer heights with the plot 
;   for NRB.

pro layers_oplot, vFileL1, vFileL2, vRange
	index=0
	
	;Code to get the date range, and set the start/end dates
	sDate=strsplit(vRange, '-', /extract)
	currentDate=long(sDate[0])
	endDate=long(sDate[1])
	
	;Loop to get all filenames in the range of dates
	while(currentDate LE endDate) do begin
		setday, vFileL1, currentDate
		setday, vFileL2, currentDate
		
		;Loop for creating a dynamic array of strings that expands dynamically
		if(index EQ 0) then begin
			fileL1Array=vFileL1
			fileL2Array=vFileL2
		endif else begin
			fileL1Array=[fileL1Array, vFileL1]
			fileL2Array=[fileL2Array, vFileL2]
		endelse
		
		index=index+1
		tempDate = currentDate
		dayinc, string(tempDate, format='(I08)'), currentDate
	endwhile

	;Loop for creating expanding arrays of all relavant variables
	for index=0, n_elements(vFileL1Array)-1 do begin
		level1_read, vFileL1Array[index], nrb_out, time_out, range_out
		level15b_read, vFileL2Array[index], pbl_out, aerosol_out, cb_out, ct_out, beam_out, time_out, range_out
		if(index EQ 0) then begin
			nrbArray = transpose(nrb_out)
			pblArray = pbl_out
			aeroArray = aerosol_out
			cbArray = transpose(cb_out)
			ctArray = transpose(ct_out)
			beamArray = beam_out
			timeArray = time_out
		endif else begin
			nrbArray = [nrbArray, transpose(nrb_out)]
			pblArray = [pblArray, pbl_out]
			aeroArray = [aeroArray, aerosol_out]
			cbArray = [cbArray, transpose(cb_out)]
			ctArray = [ctArray, transpose(ct_out)]
			beamArray = [beamArray, beam_out]
			timeArray = [timeArray, time_out]
		endelse
	endfor
stop
	datestring, vRange, date
	
	;Setup the site name
	nameArray=strsplit(fileL1Array[0], '_', /extract)
	site=strupcase(nameArray[1])

	;Plot format info
	contourLevels=[ 0, 0.16, 0.33, 0.49, 0.67, 0.83, 1, 1.16, 1.33, 1.49, 1.67, 1.83, 2]
	contourColors=[ 0, 19, 38, 57, 76, 95, 114, 133, 152, 171, 190, 209, 228]
	s_contourLabels=string(format='(f)', contourLevels)

	; To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/layer_overplot_output.ps', /color
	loadct, 39

	;Explicitly set the infinite values to the Floating point value NaN
	a=where(finite(nrbArray) NE 1)
	if(max(a) NE -1) then nrb[a]=!values.f_nan

	; Create the plot with each type overlayed	
	contour, nrbArray, timeArray, /nodata, yrange=[0,20], title='Aerosol Layer Heights and Types: Overlay; '+site+' '+date, $
		xtitle='Percent time of day', ytitle='Altitude (km)', position=[0.1,0.1,0.8,0.95], levels=contourLevels, c_colors=contourColors

        dx = timeArray[1]-timeArray[0]
	dy = .075
	plotgrid, nrbArray, contourLevels, contourColors, timeArray, range, dx, dy
	
	makekey, 0.81, 0.1, 0.05, 0.85, 0.12, 0, colors=contourColors, labels=s_contourLabels, orientation=1
	
	oplot, timeArray, pblArray, psym=2, color=240
	oplot, timeArray, aeroArray, psym=2, color=144
	
	for it=0ULL, n_elements(timeArray)-1 do begin
		a=where(finite(cbArray[it,*]) EQ 1)
		b=where(finite(ctArray[it,*]) EQ 1)
		if((a[0] NE -1) && (b[0] NE -1)) then begin
			plots, timeArray[it], cbArray[it,a], psym=2, color=88
			plots, timeArray[it], ctArray[it,b], psym=6, color=88
		endif
	endfor
	
	for time=0ULL, n_elements(timeArray)-1 do begin
		if(finite(beamArray[time]) EQ 1) then begin
			beamArray[time] = 0
		endif
	endfor
	oplot, timeArray, beamArray, psym=4, color= 211
	
	; Create lables for each type
	xyouts, 0.80, 0.02, 'Clouds', /normal, alignment=1, color=88
	xyouts, 0.70, 0.02, 'Aerosols', /normal, alignment=1, color=144
	xyouts, 0.60, 0.02, 'PBL', /normal, alignment=1, color=244
	xyouts, 0.25, 0.02, 'Cloud Block', /normal, color=208
	
	device, /close
end
