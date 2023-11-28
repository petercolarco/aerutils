; Plot from the OMI granule

  set_plot, 'ps'
  device, file='ler.diff.ps', xsize=8, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 68
  !p.font=0
  !p.multi=[0,1,1]



; This is the LER I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SurfaceAlbedo')
  albedo  = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Reflectivity')
  refl   = h5d_read(var_id)
  refl   = reform(refl[1,*,*])
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id

; The "refl" is the unmodified LER, not accounting for surface spectral
; reflectance variability.  That's OK: Santiago provides
; uncorrected LER too
;  refl = refl-(albedo[1,*,*]-albedo[0,*,*])


; Now get the LER that Santiago returned to me
  filename = './2007m0605t1407-o15368_julian156.nc'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'LER388')
  ncdf_varget, cdfid, id, ler_inp
  ncdf_close, cdfid
; Put onto same grid as below will have...Santiago gives 60x1201
  ler_return = make_array(60,1644,val=min(ler_inp))
  ler_return[*,199:1399] = ler_inp

; Now difference
  diff = refl
  diff[*] = !values.f_nan
  a = where(refl gt 0 and ler_return gt 0)
  diff[a] = refl[a]-ler_return[a]

; add offset to make all positive
  a = where(finite(diff) eq 1)
  diff_ = diff
  diff_[a] = diff_[a]+.005

  map_set, /cont, /noerase, title='Pete - Santiago Uncorrected LER 388nm > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(finite(diff_[ix,iy]) eq 1) then begin
     val = diff_[ix,iy]
     color = fix(val*25500+.5)    ; Dynamic range is 0.01, so this sets.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(-.05+i*.01,format='(f5.2)')
  endfor
  makekey, .1, .1, .8, .05, 0, -.035, $
   charsize=.5, align=.5, $
   colors=findgen(255), labels=labels, /noborder



  device, /close


end
