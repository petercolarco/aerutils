; Colarco, September 2010
; Compare the AERONET/Model at a single point for some number of
; model realizations

  expid = ['CR_control.tavg2d_aer_x.aeronet', $
           'CR_control.tavg2d_aer_x.aeronet', $
           'CR_control.tavg2d_carma_x.aeronet']

;  expid = ['CF_control.tavg2d_aer_x.aeronet', $
;           'CF_control.tavg2d_aer_x.aeronet', $
;           'CF_control.tavg2d_carma_x.aeronet', $
;           'CF_carma16.tavg2d_carma_x.aeronet']

  expid = ['CF_g8cart.tavg2d_aer_x.aeronet', $
           'CF_g8cart.tavg2d_aer_x.aeronet', $
           'CF_g8cart.tavg2d_carma_x.aeronet']

  nexpid = n_elements(expid)
  locwant = ['Capo_Verde','Dry_Tortugas','La_Parguera']
  ymaxarray = [1.2,.5,.6]

  years = ['2000']

  color = 1   ; 1 if I want color output, else 0 for gray scale
  nmon = 8   ; number of months minimum to count site

  if(color) then begin
   backcolor=208
   forcolor = 254
   ct = 39
  endif else begin
   backcolor = 150
   forcolor = 70
   ct = 0
  endelse

  if(n_elements(years) eq 1) then begin
   yearstr = years[0]
  endif else begin
   yearstr = years[0]+'_'+years[n_elements(years)-1]
  endelse


; Read the first expid data to set up the plot
  read_mon_mean, expid[0], years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 elevation=elevation, locationwant=locwant
  date = strcompress(string(date),/rem)

  for iloc = 0, n_elements(location)-1 do begin


; Create a plot file
  set_plot, 'ps'
  filename = './output/plots/aeronet_compare.'+expid[0]+'.'+location[iloc] + $
             '.'+yearstr+'.ps'
  device, file=filename, color=color, /helvetica, font_size=10, $
          xoff=.5, yoff=.5, xsize=12, ysize=20
  !p.font=0


; position the plots
  position = fltarr(4,2)
  position[*,0] = [.1,.6,.9,.95]
  position[*,1] = [.1,.1,.9,.45]

  loc_ = location[iloc]
  a = 0
  while(a[0] ne -1) do begin
   a = strpos(loc_,'_')
   if(a[0] ne -1) then strput, loc_,' ',a
  endwhile
  location[iloc] = loc_

; setup the tick marks on the x-axis of date
; What is the frequency of tick marks desired (in months)
  ntick = n_elements(years)
  nminor = 4
  tickname=replicate(' ', ntick+1)
  tickname_=replicate(' ', ntick+1)
  for it = 0, ntick-1 do begin
   tickname_[it] = strmid(strcompress(string(date[it*12]),/rem),0,4)
  endfor
  nt = n_elements(date)

;  Find a suitable maximum value
   a = where(finite(aotaeronet[*,iloc]) eq 1)
   ymax = max([max(aotaeronet[a,iloc]+aotaeronetstd[a,iloc]),max(aotmodel[a,iloc]+aotmodelstd[a,iloc])])
ymax=ymaxarray[iloc]
   loadct, ct
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]
   for i = 0, nt-1 do begin
    x = i
    y = aotaeronet[i,iloc]
    yf = aotaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), aotaeronet[*,iloc], psym=-8, thick=4, color=forcolor

   colorarray = [0,0,0,80]
   linarray   = [0,1,2,2]
   for iexpid = 0, nexpid-1 do begin
    read_mon_mean, expid[iexpid], years, location, latitude, longitude, date, $
                   aotaeronet_, angaeronet_, aotmodel_, angmodel_, $
                   aotaeronetstd_, angaeronetstd_, aotmodelstd_, angmodelstd_, $
                   aotmodeldu=aotmodeldu_, aotmodelss=aotmodelss_, $
                   elevation=elevation, locationwant=locwant
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colorarray[iexpid]
    if(iexpid ne 0) then aotmodel_[*,iloc] = aotmodeldu_[*,iloc]
    plots, indgen(nt), aotmodel_[*,iloc], psym=-8, thick=8, $
           lin=linarray[iexpid], color=colorarray[iexpid]
    for i = 0, nt-1 do begin
     x = i
     y = aotmodel_[i,iloc]
     yf = aotmodelstd_[i,iloc]
     xf = [-.5,.5]
     if(iexpid ne 0) then yf[*] = 0.
     if(iexpid ne 0) then xf = [0,0]
     if(finite(y)) then begin
      plots, x, y+[-yf,yf], color=colorarray[iexpid], noclip=0, thick=2
      plots, x+xf, y-yf, color=colorarray[iexpid], thick=2, noclip=0
      plots, x+xf, y+yf, color=colorarray[iexpid], thick=2, noclip=0
     endif
    endfor
   endfor




   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='AOT [500 nm]', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]
   for itick = 0, ntick-1 do begin
    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
   endfor
goto, jump
; ---------------------
; Angstrom



   a = where(finite(aotaeronet[*,iloc]) eq 1)
   ymax = max([max(angaeronet[a,iloc]+angaeronetstd[a,iloc]),max(angmodel[a,iloc]+angmodelstd[a,iloc])])
   loadct, ct
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,1], /noerase
   for i = 0, nt-1 do begin
    x = i
    y = angaeronet[i,iloc]
    yf = angaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), angaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt), angmodel[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i
    y = angmodel[i,iloc]
    yf = angmodelstd[i,iloc]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
     plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
    endif
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='!Ma!3!D440-870!N', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,1]
   for itick = 0, ntick-1 do begin
    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
   endfor

jump:
  device, /close

  endfor

end


