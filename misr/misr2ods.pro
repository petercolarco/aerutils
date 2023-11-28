; Colarco,March 2006
; misr2ods -> read in MISR granules and print out in odt format
; suitable for ods_maker.x to turn into an ODS file

  misrpath = '/output4/MISR/Level2/'
  get_misr, misrpath, '20030101', lon, lat, aot, blocktime, channels
; returned information is lon, lat -> block, x, y
;                         aot      -> block, x, y, channel
;                         blocktime-> block

; --- At this point I need to parse the blocktime into something we can
; --- use for creating the ODS file with the desired times...

  set_plot, 'x'
  map_set, /cont
  plots, lon, lat, psym=4

; Collect only aot values with retrievals at all 4 wavelengths
  UNDEF = -9999.
  nch = n_elements(channels)
  nobs = lonarr(nch)
  for i = 0, nch -1 do begin
   nobs[i] = n_elements(where(aot[*,i] ne UNDEF))
  endfor
; Select on 550 nm channels
  ich = 1
  a = where(aot[*,ich] ne UNDEF)
  aot = aot[a,*]
  lon = lon[a]
  lat = lat[a]
; Set UNDEF to another value
  a = where(aot eq UNDEF)
  if(a[0] ne -1) then aot[a] = 1e+15

; pts surviving
  npts = n_elements(aot[*,ich])

; Assign ks to each obs
  ks = string(lindgen(n_elements(aot[*,ich])), format='(i6)')


; output as a temporary txt file suitable for conversion to ODS
  kx = '313'
  kt = '45'
  time = '0'
  qcx = '0'
  qch = '0'
  xm = '0.00E+00'
  openw, lun, 'odslist.odt', /get_lun
  for i = 0L, npts-1 do begin
   for ich = 0, nch-1 do begin
    printf, lun, kx, ks[i], kt, time, channels[ich], lon[i], lat[i], $
            aot[i,ich], qcx, qch, xm, $
            format='(a3,1x,a6,1x,a2,1x,a4,1x,f6.1,1x,f8.2,1x,f7.2,1x,e9.2,1x,a3,1x,a3,1x,a9)'
   endfor
  endfor

  free_lun, lun

end
