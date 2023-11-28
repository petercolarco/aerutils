; Colarco, October 2008
; Note the model vertical grid orientation such that iz = max(iz) is the surface.
; (swap order of hyai and hybi because they were swapped in set_eta)
; Reads the GLAS-track extracted model profiles of the following variables:
;  surfp     = surface pressure [Pa]
;  pblh      = prognostic planetary boundary layer height [m]
;  phis      = surface geopotential height [m]
;  airdens   = air density [kg m-3]
;  h         = geopotential height at mid-layer [m]
;  hghte     = geopotential height at the top of the level [m]
;  relhum    = relative humidity at mid-layer [0 - 100%]
;  t         = temperature at mid-layer [K]
;  delp      = pressure thickness of level [Pa]
; The hybrid eta coordinate is the vertical coordinate of the model, 
; represented by the variables hyai and hybi
;  p_int = hyai + hybi*surfp
; and the difference between two interface pressures should be the delp
; of the level (to the limit of our bilinear interpolation)

  pro read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                           surfp, pblh, h, hghte, relhum, t, delp, $
                           cloud, taucli, tauclw, $
                           filetoread=filetoread

  filename = 'lidar_track.met.ncdf'
  if(keyword_set(filetoread)) then filename = filetoread

  hdfid = hdf_sd_start(filename)

     idx = hdf_sd_nametoindex(hdfid,'hyai')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, hyai

     idx = hdf_sd_nametoindex(hdfid,'hybi')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, hybi

     hyai = reverse(hyai)
     hybi = reverse(hybi)

     idx = hdf_sd_nametoindex(hdfid,'time')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, time

     idx = hdf_sd_nametoindex(hdfid,'date')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, date

     idx = hdf_sd_nametoindex(hdfid,'lon')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lon

     idx = hdf_sd_nametoindex(hdfid,'lat')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lat

     idx = hdf_sd_nametoindex(hdfid,'surfp')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, surfp

     idx = hdf_sd_nametoindex(hdfid,'pblh')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, pblh

     idx = hdf_sd_nametoindex(hdfid,'h')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, h

     idx = hdf_sd_nametoindex(hdfid,'hghte')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, hghte

     idx = hdf_sd_nametoindex(hdfid,'relhum')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, relhum

     idx = hdf_sd_nametoindex(hdfid,'t')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, t

     idx = hdf_sd_nametoindex(hdfid,'delp')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, delp

     idx = hdf_sd_nametoindex(hdfid,'cloud')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, cloud

     idx = hdf_sd_nametoindex(hdfid,'taucli')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, taucli

     idx = hdf_sd_nametoindex(hdfid,'tauclw')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, tauclw


  hdf_sd_end, hdfid

  nzp1 = n_elements(hyai)

; For the first profile, compute the pressure at the layer interfaces
; at compute the pressure thickness to verify consistency with delp
; interpolated
  psfc = surfp[0]
  pint = hyai + hybi*psfc
if(0) then begin
  print, 'Sample first profile information'
  print, 'Index', 'p edge [hPa]', 'delp* [hPa]', 'delp [hPa]', $
         '  t [K]', 'rhoa [kg m-3]', 'relhum [%]', 'h mid [m]', $
         'dz geo [m]', 'dz hyd [m]', $
         format='(a5,1x,a12,1x,a11,1x,a10,1x,a7,1x,a13,1x,a10,1x,a9,1x,a10,1x,a10)'
  print, '-----', '------------', '-----------', '----------', $
         '-------', '-------------', '----------', '---------', $
         '----------', '----------', $
         format='(a5,1x,a12,1x,a11,1x,a10,1x,a7,1x,a13,1x,a10,1x,a9,1x,a10,1x,a10)'

  delp_comp = fltarr(nzp1-1)
  for iz = 0, nzp1-2 do begin
   delp_comp[iz] = pint[iz]-pint[iz+1]
   if(iz eq 0) then begin
    dz_geopotential = hghte[0,0]-phis[0]
   endif else begin
    dz_geopotential = hghte[iz,0]-hghte[iz-1,0]
   endelse
   dz_hydrostatic  = delp[iz,0]/airdens[iz,0]/9.8
   print, iz, pint[iz], delp_comp[iz], delp[iz,0], t[iz,0], airdens[iz,0], $
          relhum[iz,0], h[iz,0], dz_geopotential, dz_hydrostatic, $
    format='(i5,1x,f12.1,1x,f11.1,1x,f10.1,1x,f7.1,1x,f13.6,1x,f10.1,1x,f9.1,'+ $
               '1x,f10.1,1x,f10.1)'
  endfor
endif



if(0) then begin
  print, 'Sample first profile information'
  print, 'Index', ' p edge [hPa]', ' delp [hPa]', $
         '   t [K]', ' relhum [%]', ' h mid [m]'
         format='(a5,2x,a12,1x,a10,1x,a7,1x,a10,1x,a9)'
  print, '-----', '------------', '----------', $
         '-------', '----------', '--------------'
         format='(a5,2x,a12,1x,a10,1x,a7,1x,a10,1x,a9)'

  delp_comp = fltarr(nzp1-1)
  for iz = 0, nzp1-2 do begin
   print, iz, pint[iz], delp[iz,0], t[iz,0], $
          relhum[iz,0]*100., h[iz,0], $
    format='(i5,1x,f12.1,1x,f10.1,1x,f7.1,1x,f10.3,1x,f9.1)'
  endfor
endif



end

