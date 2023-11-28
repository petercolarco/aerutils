; Read an extracted model profile for a particular date
; z  = mid-layer height in km
; dz = layer thickness in km
; extinction variables in units of km-1
; RH is optional
  pro read_curtain_model, inpfile, lon, lat, time, $
                          z, dz, $
                          totext, duext, ssext, suext, bcext, ocext, $
                          RH=RH, $
                          totext2back=totext2back, duext2back=duext2back,$
                          ssext2back=ssext2back, suext2back=suext2back, $
                          bcext2back=bcext2back, ocext2back=ocext2back, $
                          duconc=duconc



;   Get the variables
    cdfid = ncdf_open(inpfile)
     id = ncdf_varid(cdfid,'longitude')
     ncdf_varget, cdfid, id, lon
     id = ncdf_varid(cdfid,'latitude')
     ncdf_varget, cdfid, id, lat
     id = ncdf_varid(cdfid,'time')
     ncdf_varget, cdfid, id, time

     id = ncdf_varid(cdfid,'ps')
     ncdf_varget, cdfid, id, ps
     id = ncdf_varid(cdfid,'du')
     ncdf_varget, cdfid, id, duconc
     id = ncdf_varid(cdfid,'totext')
     ncdf_varget, cdfid, id, totext
     id = ncdf_varid(cdfid,'duext')
     ncdf_varget, cdfid, id, duext
     id = ncdf_varid(cdfid,'bcext')
     ncdf_varget, cdfid, id, bcext
     id = ncdf_varid(cdfid,'ocext')
     ncdf_varget, cdfid, id, ocext
     id = ncdf_varid(cdfid,'suext')
     ncdf_varget, cdfid, id, suext
     id = ncdf_varid(cdfid,'ssext')
     ncdf_varget, cdfid, id, ssext
     id = ncdf_varid(cdfid,'totext2back')
     ncdf_varget, cdfid, id, totext2back
     id = ncdf_varid(cdfid,'duext2back')
     ncdf_varget, cdfid, id, duext2back
     id = ncdf_varid(cdfid,'bcext2back')
     ncdf_varget, cdfid, id, bcext2back
     id = ncdf_varid(cdfid,'ocext2back')
     ncdf_varget, cdfid, id, ocext2back
     id = ncdf_varid(cdfid,'suext2back')
     ncdf_varget, cdfid, id, suext2back
     id = ncdf_varid(cdfid,'ssext2back')
     ncdf_varget, cdfid, id, ssext2back
     id = ncdf_varid(cdfid,'phis')
     ncdf_varget, cdfid, id, hsurf
     id = ncdf_varid(cdfid,'delp')
     ncdf_varget, cdfid, id, delp
     id = ncdf_varid(cdfid,'AIRDENS')
     ncdf_varget, cdfid, id, airdens
     id = ncdf_varid(cdfid,'RH')
     ncdf_varget, cdfid, id, RH
    ncdf_close, cdfid

    datestr = strcompress(string(time[0],format='(i8)'),/rem)

    nt = n_elements(time)

;   Figure out the height arrays
    dz = transpose(delp/9.8/airdens)
    nz = 72
    z  = fltarr(nt, nz)
    z[*,nz-1] = hsurf + dz[*,nz-1]/2.
    for iz = nz-2,0,-1 do begin
     z[*,iz] = z[*,iz+1] + .5*(dz[*,iz+1]+dz[*,iz])
    endfor
    z = z / 1000. ; km
    dz = dz/1000. ; km


;   Transpose arrays to be (time,hght)
    totext = transpose(totext)
    duext = transpose(duext)
    bcext = transpose(bcext)
    ocext = transpose(ocext)
    suext = transpose(suext)
    ssext = transpose(ssext)
    totext2back = transpose(totext2back)
    duext2back = transpose(duext2back)
    bcext2back = transpose(bcext2back)
    ocext2back = transpose(ocext2back)
    suext2back = transpose(suext2back)
    ssext2back = transpose(ssext2back)
    rh = transpose(rh)
duconc = transpose(duconc)
;   Put time into hour of day
    time = (time - long(time))*24.

end
