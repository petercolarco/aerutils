; Plot depol along some orbit track
  filename = '/fvol/calculon2/vbuchard/CALIPSO_L15/Analysis/File_Pressure/calipso_l3a_2011_JJA.nc'
  nc4readvar, filename, 'pressure', pres, lon=lon_, lat=lat_
  nc4readvar, filename, 'taback',   ext_
  ext_[where(ext_ lt 0)] = !values.f_nan
  lat = fltarr(361,72)
  ext = fltarr(361,72)
  for i = 0, 71 do begin
   lat[*,i] = lat_
  endfor

; Now plot at a longitude
  a = where(lon_ eq -80.)
  for i = 0, 360 do begin
   for j = 0, 71 do begin
    ext[i,j] = mean(ext_[a-10:a+10,i,j],/nan)
   endfor
  endfor
  pres = reform(pres[a,*,*])
  loadct, 39

  set_plot, 'ps'
  device, file='caliop_profile_-80.new.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0

  levelarray = findgen(61)*.00003335 + .0005
  colorarray = findgen(61)*4
  colorarray[60] = 254
  contour, ext, lat, pres, level=levelarray, /cell, $
           yrange=[1000,500], /ylog, xrange=[-10,60], xstyle=1, ystyle=1, $
           xtitle='latitude', ytitle='pressure [hPa]', $
           yticks=10, ytickv=findgen(11)*50+500, $
           position=[.15,.25,.95,.95], c_color=colorarray
  labelarray = strarr(61)
  labels = findgen(5)*.0005 + .0005
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
    if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(labels[il],format='(f6.4)')
  endfor
  makekey, .15, .075, .8, .035, 0, -.035, color=findgen(60)*4, $
   label=labelarray, $
   align=.5, /no, charsize=.75
  device, /close


end
