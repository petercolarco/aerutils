;  Bryon Baumstarck
;  6/29/2009

; This file is for READING in a Level 15a MPLNET file that is in .cdf format.
; This file will take the FULL file name of the .cdf file and setup the 
; variable(s) to be graphed

pro level15a_read, vFilename, backscatter_out, extinction_out, optical_depth_out, time_out, range_out, aod_out, atime_out
	if(file_test(vFilename) EQ 1) then begin
		; Get the cdfid of the opened file
		cdfid = ncdf_open(vFilename)
		
		; Get gridded Backscatter variable
		id = ncdf_varid(cdfid, 'grid_backscatter')
		ncdf_varget, cdfid, id, backscatter_out
		; Get gridded Extinction variable
		id = ncdf_varid(cdfid, 'grid_extinction')
		ncdf_varget, cdfid, id, extinction_out
		; Get gridded Optical Depth variable
		id = ncdf_varid(cdfid, 'grid_optical_depth')
		ncdf_varget, cdfid, id, optical_depth_out
		; Get gridded Time variable
		id = ncdf_varid(cdfid, 'grid_time')
		ncdf_varget, cdfid, id, time_out
		; Get Range variable
		id = ncdf_varid(cdfid, 'range')
		ncdf_varget, cdfid, id, range_out
		
		; Get Optical Depth for comparision with AERONET data
		id = ncdf_varid(cdfid, 'optical_depth')
		ncdf_varget, cdfid, id, aod_out
		id = ncdf_varid(cdfid, 'time')
		ncdf_varget, cdfid, id, atime_out
		
		; Close the cdf file
		ncdf_close, cdfid
	endif
end
