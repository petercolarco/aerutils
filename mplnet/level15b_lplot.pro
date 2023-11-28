;  Bryon Baumstarck
;  7/2/2009

; This file is for PLOTTING a Level 15b MPLNET file that is in .cdf format.
; This file will graph the layers of the aerosol heights for a level 15b File.
; The Filename is given to the level15b_read, and the variables are inputs
; here.
; This plot is for a given Range

; Procedure to create a graph of the Aerosol Layers
pro level15b_lplot, vFileArray, vRange
	;Loop for creating expanding arrays of all relavant variables
	for index=0, n_elements(vFileArray)-1 do begin
		level15b_read, vFileArray[index], pbl_out, aerosol_out, cb_out, ct_out, beam_out, time_out, range_out
		if(index EQ 0) then begin
			pblArray = pbl_out
			aeroArray = aerosol_out
			cbArray = transpose(cb_out)
			ctArray = transpose(ct_out)
			beamArray = beam_out
			timeArray = time_out
		endif else begin
			pblArray = [pblArray, pbl_out]
			aeroArray = [aeroArray, aerosol_out]
			cbArray = [cbArray, transpose(cb_out)]
			ctArray = [ctArray, transpose(ct_out)]
			beamArray = [beamArray, beam_out]
			timeArray = [timeArray, time_out]
		endelse
	endfor

	datestring, vRange, date
	
	;Setup the site name
	nameArray=strsplit(vFileArray[0], '_', /extract)
	site=strupcase(nameArray[1])

	; To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/layer_range_output.ps', /color
	loadct, 39

	; Create the plot with each type overlayed	
	plot, timeArray, pblArray, /nodata, xrange=[min(timeArray),max(timeArray)+0.001], yrange=[0,20], xstyle=1, ystyle=1, ticklen=-0.02, $
		title='Aerosol Layer Heights and Types; '+site+' '+date, xtitle='Percent time of day', ytitle='Altitude (km)', position=[0.075,0.1,0.8,0.925]
	
	oplot, timeArray, pblArray, psym=2, color=240
	oplot, timeArray, aeroArray, psym=2, color=144
	
	for it=0ULL, n_elements(timeArray)-1 do begin
		a=where(finite(cbArray[it,*]) EQ 1)
		b=where(finite(ctArray[it,*]) EQ 1)
		if((a[0] NE -1) && (b[0] NE -1)) then begin
			plots, noclip=0, timeArray[it], cbArray[it,a], psym=2, color=88
			plots, noclip=0, timeArray[it], ctArray[it,b], psym=6, color=88
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
