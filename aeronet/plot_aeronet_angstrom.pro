; Colarco, August 2005
; Code to plot a comparison of the (local) aerosol optical thickness
; generated from FVGCM run to AERONET observations over some period of
; time

; Read in the 440 and 870 nm AOT and compute the angstrom exponent

  pro plot_aeronet_angstrom, exppath, expid, aerPath, location, date0, date1

  lambda = ['440','870']

; -----------------------------------------------------------------------
; Read in the model data
  year = strmid(strcompress(string(date0),/rem),0,4)
;  modelLocation = strlowcase(location)
  modelLocation = location
  angstrom=1.
  readmodelaeronet, exppath, expid, year, modelLocation, '550', aotModel, $
   dateModel, angstrom=angstrom
  readmodelaeronet, exppath, expid, year, modelLocation, lambda[0], aotModel440, $
   dateModel, angstrom=angstrom
  readmodelaeronet, exppath, expid, year, modelLocation, lambda[1], aotModel870, $
   dateModel, angstrom=angstrom

  nspec = n_elements(aotModel[0,*])
  nday  = n_elements(aotModel[*,0])

; test
;  aotModel[*,0:9] = 0.*aotModel[*,0:9]
;  aotModel440[*,0:9] = 0.*aotModel440[*,0:9]
;  aotModel870[*,0:9] = 0.*aotModel870[*,0:9]
;  aotModel[*,14:14] = 0*aotModel[*,14:14]
;  aotModel440[*,14:14] = 0*aotModel440[*,14:14]
;  aotModel870[*,14:14] = 0*aotModel870[*,14:14]

aa = where(angstrom gt 0)
angstrom[aa] = -alog(total(aotModel440[aa,*],2)/total(aotModel870[aa,*],2)) $
   / alog(float(lambda[0])/float(lambda[1]))

; Form a daily average of the model based on the datemodel parameter
  datemodel_ = long(dateModel/100)
  dateuniq   = uniq(datemodel_)
  nday = n_elements(dateuniq)
  dateModel = datemodel_[dateuniq]
  aotModel_ = fltarr(nday,nspec)
  angModel_ = fltarr(nday)
  for iday = 0, nday-1 do begin
   a = where(dateModel_ eq dateModel[iday])
   aotModel_[iday,*] = total(aotModel[a,*],1)/n_elements(a)
   angModel_[iday]  = total(angstrom[a]*total(aotModel[a,*],2)) $
                      / total(aotModel[a,*])
  endfor
  aotModel = aotModel_
  angModel = angModel_

; Now select on the day wanted, assume 1-year or less
  a = where(dateModel ge date0 and dateModel le date1)
  dateModel = dateModel[a]
  aotModel  = aotModel[*,a,*]
  yyyy = fix(datemodel/10000)
  mm   = fix(dateModel-yyyy*10000L)/100
  dd   = fix(dateModel-yyyy*10000L-mm*100)

; Recast date into day number of year
  julday = julday(mm,dd,yyyy)
  dateModel = julday-julday[0]+1

; -----------------------------------------------------------------------
; Read the aeronet data
  aeronetSite = location
  angaeronet = 1.
  read_aeronet2nc, aerPath, aeronetSite, '550', year, aotaeronet, dateaeronet, $
    angstrom=angaeronet
  nt = n_elements(dateaeronet)

; Now select on the day wanted, assume 1-year or less
  a = where(dateAeronet ge date0 and dateAeronet le date1)
  dateAeronet = dateAeronet[a]
  aotAeronet  = aotAeronet[a]
  angaeronet  = angaeronet[a]
  yyyy = fix(dateAeronet/10000)
  mm   = fix(dateAeronet-yyyy*10000L)/100
  dd   = fix(dateAeronet-yyyy*10000L-mm*100)

; Recast date into day number of year
  julday = julday(mm,dd,yyyy)
  dateAeronet = julday-julday[0]+1

; -----------------------------------------------------------------------
; Model: integrate over species for simplicity
  aotModel = total(aotModel,2)

; -----------------------------------------------------------------------
; quality control -- smoothing
;  angAeronet = smooth(aotAeronet, 5, missing=-9999., /nan)
;  angModel   = smooth(aotModel, 5)

; -----------------------------------------------------------------------
; create your own monthly mean
  yyyy = strcompress(string(yyyy[0]),/rem)
     ndaymon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
     if(yyyy eq '2000' or yyyy eq '2004') then ndaymon[1] = 29
     angAeronetMon = fltarr(12)
     stdAeronetMon = fltarr(12)
     angModelMon   = fltarr(12)
     stdModelMon   = fltarr(12)
     iday = 1
     for imon = 0, 11 do begin
      a = where(dateAeronet ge iday and dateAeronet lt iday+ndaymon[imon])
      b = where(angAeronet[a] gt 0)
      if(n_elements(b) ge 3) then begin
       angAeronetMon[imon] = total(angAeronet[a[b]])/n_elements(b)
       stdAeronetMon[imon] = stddev(angAeronet[a[b]])
      endif else begin
       angAeronetMon[imon] = !values.f_nan
       stdAeronetMon[imon] = 0.
      endelse
      a = where(dateModel ge iday and dateModel lt iday+ndayMon[imon])
      angTemp = angModel*aotModel
      angModelMon[imon] = total(angTemp[a])/total(aotmodel[a])
      stdModelMon[imon] = stddev(angModel[a])
      iday = iday+ndayMon[imon]
     endfor


; -----------------------------------------------------------------------
; Make a plot
  midday = fltarr(12)
  midday[0] = 15
  for i = 1, 11 do begin
   midday[i] = midday[i-1]+.5*(ndaymon[i]+ndaymon[i-1])
  endfor


  set_plot, 'ps'
  device, filename='./output/plots/ang.'+expid+'.'+location+'.'+yyyy+'.ps', $
   /helvetica, font_size=14, xsize=12, ysize=8, xoff=.5, yoff=.5, /color
  !P.font=0

  maxy = fix(max([max(angModel),max(angAeronet)])+1.)
  maxy = 2.5

  plot, dateModel, angModel, /nodata, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, ytitle='Angstrom Parameter !Ma!3!D440/870!N', $
   xtickv=midday, xtickname=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', $
                             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  xyouts, .15, .92, aeronetSite, /normal


; Plot the model data in the background
  loadct, 39

; All aerosol
  oplot, dateModel, angModel, thick=linthick, color=84

; Plot the AERONET data in the background
  loadct, 0
;  n = n_elements(dateAeronet)
;  for i = 0, n-1 do begin
;   x = dateAeronet[i]
;   y = angAeronet[i]
;   yf = stdAeronet[i]
;   if(y gt 0) then $
;    polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
;  endfor
  oplot, dateaeronet, angaeronet, thick=linthick, min_value=0.

  plot, dateModel, angModel, /nodata, /noerase, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, xtickv=midday, xtickname=make_array(12,val=' ')


; Make a monthly plot
  maxy = 2.5
  plot, dateModel, angModel, /nodata, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, ytitle='Angstrom Parameter !Ma!3!D440/870!N', $
   xtickv=midday, xtickname=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', $
                             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
   
  xyouts, .15, .92, aeronetSite, /normal


; Plot the AERONET data in the background
  loadct, 0
  iday = 1
  for i = 0, 11 do begin
   x = ndaymon[i]
   y = angAeronetMon[i]
   yf = stdAeronetMon[i]
   if(y gt 0) then $
    polyfill, iday+[0,x,x,0,0], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
   iday = iday + ndaymon[i]
  endfor
  oplot, midday, angaeronetmon, thick=4, min_value=0.
  plots, midday, angaeronetmon, psym=4, noclip=0

  loadct, 39
  oplot, midday, angmodelmon, thick=4, color=84
  for imon = 0, 11 do begin
   y = angmodelmon[imon]
   plots, midday[imon], y+[stdmodelmon[imon],-stdmodelmon[imon]], $
          thick=2, color=84
  endfor

  plot, dateModel, angModel, /nodata, /noerase, charsize=.75, $
   position=[.15,.15,.9,.9], $
   xstyle=9, ystyle=9, xthick=2, ythick=2, yrange=[0,maxy], $
   xticks=11, xtickv=midday, xtickname=make_array(12,val=' ')
   

  device, /close

end
