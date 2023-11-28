; This will plot the number of observations over some period (modis)
; and then the ratio of observations (misr, subpoint)

  outfilehead = 'e530_regions.d.freq.daily'
  sample = ['modis.','shift_misr.','shift_subpoint.']
  title_array = ['# MODIS observations (0.5 x 0.67) 2009', $
                 'Ratio #MISR/#MODIS', 'Ratio #Subpoint/#MODIS']

; Filenames
  nxr = 288/8
  nyr = 180/10
  nreg = nxr*nyr
  plottitle = strarr(nxr,nyr)
  lon0want = fltarr(nxr,nyr)
  lon1want = fltarr(nxr,nyr)
  lat0want = fltarr(nxr,nyr)
  lat1want = fltarr(nxr,nyr)
  for ix = 0, nxr-1 do begin
   for iy = 0, nyr-1 do begin
    lon0want[ix,iy] = ix*10.
    lon1want[ix,iy] = lon0want[ix,iy] + 10.
    lat0want[ix,iy] = -90.+iy*10.
    lat1want[ix,iy] = lat0want[ix,iy] + 10.
    xstr = 'x'+strcompress(string(fix(lon0want[ix,iy])),/rem)+'_'+$
               strcompress(string(fix(lon1want[ix,iy])),/rem)+'.'
    latsr = ''
    if(lat0want[ix,iy] lt 0) then latstr = 's'
    if(lat0want[ix,iy] gt 0) then latstr = 'n'
    ystr = latstr+strcompress(string(fix(abs(lat0want[ix,iy]))),/rem)+'_'
    latsr = ''
    if(lat1want[ix,iy] lt 0) then latstr = 's'
    if(lat1want[ix,iy] gt 0) then latstr = 'n'
    ystr = ystr+latstr+strcompress(string(fix(abs(lat1want[ix,iy]))),/rem)+'.'
    ixstr = strcompress(string(ix),/rem)
    if(ix lt 10) then ixstr = '0'+ixstr
    iystr = strcompress(string(iy),/rem)
    if(iy lt 10) then iystr = '0'+iystr
    rstr = 'r'+ixstr+'_'+iystr+'.'
    plottitle[ix,iy] = '.aot.'+rstr+xstr+ystr
   endfor
  endfor  

; Make plot
  set_plot, 'ps'
  device, /color, file='./output/plots/coverage.e530.d.freq.daily.ps', $
   xsize=18, ysize=16, xoff=.5, yoff=.5, /helvetica, font_size=12
  !p.font=0
  loadct, 39
  colorarray = findgen(10)*25+25
  levelarray = [100,200,500,1000,2000,5000,10000.,20000,50000,100000]

; Read in the files
  nctl = n_elements(sample)
  ictl = 0
  map_set, position=[0.05,0.2,0.95,.9], title=title_array[ictl]
  nummodis = lonarr(nxr,nyr)
   for ix = 0, nxr-1 do begin
    for iy = 0, nyr-1 do begin
     filename = './output/tables/'+outfilehead+plottitle[ix,iy]+sample[ictl]
     read_frequency_histogram, filename, $
      date, histnorm, num, histmin, histmax, nbin, yyyy=['2009']
     nummodis[ix,iy] = total(num,/nan)
     lon = 0.5*(lon0want[ix,iy]+lon1want[ix,iy])
     lat = 0.5*(lat0want[ix,iy]+lat1want[ix,iy])
     a = where(total(num,/nan) gt levelarray)
     if(a[0] ne -1) then begin
      j = a[n_elements(a)-1]
      if(iy eq nyr-1) then begin
       polyfill, lon+[-5,5,5,-5,-5], lat+[-5,-5,4,4,-5], /fill, color=colorarray[j]
       plots, lon+[-5,5,5,-5,-5], lat+[-5,-5,4,4,-5]
      endif else begin
       polyfill, lon+[-5,5,5,-5,-5], lat+[-5,-5,5,5,-5], /fill, color=colorarray[j]
       plots, lon+[-5,5,5,-5,-5], lat+[-5,-5,5,5,-5]
      endelse
     endif
    endfor
   endfor
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -0.025, align=0, $
   color=colorarray, labels=strcompress(string(long(levelarray)),/rem)

; Read in the files
  levelarray = [0.01, 0.02, 0.03, 0.05, 0.075, 0.1, 0.2, 0.3, 0.5, 0.75]
  for ictl = 1, nctl-1 do begin
   map_set, position=[0.05,0.2,0.95,.9], title=title_array[ictl]
   for ix = 0, nxr-1 do begin
    for iy = 0, nyr-1 do begin
     filename = './output/tables/'+outfilehead+plottitle[ix,iy]+sample[ictl]
     read_frequency_histogram, filename, $
       date, histnorm, num, histmin, histmax, nbin, yyyy=['2009']
     lon = 0.5*(lon0want[ix,iy]+lon1want[ix,iy])
     lat = 0.5*(lat0want[ix,iy]+lat1want[ix,iy])
     a = where(total(num,/nan)/nummodis[ix,iy] gt levelarray)
     if(a[0] ne -1) then begin
      j = a[n_elements(a)-1]
      if(iy eq nyr-1) then begin
       polyfill, lon+[-5,5,5,-5,-5], lat+[-5,-5,4,4,-5], /fill, color=colorarray[j]
       plots, lon+[-5,5,5,-5,-5], lat+[-5,-5,4,4,-5]
      endif else begin
       if(iy eq 0) then begin
        polyfill, lon+[-5,5,5,-5,-5], lat+[-4,-4,5,5,-4], /fill, color=colorarray[j]
        plots, lon+[-5,5,5,-5,-5], lat+[-4,-4,5,5,-4]
       endif else begin
        polyfill, lon+[-5,5,5,-5,-5], lat+[-5,-5,5,5,-5], /fill, color=colorarray[j]
        plots, lon+[-5,5,5,-5,-5], lat+[-5,-5,5,5,-5]
       endelse
      endelse
     endif
    endfor
   endfor
   map_continents, thick=3
   makekey, .1, .1, .8, .05, 0, -0.025, align=0, $
    color=colorarray, labels=strcompress(string(levelarray,format='(f4.2)'),/rem)
  endfor

  device, /close

end

