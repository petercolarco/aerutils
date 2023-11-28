; Colarco, August 2005
; Code to plot a comparison of the (local) aerosol optical thickness
; generated from FVGCM run to AERONET observations over some period of
; time

  pro plot_aeronet, exppath, expid, aerPath, location, lambda, date0, date1, modis=modisIn
   print, location, lambda

  modis = 0
  if(keyword_set(modisIn)) then modis=modisIn

; -----------------------------------------------------------------------
; Read in the model data
;  modelLocation = strlowcase(location)
  modelLocation = location
  year = strmid(strcompress(string(date0),/rem),0,4)
  readmodelaeronet, exppath, expid, year, modelLocation, lambda, aotModel, dateModel

; test
;  aotModel[*,0:4] = .5*aotModel[*,0:4]
;  aotModel[*,10:13] = 2.*aotModel[*,10:13]

  nspec = n_elements(aotModel[0,*])

; Form a daily average of the model based on the datemodel parameter
  datemodel_ = long(dateModel/100)
  dateuniq   = uniq(datemodel_)
  nday = n_elements(dateuniq)
  dateModel = datemodel_[dateuniq]
  aotModel_ = fltarr(nday,nspec)
  for iday = 0, nday-1 do begin
   a = where(dateModel_ eq dateModel[iday])
   aotModel_[iday,*] = total(aotModel[a,*],1)/n_elements(a)
  endfor
  aotModel = aotModel_

; Now select on the day wanted, assume 1-year or less
  a = where(dateModel ge date0 and dateModel le date1)
  dateModel = dateModel[a]
  aotModel  = aotModel[a,*]
  yyyy = fix(datemodel/10000)
  mm   = fix(dateModel-yyyy*10000L)/100
  dd   = fix(dateModel-yyyy*10000L-mm*100)

; Recast date into day number of year
  julday = julday(mm,dd,yyyy)
  dateModel = julday-julday[0]+1

; -----------------------------------------------------------------------
; Read in the modis data (if requested)
  if(modis) then begin

  modisLocation = location
  year = strmid(strcompress(string(date0),/rem),0,4)
  modpath = '/output3/colarco/MODIS/Level3/b/GRITAS/'
  readmodisaeronet, modpath, 'MOD04_L2_lnd', year, location, lambda, aotModisLnd, dateModis
  readmodisaeronet, modpath, 'MOD04_L2_ocn', year, location, lambda, aotModisOcn, dateModis

; For simplicity, we take the land retrieval, but replace with the ocean if present
  aotModis = aotModisLnd
  a = where(aotModisOcn ge 0 and aotModisOcn lt 100)
  if(a[0] ne -1) then aotModis[a] = aotModisOcn[a]

; Form a daily average of the model based on the datemodel parameter
  datemodis_ = long(dateModis/100)
  dateuniq   = uniq(datemodis_)
  nday = n_elements(dateuniq)
  dateModis = datemodel_[dateuniq]
  aotModis_ = fltarr(nday)
  for iday = 0, nday-1 do begin
   a = where(dateModis_ eq dateModis[iday])
   b = where(aotModis[a] ge 0 and aotModis[a] lt 100)
   if(b[0] ne -1) then begin
    aotModis_[iday] = total(aotModis[a[b]])/n_elements(b)
   endif else begin
    aotModis_[iday] = 1.e20
   endelse
  endfor
  aotModis = aotModis_

; Now select on the day wanted, assume 1-year or less
  a = where(dateModis ge date0 and dateModis le date1)
  dateModis = dateModis[a]
  aotModis  = aotModis[a,*]
  yyyy = fix(datemodis/10000)
  mm   = fix(dateModis-yyyy*10000L)/100
  dd   = fix(dateModis-yyyy*10000L-mm*100)

; Recast date into day number of year
  julday = julday(mm,dd,yyyy)
  dateModis = julday-julday[0]+1

  endif

; -----------------------------------------------------------------------
; Read the aeronet data
  aeronetSite = location
  read_aeronet2nc, aerPath, aeronetSite, lambda, year, aotaeronet, dateaeronet

; Now select on the day wanted, assume 1-year or less
  a = where(dateAeronet ge date0 and dateAeronet le date1)
  dateAeronet = dateAeronet[a]
  aotAeronet  = aotAeronet[a]
  yyyy = fix(dateAeronet/10000)
  mm   = fix(dateAeronet-yyyy*10000L)/100
  dd   = fix(dateAeronet-yyyy*10000L-mm*100)

; Recast date into day number of year
  julday = julday(mm,dd,yyyy)
  dateAeronet = julday-julday[0]+1

; -----------------------------------------------------------------------
; quality control -- smoothing
;  aotAeronet = smooth(aotAeronet, 5, missing=-9999., /nan)
;  aotModel   = smooth(aotModel, [5,1])

; -----------------------------------------------------------------------
; create your own monthly mean
  yyyy = strcompress(string(yyyy[0]),/rem)
     ndaymon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
     if(yyyy eq '2000' or yyyy eq '2004') then ndaymon[1] = 29
     aotAeronetMon = fltarr(12)
     stdAeronetMon = fltarr(12)
     aotModisMon = fltarr(12)
     stdModisMon = fltarr(12)
     aotModelMon   = fltarr(12)
     stdModelMon   = fltarr(12)
     iday = 1
     for imon = 0, 11 do begin
      a = where(dateAeronet ge iday and dateAeronet lt iday+ndaymon[imon])
      b = where(aotAeronet[a] gt 0)
      if(n_elements(b) ge 3) then begin
       aotAeronetMon[imon] = total(aotAeronet[a[b]])/n_elements(b)
       stdAeronetMon[imon] = stddev(aotAeronet[a[b]])
      endif else begin
       aotAeronetMon[imon] = !values.f_nan
       stdAeronetMon[imon] = 0.
      endelse
      if(modis) then begin
      a = where(dateModis ge iday and dateModis lt iday+ndaymon[imon])
      b = where(aotModis[a] ge 0 and aotModis[a] lt 100)
      if(n_elements(b) ge 3) then begin
       aotMODISMon[imon] = total(aotModis[a[b]])/n_elements(b)
       stdMODISMon[imon] = stddev(aotModis[a[b]])
      endif else begin
       aotModisMon[imon] = !values.f_nan
       stdModisMon[imon] = 0.
      endelse
      endif
      a = where(dateModel ge iday and dateModel lt iday+ndayMon[imon])
      aotTemp = total(aotModel,2)
      aotModelMon[imon] = total(aotTemp[a])/n_elements(a)
      stdModelMon[imon] = stddev(aotTemp[a])
      iday = iday+ndayMon[imon]
     endfor


; -----------------------------------------------------------------------
; Make a plot
  ndaymon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  yyyy = strcompress(string(yyyy[0]),/rem)
  if(yyyy eq '2000' or yyyy eq '2004') then ndaymon[1] = 29
  midday = fltarr(12)
  midday[0] = 15
  for i = 1, 11 do begin
   midday[i] = midday[i-1]+.5*(ndaymon[i]+ndaymon[i-1])
  endfor

  set_plot, 'ps'
  device, filename='./output/plots/aot.'+expid+'.'+location+'.'+yyyy+'.'+lambda+'.ps', $
          /helvetica, font_size=14, xsize=12, ysize=8, xoff=.5, yoff=.5, /color
  !P.font=0

  maxy = fix(max([max(total(aotModel,2)),max(aotAeronet)])+1.)
;  maxy = 1.

  plot, dateModel, aotModel, /nodata, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, ytitle='AOT '+lambda+' nm', $
   xtickv=midday, xtickname=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', $
                             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  xyouts, .15, .92, aeronetSite, /normal


; Plot the model data in the background
  loadct, 39

; All aerosol
  n = n_elements(dateModel)
  for i = 0, n-1 do begin
   x = dateModel[i]
   y = total(aotModel[i,*])
   polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=208
  endfor

; All aerosol - dust
  n = n_elements(dateModel)
  for i = 0, n-1 do begin
   x = dateModel[i]
   y = total(aotModel[i,*])-total(aotModel[i,0:4])
   polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=84
  endfor

; All aerosol - dust - seasalt
  n = n_elements(dateModel)
  for i = 0, n-1 do begin
   x = dateModel[i]
   y = total(aotModel[i,*])-total(aotModel[i,0:9])
   polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=254
  endfor

; All aerosol - dust - seasalt - carbon
  n = n_elements(dateModel)
  for i = 0, n-1 do begin
   x = dateModel[i]
   y = total(aotModel[i,*])-total(aotModel[i,0:13])
   polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=176
  endfor

; Plot the AERONET data in the background
  loadct, 0
;  n = n_elements(dateAeronet)
;  for i = 0, n-1 do begin
;   x = dateAeronet[i]
;   y = aotAeronet[i]
;   yf = stdAeronet[i]
;   if(y gt 0) then $
;    polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
;  endfor
  oplot, dateaeronet, aotaeronet, thick=linthick, min_value=0.

  usersym, .5*[-1,0,1,0,-1], .5*[0,-1,0,1,0], /fill, color=160
  if(modis) then plots, datemodis, aotmodis, psym=8

  plot, dateModel, aotModel, /nodata, /noerase, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, xtickv=midday, xtickname=make_array(12,val=' ')



; Make a monthly plot
;  maxy = 2

  plot, dateModel, aotModel, /nodata, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, ytitle='AOT '+lambda+' nm', $
   xtickv=midday, xtickname=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', $
                             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  xyouts, .15, .92, aeronetSite, /normal


; Plot the AERONET data in the background
  loadct, 0
  iday = 1
  midday = fltarr(12)
  midday[0] = 15
  for i = 1, 11 do begin
   midday[i] = midday[i-1]+.5*(ndaymon[i]+ndaymon[i-1])
  endfor
  for i = 0, 11 do begin
   x = ndaymon[i]
   y = aotAeronetMon[i]
   yf = stdAeronetMon[i]
   if(y gt 0) then $
    polyfill, iday+[0,x,x,0,0], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
   iday = iday + ndaymon[i]
  endfor
  oplot, midday, aotaeronetmon, thick=4, min_value=0., lin=2
  plots, midday, aotaeronetmon, psym=4, noclip=0

  if(modis) then begin
   for i = 0, 11 do begin
    y = aotmodismon[i]
    plots, midday[i]+[-10,10], aotmodismon[i], thick=4, noclip=1, color=0
    plots, midday[i], y+[stdmodismon[i],-stdmodismon[i]], thick=4, color=0
   endfor
  endif

  loadct, 39
  oplot, midday, aotmodelmon, thick=4, color=84
  for imon = 0, 11 do begin
   y = aotmodelmon[imon]
   plots, midday[imon], y+[stdmodelmon[imon],-stdmodelmon[imon]], $
          thick=2, color=84
  endfor

  plot, dateModel, aotModel, /nodata, /noerase, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, xtickv=midday, xtickname=make_array(12,val=' ')
jump2:

  device, /close

end
