  outfilehead = 'MOD04_regions.d.freq.daily'
  sample = ['modis.','shift_misr.','shift_subpoint.']
  sample_name = ['MODIS', 'MISR', 'SubPoint']

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
  device, /color, file='./output/plots/frequency.MOD04.2009.climatology.ps', $
   xsize=18, ysize=16, xoff=.5, yoff=.5, /helvetica, font_size=12
  !p.font=0

  loadct, 39
  colorarray = findgen(10)*25+25
  levelarray = [0.01,0.02,0.03,0.05,0.1,0.15,0.2,0.3,0.4,0.5]

; Loop over the histogram bins
  ih_ = [1,2,5]
  for ik = 0,2 do begin
   ih = ih_[ik]
   hstr = string(ih*0.1,format='(f3.1)')

; Read in the files
  nctl = n_elements(sample)
  for ictl = 0, nctl-1 do begin
   title_array = 'Fraction of AOT > '+hstr+' (2009) ('+sample_name[ictl]+')'
   map_set, position=[0.05,0.2,0.95,.9], title=title_array
   for ix = 0, nxr-1 do begin
    for iy = 0, nyr-1 do begin

;    Get the data and turn into something you can plot
     filename = './output/tables/'+outfilehead+plottitle[ix,iy]+sample[ictl]
     read_frequency_histogram, filename, $
       date, histnorm, num, histmin, histmax, nbin, yyyy=['2009']

     nt = n_elements(date)
     dx = (histmax-histmin)/nbin
     x = histmin+dx/2. + findgen(nbin)*dx
     y = fltarr(nbin)
     for i = 0, nbin-1 do begin
      y[i] = total(histnorm[i,*]*num,/nan)/total(num,/nan)
     endfor

     lon = 0.5*(lon0want[ix,iy]+lon1want[ix,iy])
     lat = 0.5*(lat0want[ix,iy]+lat1want[ix,iy])
;    Integrate probability aot > value
     ytot = total(y[ih:9])
     a = where(ytot gt levelarray)
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

  endfor

  device, /close

end

