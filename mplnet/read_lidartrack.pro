; Colarco, October 2008
; Note the model vertical grid orientation such that iz = max(iz) is the surface.
; (swap order of hyai and hybi because they were swapped in set_eta)
; GLAS-track extracted profiles of the following variables:
;  mmr   = mass mixing ratio [kg species/kg air]
;  ssa   = single-scatter albedo
;  tau   = extinction optical thickness of layer
;  backscat = backscattering of layer
; Read the ancillary met data (read_glastrack_met.pro) to get
; atmospheric state variables.
; To go from mmr => concentration:
  pro read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, $
                       ssa, tau, backscat, mass, $
                       filetoread=filetoread

  filename = 'lidar_track.ncdf'
  if(keyword_set(filetoread)) then filename = filetoread

;  concentration = mmr * airdens
; To get the extinction, divide tau by the layer thickness

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

     idx = hdf_sd_nametoindex(hdfid,'extinction')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, extinction

     idx = hdf_sd_nametoindex(hdfid,'ssa')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, ssa

     idx = hdf_sd_nametoindex(hdfid,'backscat')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, backscat

     idx = hdf_sd_nametoindex(hdfid,'tau')
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, tau

     mass = extinction
     mass[*] = -9999.
     idx = hdf_sd_nametoindex(hdfid,'mass')
     if(idx ne -1) then begin
      id  = hdf_sd_select(hdfid,idx)
      hdf_sd_getdata, id, mass
     endif

  hdf_sd_end, hdfid

end

