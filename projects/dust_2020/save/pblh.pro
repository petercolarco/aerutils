; get the pblh and find the max hiehgt over the Sahara
  wantlat = [9,33]
  wantlon = [-10,30]
  nc4readvar, 'pblh.nc', 'pblh', pblh, lon=lon, lat=lat, wantlat=wantlat, wantlon=wantlon
  nc4readvar, 'phis.nc', 'phis', phis, lon=lon, lat=lat, wantlat=wantlat, wantlon=wantlon
  h0 = phis/9.81

  maxpblh_ = pblh+h0

  nt = n_elements(pblh[0,0,*])

  maxpblh = fltarr(nt)
  for it = 0, nt-1 do begin
   maxpblh[it] = max(maxpblh_[*,*,it])
  endfor

end

