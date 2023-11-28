  filename = 'c180R_I33_SChem_TQvblend_SE_newoptics.inst3d_aer_v.20170813_0600z.nc4'
  wantlon = -124.
  wantlat = 54.
  nc4readvar, filename, 'brcphobic', brcphobic, lon=lon, lat=lat, lev=lev, $
   wantlon=wantlon, wantlat=wantlat
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat, lev=lev, $
   wantlon=wantlon, wantlat=wantlat
  nc4readvar, filename, 'ps', ps, lon=lon, lat=lat, lev=lev, $
   wantlon=wantlon, wantlat=wantlat

  pmid = fltarr(72)
  pmid[71] = exp((alog(ps)+alog(ps-delp[71]))/2.)
  pf = ps
  for i = 70, 0, -1 do begin
   pf = pf-delp[i+1]
   pmid[i] = exp((alog(pf)+alog(pf-delp[i]))/2.)
  endfor
  
  set_plot, 'ps'
  plot, brcphobic*1e9, pmid/100, yrange=[500,100]
  plots, brcphobic*1e9, pmid/100, psym=4, 
  device, /close

end
