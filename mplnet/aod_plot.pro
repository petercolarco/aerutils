;  Bryon Baumstarck
;  7/6/2009

; Procedure to plot the Aerosol Optical Depth at the surface
pro aod_plot, vFilename
	level15a_read, vFilename, backscatter, extinction, optical_depth, time, range, aod, atime
	
	;Plot format info
	contourLevels=[ -1, 0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, $
			0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.2, 0.3, $
			0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
	contourColors=[ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, $
			136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232]
	s_contourLabels=string(format='(f)', contourLevels)

	;Setup for the site and date title
	tempArray=strsplit(vFilename, '_', /extract)
	site=strupcase(tempArray[1])
	date=tempArray[3]
	
	;To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/od_comp_output.ps', /color
	loadct, 39
	
	plot, time, aod, /nodata, yrange=[0,0.3], title='AERONET vs. MPLNET; '+site+' '+date, $
	xtitle='Percent time of day', ytitle='Optical Depth', position=[0.1,0.1,0.9,0.95]
	
	;Plot the data
	oplot, time, optical_depth[0,*], psym=1, color=240
	oplot, atime, aod[0,*], psym=2, color=144
	
	;To create a string at an arbitrary location within the graph window	
	xyouts, 0.1, 0.02, 'gridded_optical_depth', /normal, alignment=0, color=240
	xyouts, 0.85, 0.02, 'optical_depth', /normal, alignment=1, color=144
	
	device, /close
end
