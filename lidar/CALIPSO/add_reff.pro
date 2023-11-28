; Add variables to Virginie's modified version of lidar files

  files = ['dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc', $
           'dR_MERRA-AA-r2.calipso_355nm-v10.20090715.nc', $
           'dR_MERRA-AA-r2.calipso_1064nm-v10.20090715.nc']

; dir of Virginie's files
  vdir = 'output/data/virginie/'

; dir to put files
  odir = 'output/data/virginie_reff/'

  for ifile = 0,2 do begin

   spawn, '\cp -f '+vdir+files[ifile]+' '+odir

;  open file to update
   cdfid = ncdf_open(odir+files[ifile],/write)

;  Create space for new variables
   dimidt = ncdf_dimid(cdfid, 'nt')
   ncdf_diminq, cdfid, dimidt, name, nt
   dimidz = ncdf_dimid(cdfid, 'nz')
   ncdf_diminq, cdfid, dimidz, name, nz

   ncdf_control, cdfid, /redef
   idreff = ncdf_vardef(cdfid,'reff', [dimidz,dimidt])
   ncdf_attput, cdfid, idreff, 'long_name', 'effective radius'
   ncdf_attput, cdfid, idreff, 'units', 'm'
   idrefreal = ncdf_vardef(cdfid,'refreal', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefreal, 'long_name', 'real component of refractive index'
   ncdf_attput, cdfid, idrefreal, 'units', '1'
   idrefimag = ncdf_vardef(cdfid,'refimag', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefimag, 'long_name', 'imaginary component of refractive index'
   ncdf_attput, cdfid, idrefimag, 'units', '1'
   idvol = ncdf_vardef(cdfid,'vol', [dimidz,dimidt])
   ncdf_attput, cdfid, idvol, 'long_name', 'hydrated particle volume'
   ncdf_attput, cdfid, idvol, 'units', 'm3 m-3'
   idarea = ncdf_vardef(cdfid,'area', [dimidz,dimidt])
   ncdf_attput, cdfid, idarea, 'long_name', 'hydrated particle cross sectional area'
   ncdf_attput, cdfid, idarea, 'units', 'm2 m-3'
   idrefff = ncdf_vardef(cdfid,'reff_fine', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefff, 'long_name', 'effective radius (fine mode)'
   ncdf_attput, cdfid, idrefff, 'units', 'm'
   idrefrealf = ncdf_vardef(cdfid,'refreal_fine', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefrealf, 'long_name', 'real component of refractive index (fine mode)'
   ncdf_attput, cdfid, idrefrealf, 'units', '1'
   idrefimagf = ncdf_vardef(cdfid,'refimag_fine', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefimagf, 'long_name', 'imaginary component of refractive index (fine mode)'
   ncdf_attput, cdfid, idrefimagf, 'units', '1'
   idvolf = ncdf_vardef(cdfid,'vol_fine', [dimidz,dimidt])
   ncdf_attput, cdfid, idvolf, 'long_name', 'hydrated particle volume (fine mode)'
   ncdf_attput, cdfid, idvolf, 'units', 'm3 m-3'
   idareaf = ncdf_vardef(cdfid,'area_fine', [dimidz,dimidt])
   ncdf_attput, cdfid, idareaf, 'long_name', 'hydrated particle cross sectional area (fine mode)'
   ncdf_attput, cdfid, idareaf, 'units', 'm2 m-3'
   idreffc = ncdf_vardef(cdfid,'reff_coarse', [dimidz,dimidt])
   ncdf_attput, cdfid, idreffc, 'long_name', 'effective radius (coarse mode)'
   ncdf_attput, cdfid, idreffc, 'units', 'm'
   idrefrealc = ncdf_vardef(cdfid,'refreal_coarse', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefrealc, 'long_name', 'real component of refractive index (coarse mode)'
   ncdf_attput, cdfid, idrefrealc, 'units', '1'
   idrefimagc = ncdf_vardef(cdfid,'refimag_coarse', [dimidz,dimidt])
   ncdf_attput, cdfid, idrefimagc, 'long_name', 'imaginary component of refractive index (coarse mode)'
   ncdf_attput, cdfid, idrefimagc, 'units', '1'
   idvolc = ncdf_vardef(cdfid,'vol_coarse', [dimidz,dimidt])
   ncdf_attput, cdfid, idvolc, 'long_name', 'hydrated particle volume (coarse mode)'
   ncdf_attput, cdfid, idvolc, 'units', 'm3 m-3'
   idareac = ncdf_vardef(cdfid,'area_coarse', [dimidz,dimidt])
   ncdf_attput, cdfid, idareac, 'long_name', 'hydrated particle cross sectional area (coarse mode)'
   ncdf_attput, cdfid, idareac, 'units', 'm2 m-3'
   ncdf_control, cdfid, /endef

;  Now open file with variables and stuff in working file
   cdfid1 = ncdf_open(files[ifile])
    id1 = ncdf_varid(cdfid1,'reff')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idreff, var
    id1 = ncdf_varid(cdfid1,'refreal')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefreal, var
    id1 = ncdf_varid(cdfid1,'refimag')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefimag, var
    id1 = ncdf_varid(cdfid1,'vol')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idvol, var
    id1 = ncdf_varid(cdfid1,'area')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idarea, var
    id1 = ncdf_varid(cdfid1,'reff_fine')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefff, var
    id1 = ncdf_varid(cdfid1,'refreal_fine')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefrealf, var
    id1 = ncdf_varid(cdfid1,'refimag_fine')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefimagf, var
    id1 = ncdf_varid(cdfid1,'vol_fine')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idvolf, var
    id1 = ncdf_varid(cdfid1,'area_fine')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idareaf, var
    id1 = ncdf_varid(cdfid1,'reff_coarse')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idreffc, var
    id1 = ncdf_varid(cdfid1,'refreal_coarse')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefrealc, var
    id1 = ncdf_varid(cdfid1,'refimag_coarse')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idrefimagc, var
    id1 = ncdf_varid(cdfid1,'vol_coarse')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idvolc, var
    id1 = ncdf_varid(cdfid1,'area_coarse')
    ncdf_varget, cdfid1, id1, var
    ncdf_varput, cdfid, idareac, var
   ncdf_close, cdfid1
   ncdf_close, cdfid

endfor

end
