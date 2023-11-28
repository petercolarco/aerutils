;  Bryon Baumstarck
;  6/29/2009

; This file is for READING in a Level 1 MPLNET file that is in .cdf format.
; This file will take the FULL file name of the .cdf file and setup the 
; variable(s) to be graphed

pro level1_read, vFilename, nrb_out, time_out, range_out
	if(file_test(vFilename) EQ 1) then begin
		; Get the cdfid of the opened file
		cdfid = ncdf_open(vFilename)
		
		; Get Normalized Relative Backscatter variable
		id = ncdf_varid(cdfid, 'nrb')
		ncdf_varget, cdfid, id, nrb_out
		; Get Time variable
		id = ncdf_varid(cdfid, 'time')
		ncdf_varget, cdfid, id, time_out
		; Get Range variable
		id = ncdf_varid(cdfid, 'range')
		ncdf_varget, cdfid, id, range_out
		
		; Close the cdf file
		ncdf_close, cdfid
	endif
end
