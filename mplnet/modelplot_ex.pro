;  Bryon Baumstarck
;  7/16/2009

pro modelplot_ex, vVarFilename, vPlotFilename
	; Reads a file with '...ext-###nm...', and initializes variables
	read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, $
                       ssa, tau, backscat, mass, filetoread=vVarFilename
		
	; Reads a file with '...met...', and initializes variables
	read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                           surfp, pblh, h, hghte, relhum, t, delp, $
                           cloud, taucli, tauclw, filetoread=vPlotFilename

	n_indices=n_elements(hghte[*,0])
        dyArray = fltarr(n_indices-1, n_elements(time))
	for index=0, n_indices-2 do begin
		dyArray[index,*]=(hghte[index,*]-hghte[(index+1),*])/1000  ;Convert to km
	endfor
	
	extinction=reverse(extinction)	;Currently in the form of 1/km
	h=reverse(h/1000)		;Convert to km
	modTime=findgen(n_elements(time))*.25+92

	nameArray=strsplit(vPlotFilename, '.', /extract)

	; Plot format info
	contourLevels=[ -1, 0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, $
			0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.2, 0.3, $
			0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
	contourColors=[ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, $
			136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232]
	s_contourLabels=string(format='(f)', contourLevels)

	; To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/ex_model_output.ps', /color
	loadct, 39

	; To make the Model Extinction plot
	plot, modTime, extinction, xrange=[min(modTime),max(modTime)], yrange=[0,20], xstyle=1, ystyle=1, ticklen=-0.02, /nodata, $
		title='Model Output of Extinction; '+nameArray[2]+' '+strmid(nameArray[3], 4, 2)+'/'+strmid(nameArray[3], 0, 4), $
		xtitle='Percent time of day', ytitle='Altitude (km)', position=[0.075,0.1,0.8,0.925]

	dx = 0.25
	dy = reverse(dyArray)
	plotgrid, transpose(extinction), contourLevels, contourColors, modTime, transpose(h), dx, transpose(dy)
	
	
	makekey, 0.83, 0.1, 0.05, 0.825, 0.1, 0, colors=contourColors, labels=s_contourLabels, orientation=1
	
	; To create a string at an arbitrary location within the graph window
	xyouts, 0.83, 0.02, '(1/km)', /normal

	device, /close
end
