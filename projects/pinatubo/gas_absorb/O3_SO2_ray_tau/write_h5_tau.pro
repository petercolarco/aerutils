; Subroutine to write pre-calculated SO2 and O3 optical depth per DU

PRO  write_h5_tau,outfile, wavelength,layer_bot_pres,layer_mid_temp, $
                           tau_SO2, tau_O3,tau_Ray
; Create H5 file
fid = H5F_CREATE(outfile)
; Create Group
; Create date type and data space id
wavlen_datatype_id = H5T_IDL_CREATE(wavelength)
wavlen_dataspace_id = H5S_CREATE_SIMPLE(SIZE(wavelength,/DIMENSIONS))
pres_datatype_id = H5T_IDL_CREATE(layer_bot_pres)
pres_dataspace_id = H5S_CREATE_SIMPLE(SIZE(layer_bot_pres,/DIMENSIONS))
temp_datatype_id = H5T_IDL_CREATE(layer_mid_temp)
temp_dataspace_id = H5S_CREATE_SIMPLE(SIZE(layer_mid_temp,/DIMENSIONS))
tau_datatype_id = H5T_IDL_CREATE(tau_SO2)
tau_dataspace_id = H5S_CREATE_SIMPLE(SIZE(tau_SO2,/DIMENSIONS))
O3_datatype_id = H5T_IDL_CREATE(tau_O3)
O3_dataspace_id = H5S_CREATE_SIMPLE(SIZE(tau_O3,/DIMENSIONS))
Ray_datatype_id = H5T_IDL_CREATE(tau_Ray)
Ray_dataspace_id = H5S_CREATE_SIMPLE(SIZE(tau_Ray,/DIMENSIONS))

; Create data sets
wavlen_id = H5D_CREATE(fid,'Wavelength',wavlen_datatype_id,wavlen_dataspace_id)
pres_id = H5D_CREATE(fid,'Pressure_Layer_Bottom',pres_datatype_id,pres_dataspace_id)
temp_id = H5D_CREATE(fid,'Temperature_Layer_Center',temp_datatype_id,temp_dataspace_id)
tau_id = H5D_CREATE(fid,'Tau_1DU_SO2',tau_datatype_id,tau_dataspace_id)
O3_id = H5D_CREATE(fid,'Tau_1DU_O3',O3_datatype_id,O3_dataspace_id)
Ray_id = H5D_CREATE(fid,'Tau_Rayleigh',Ray_datatype_id,Ray_dataspace_id)

; Write to data sets
H5D_WRITE,wavlen_id,wavelength
H5D_WRITE,pres_id,layer_bot_pres
H5D_WRITE,temp_id,layer_mid_temp
H5D_WRITE,tau_id,tau_SO2
H5D_WRITE,O3_id,tau_O3
H5D_WRITE,Ray_id,tau_Ray

; Close interface
H5D_CLOSE,wavlen_id
H5D_CLOSE,pres_id
H5D_CLOSE,temp_id
H5D_CLOSE,tau_id
H5D_CLOSE,O3_id
H5D_CLOSE,Ray_id

H5S_CLOSE,wavlen_dataspace_id
H5S_CLOSE,pres_dataspace_id
H5S_CLOSE,temp_dataspace_id
H5S_CLOSE,tau_dataspace_id
H5S_CLOSE,O3_dataspace_id
H5S_CLOSE,Ray_dataspace_id

H5T_CLOSE,wavlen_datatype_id
H5T_CLOSE,pres_datatype_id
H5T_CLOSE,temp_datatype_id
H5T_CLOSE,tau_datatype_id
H5T_CLOSE,O3_datatype_id
H5T_CLOSE,Ray_datatype_id

H5F_CLOSE,fid

RETURN
END
