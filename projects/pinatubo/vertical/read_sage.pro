; Colarco
; This is the SAGE dataset transmogrified by Larry Thomason, see his
; notes here: 
;  /misc/prc10/SAGE/CMIP6\ Files/Release\ Notes\ on\ Version\ 6a.pdf
; The dataset is presented as a netcdf file prepared by Cynthia
; Randles:
;  /misc/prc10/SAGE/CMIP6\ Files/CCMI_Version_6d_1979-2014.nc

  pro read_sage, nymd, height, lat, $
                 ae1020, ae525, reff, sad, $
                 nae1020, nae525, nreff, nsad


; Manipulate the time to be sensible
  filetemplate = '/misc/prc10/SAGE/sage.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename = strtemplate(template,nymd,nhms)
  cdfid = ncdf_open(filename)
;  Get the dimensions
   id = ncdf_varid(cdfid,'height')
   ncdf_varget, cdfid, id, height
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'moy')
   ncdf_varget, cdfid, id, time

;  Get some needed values
   id = ncdf_varid(cdfid,'ae1020')
   ncdf_varget, cdfid, id, ae1020
   id = ncdf_varid(cdfid,'ae525')
   ncdf_varget, cdfid, id, ae525
   id = ncdf_varid(cdfid,'reff')
   ncdf_varget, cdfid, id, reff
   id = ncdf_varid(cdfid,'sad')
   ncdf_varget, cdfid, id, sad

   id = ncdf_varid(cdfid,'ae1020_numobs')
   ncdf_varget, cdfid, id, nae1020
   id = ncdf_varid(cdfid,'ae525_numobs')
   ncdf_varget, cdfid, id, nae525
   id = ncdf_varid(cdfid,'reff_numobs')
   ncdf_varget, cdfid, id, nreff
   id = ncdf_varid(cdfid,'sad_numobs')
   ncdf_varget, cdfid, id, nsad

  ncdf_close, cdfid


end
