;  Bryon Baumstarck
;  6/26/2009

; This file is for READING in a Level 15b MPLNET file that is in .cdf format.
; This file will take the FULL file name of the .cdf file and setup the 
; variable(s) to be graphed

pro level15b_read, vFilename, pbl_out, aerosol_out, cb_out, ct_out, beam_out, time_out, range_out
	if(file_test(vFilename) EQ 1) then begin
		; Get the cdfid of the opened file
		cdfid = ncdf_open(vFilename)
		
		; Get PBL Height variable
		id = ncdf_varid(cdfid, 'pbl_height')
		ncdf_varget, cdfid, id, pbl_out
		; Get Aerosol Height variable
		id = ncdf_varid(cdfid, 'aerosol_height')
		ncdf_varget, cdfid, id, aerosol_out
		; Get Cloud Base variable
		id = ncdf_varid(cdfid, 'cloud_base')
		ncdf_varget, cdfid, id, cb_out
		; Get Cloud Top variable
		id = ncdf_varid(cdfid, 'cloud_top')
		ncdf_varget, cdfid, id, ct_out
		; Get Beam Block variable
		id = ncdf_varid(cdfid, 'beam_block')
		ncdf_varget, cdfid, id, beam_out
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
