; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid = 'dR_F25b18.inst2d_hwl.aeronet'
  years = ['2007']
  color = 1   ; 1 if I want color output, else 0 for gray scale
  nmon = 3   ; number of months minimum to count site

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
   print, 'Only one year allowed in aeronet_site.1yr.pro; stopping'
   stop
  endelse


  read_mon_mean, expid, years, location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd
  read_histogram, expid, years, location, latitude, longitude, $
                  taumin, taumax, angmin, angmax, $
                  aotbin_aer, angbin_aer, aotbin_mod, angbin_mod

  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  filename = './output/plots/aeronet_site.'+expid+'.'+yearstr+'.ps'
  device, file=filename, color=color, /helvetica, font_size=10, $
          xoff=.5, yoff=26, xsize=25, ysize=15, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,6)
  position[*,0] = [.07,.6,.4,.95]
  position[*,1] = [.47,.6,.68,.95]
  position[*,2] = [.75,.6,.96,.95]

  position[*,3] = [.07,.1,.4,.45]
  position[*,4] = [.47,.1,.68,.45]
  position[*,5] = [.75,.1,.96,.45]


  nloc = n_elements(location)
; Fix the string names to get rid of "_" character
  for iloc = 0, nloc-1 do begin
   a = strpos(location[iloc],'_')
   loc_ = location[iloc]
   if(a[0] ne -1) then strput, loc_,' ',a
   location[iloc] = loc_
  endfor
  locuse = make_array(nloc,val=0)

; setup the tick marks on the x-axis of date
; What is the frequency of tick marks desired (in months)
  ntick = 13
  nminor = 1
  tickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  nt = 12

  for iloc = 0, nloc-1 do begin

;  make a plot

   a = where(finite(aotaeronet[*,iloc]) eq 1)
   if(n_elements(a) ge nmon) then begin

;  Massage the histogram input
   nobs = total(aotbin_aer[iloc,*])
   faotbin_aer = reform(aotbin_aer[iloc,*])/nobs
   fangbin_aer = reform(angbin_aer[iloc,*])/nobs
   faotbin_mod = reform(aotbin_mod[iloc,*])/nobs
   fangbin_mod = reform(angbin_mod[iloc,*])/nobs

   locuse[iloc] = 1

;  Find a suitable maximum value
   ymax = max([max(aotaeronet[a,iloc]+aotaeronetstd[a,iloc]),max(aotmodel[a,iloc]+aotmodelstd[a,iloc])])
   loadct, ct
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt+1], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]
   for i = 0, nt-1 do begin
    x = i+1
    y = aotaeronet[i,iloc]
    yf = aotaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt)+1, aotaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt)+1, aotmodel[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
    y = aotmodel[i,iloc]
    yf = aotmodelstd[i,iloc]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
     plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
    endif
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='year: '+years[0], ytitle='AOT [500 nm]', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]


   loadct, ct
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,1], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   plots, aotaeronet[*,iloc], aotmodel[*,iloc], psym=8


   do_stat = 1
   if(do_stat) then begin
;if(location[iloc] eq 'GSFC') then stop
    a = where(finite(aotaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, aotaeronet[a,iloc], aotmodel[a,iloc], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n, format='(i2)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
     xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
     xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
     xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
     xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
     xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
    endif
   endif

   ymax = max([max(faotbin_aer),max(faotbin_mod)])
   dx = taumax[0]-taumin[0]
   f = where(faotbin_aer gt 0)
   g = where(faotbin_mod gt 0)
   xmax = max([taumin[max(f)],taumin[max(g)]])+dx
   nx = n_elements(taumin)
   loadct, ct
   plot, indgen(nx+1), /nodata, $
         xrange=[0,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,2], /noerase, $
         xtitle='AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of AOT'
   for ix = 0, nx-1 do begin
    x0 = taumin[ix]
    x1 = x0+dx
    y0 = 0
    y1 = faotbin_aer[ix]
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=backcolor, /fill
   endfor
   plots, taumin[g]+dx/2., faotbin_mod[g], psym=-8, lin=2
   plot, indgen(nx+1), /nodata, $
         xrange=[0,xmax], $   
         yrange=[0,ymax], $    
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,2], /noerase, $
         xtitle='AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of AOT' 


; ---------------------
; Angstrom



   a = where(finite(aotaeronet[*,iloc]) eq 1)
   ymax = max([max(angaeronet[a,iloc]+angaeronetstd[a,iloc]),max(angmodel[a,iloc]+angmodelstd[a,iloc])])
   loadct, ct
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt+1], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,3], /noerase
   for i = 0, nt-1 do begin
    x = i+1
    y = angaeronet[i,iloc]
    yf = angaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt)+1, angaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt)+1, angmodel[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
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
    xtitle='year: '+years[0], ytitle='!Ma!3!D440-870!N', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,3]


   loadct, ct
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,4], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   plots, angaeronet[*,iloc], angmodel[*,iloc], psym=8

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(angaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, angaeronet[a,iloc], angmodel[a,iloc], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n, format='(i2)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
     xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
     xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
     xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
     xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
     xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
    endif
   endif



   ymax = max([max(fangbin_aer),max(fangbin_mod)])
   dx = angmax[0]-angmin[0]
   f = where(fangbin_aer gt 0)
   g = where(fangbin_mod gt 0)
   xmin = min([angmin[min(f)],angmin[min(g)]])-dx
   xmax = max([angmin[max(f)],angmin[max(g)]])+dx
   nx = n_elements(angmin)
   loadct, ct
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $   
         position=position[*,5], /noerase, $
         xtitle='Angstrom Exponent', ytitle='fraction', $
         yminor=2, $
         title='PDF of Angstrom Exponent'
   for ix = 0, nx-1 do begin
    x0 = angmin[ix]
    x1 = x0+dx
    y0 = 0
    y1 = fangbin_aer[ix]
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=backcolor, /fill
   endfor
   plots, angmin[g]+dx/2., fangbin_mod[g], psym=-8, lin=2
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,5], /noerase, $
         xtitle='Angstrom Exponent', ytitle='fraction', $
         yminor=2, $
         title='PDF of Angstrom Exponent'

jump:
  endif

  endfor

; Make a map
  loadct, ct
  map_set, /cont
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nloc-1 do begin
   if(locuse[iloc]) then begin
    plots, longitude[iloc], latitude[iloc], psym=8, noclip=0
    label = location[iloc]
    xyouts, longitude[iloc], latitude[iloc]-1, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
   endif
  endfor


  device, /close

end
