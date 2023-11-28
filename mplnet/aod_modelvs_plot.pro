;  Bryon Baumstarck
;  7/31/2009

; This procedure is for the purpose of comparing the Optical Depth
;   of the Model data versus the MPLNET data.
; This procedure MUST have the April 16, 2008 .cdf File because the date
;   information is hard-coded. More time is needed to get a dymanic date.
; This is in the context of the total column AOD.

pro aod_modelvs_plot, vFilename, vVarFilename
	level15a_read, vFilename, backscatter, extinction, optical_depth, time, range
	read_lidartrack, hyai, hybi, mtime, date, lon, lat, extinction, $
                       ssa, tau, backscat, mass, filetoread=vVarFilename
	
	aot=reverse(tau)
	modTime=findgen(5)*0.25+107  ;Hard-coded time to April 1st

	;Setup for the site and date title
	tempArray=strsplit(vFilename, '_', /extract)
	site=strupcase(tempArray[1])
	date=tempArray[3]

	; To "print" the device to a PostScript file
	set_plot, 'ps'
	device, /inches, xsize=14, ysize=5, file='~/aerutils/mplnet/output/plots/postscript/model_comp_output.ps', /color
	loadct, 39

	plot, time, optical_depth, /nodata, yrange=[0,.3], title='MPLNET vs. GEOS-5 Model; '+site+' '+date, $
	xtitle='Percent time of day', ytitle='Optical Depth', position=[0.1,0.1,0.8,0.95]
	
	;Plot the data
	oplot, modTime, aot[0,*], psym=2, color=144
	oplot, time, optical_depth[0,*], psym=1, color=240
	
	;To create a string at an arbitrary location within the graph window	
	xyouts, 0.11, 0.02, 'MPLNET', /normal, alignment=0, color=240
	xyouts, 0.78, 0.02, 'GEOS-5', /normal, alignment=1, color=144
	
	device, /close
end
