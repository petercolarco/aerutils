; Colarco, May 2014
; Read in possibly multiple model monthly mean instances and plot time
; series comparisons to AERONET sites.  Supports for multiple years. 

; If single model expid is plotted you get the model mean values and
; standard deviation.  If multiple models are plotted you get lines of
; just the mean values.  Statistics are plotted for the first model in
; the array.

!quiet=0L
; expid is an array of experiment ID names that have files already
; existing in output/mon_mean and output/histogram
  expid = ['c48R_G40b11_0209'] + '.inst2d_hwl.aeronet'
  colors = [0, 75, 176, 254, 75, 176, 254]
  lins   = [0,  0,   0,   0,  2,   2,   2]
  nexpid = n_elements(expid)
  years = ['2003','2004','2005','2006','2007']
  color = 1   ; 1 if I want color output, else 0 for gray scale
  nmon = 3    ; number of months minimum to plot the site

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

; Get the first model
  iexpid = 0
  read_mon_mean, expid[0], years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation

  read_histogram, expid[0], years, location, latitude, longitude, $
                  taumin, taumax, angmin, angmax, $
                  aotbin_aer, angbin_aer, aotbin_mod, angbin_mod, $
                  absbin_aer, absbin_mod, absmin, absmax, $
                  elevation=elevation

; Handle inputs for multiple models
  if(nexpid gt 1) then begin
   for iexpid = 1, nexpid-1 do begin
      read_mon_mean, expid[iexpid], years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel_, angmodel_, $
                 aotaeronetstd, angaeronetstd, aotmodelstd_, angmodelstd_, $
                 aotabsaeronet, aotabsmodel_, $
                 aotabsaeronetstd, aotabsmodelstd_, $
                 elevation=elevation

      read_histogram, expid[iexpid], years, location, latitude, longitude, $
                  taumin, taumax, angmin, angmax, $
                  aotbin_aer, angbin_aer, aotbin_mod_, angbin_mod_, $
                  absbin_aer, absbin_mod_, absmin, absmax, $
                  elevation=elevation
      aotmodel = [aotmodel,aotmodel_]
      angmodel = [angmodel,angmodel_]
      aotmodelstd = [aotmodelstd,aotmodelstd_]
      angmodelstd = [angmodelstd,angmodelstd_]
      aotabsmodel = [aotabsmodel,aotabsmodel_]
      aotabsmodelstd = [aotabsmodelstd,aotabsmodelstd_]
      aotbin_mod = [aotbin_mod,aotbin_mod_]
      angbin_mod = [angbin_mod,angbin_mod_]
      absbin_mod = [absbin_mod,absbin_mod_]
   endfor
  endif
  aotmodel = reform(aotmodel,n_elements(date),nexpid,n_elements(location))
  angmodel = reform(angmodel,n_elements(date),nexpid,n_elements(location))
  aotmodelstd = reform(aotmodelstd,n_elements(date),nexpid,n_elements(location))
  angmodelstd = reform(angmodelstd,n_elements(date),nexpid,n_elements(location))
  aotabsmodel = reform(aotabsmodel,n_elements(date),nexpid,n_elements(location))
  aotabsmodelstd = reform(aotabsmodelstd,n_elements(date),nexpid,n_elements(location))
  nbinaot = n_elements(taumin)
  nbinang = n_elements(angmin)
  aotbin_mod = reform(aotbin_mod,n_elements(location),nexpid,nbinaot)
  angbin_mod = reform(angbin_mod,n_elements(location),nexpid,nbinang)
  absbin_mod = reform(absbin_mod,n_elements(location),nexpid,nbinaot)

; make a table to hold the statistics of each site
; variables are number, correlation coefficient, bias, rms, skill,
; slope and offset, first for aot then for angstrom
  stattable = make_array(7,3,n_elements(location),val=-9999.)

  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  filename = './output/plots/aeronet_site_monmean.multiple.'+expid[0]+'.'+yearstr+'.ps'
  device, file=filename, color=color, /helvetica, font_size=8, $
          xoff=.5, yoff=.5, xsize=20, ysize=17
  !p.font=0


; position the plots
  position = fltarr(4,9)
  position[*,0] = [.07,.72,.4,.95]
  position[*,1] = [.47,.72,.68,.95]
  position[*,2] = [.75,.72,.96,.95]

  position[*,3] = [.07,.4,.4,.63]
  position[*,4] = [.47,.4,.68,.63]
  position[*,5] = [.75,.4,.96,.63]

  position[*,6] = [.07,.08,.4,.31]
  position[*,7] = [.47,.08,.68,.31]
  position[*,8] = [.75,.08,.96,.31]


  nloc = n_elements(location)
  piname = strarr(nloc)
  aerPath = './output/aeronet2nc/'
; Fix the string names to get rid of "_" character
  for iloc = 0, nloc-1 do begin
;  Get the PI name
;   read_aeronet2nc, aerPath, location[iloc], '500', '2000', aotjunk, datejunk, $
;                    /hourly, pi_name=piname_
;   piname_ = string(piname_)
   piname_ = 'Caldor_Buttis'
   a = 0
   while(a[0] ne -1) do begin
    a = strpos(piname_,'_')
    if(a[0] ne -1) then strput, piname_,' ',a
   endwhile
   piname[iloc] = piname_
   a = 0
   loc_ = location[iloc]
   while(a[0] ne -1) do begin
    a = strpos(loc_,'_')
    if(a[0] ne -1) then strput, loc_,' ',a
   endwhile
   location[iloc] = loc_
  endfor
  locuse = make_array(nloc,val=0)

; setup the tick marks on the x-axis of date
; What is the frequency of tick marks desired (in months)
  ntick = n_elements(years)
  nminor = 4
  tickscale = 12
  tickname=replicate(' ', ntick+1)
  tickname_=replicate(' ', ntick+1)
  for it = 0, ntick-1 do begin
   tickname_[it] = strmid(strcompress(string(date[it*12]),/rem),0,4)
  endfor
  nt = n_elements(date)
  xx = indgen(nt)
  xrange=[0,nt]
  xtitle='date'
  if(n_elements(years) eq 1) then begin
   ntick=13
   nt = 12
   xx = indgen(nt)+1
   xrange=[0,nt+1]
   nminor=1
   tickscale=1
   tickname=replicate(' ', ntick+1)
   tickname_=  [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
   xtitle='year: '+years[0]
  endif

  for iloc = 0, nloc-1 do begin

;  make a plot

;  Criteria to select valid sites
;  For the multi-year comparison, we require two of each mon (J,F,M,A...)
;  to be valid
   siteok = 1
   nyr = n_elements(date)/12
   nreq = 1
   if(nyr ge 3) then nreq = 2  ; require at least two of each month
   for imn = 0, 11 do begin
    a = where(finite(aotaeronet[imn:imn+12*(nyr-1):12,iloc]) eq 1)
    if(a[0] eq -1 or n_elements(a) lt nreq) then siteok = 0
   endfor
   if(location[iloc] eq 'Mauna Loa') then siteok = 0
   if(location[iloc] eq 'Izana') then siteok = 0
;  If doing only one year, just require at least three valid months
   if(nyr eq 1) then begin
    a = where(finite(aotaeronet[*,iloc]) eq 1)
    if(n_elements(a) lt nmon or a[0] eq -1) then siteok = 0
   endif
 
   a = where(finite(aotaeronet[*,iloc]) eq 1)
;   if(n_elements(a) ge nmon) then begin

print, location[iloc], siteok
;goto, jump
   if(siteok) then begin

;  Massage the histogram input
   nobs = total(aotbin_aer[iloc,*])
   ninv = total(absbin_aer[iloc,*])
   faotbin_aer = reform(aotbin_aer[iloc,*])/nobs
   fabsbin_aer = reform(absbin_aer[iloc,*])/ninv
   fangbin_aer = reform(angbin_aer[iloc,*])/nobs
   faotbin_mod = reform(aotbin_mod[iloc,*,*],nexpid,nbinaot)/nobs
   fabsbin_mod = reform(absbin_mod[iloc,*,*],nexpid,nbinaot)/ninv
   fangbin_mod = reform(angbin_mod[iloc,*,*],nexpid,nbinang)/nobs

   locuse[iloc] = 1
;  Find a suitable maximum value
   ymax = max([max(aotaeronet[a,iloc]+aotaeronetstd[a,iloc]),max(aotmodel[a,0,iloc]+aotmodelstd[a,0,iloc])])
   loadct, ct, /silent
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]

   for i = 0, nt-1 do begin
    x = xx[i]
    y = aotaeronet[i,iloc]
    yf = aotaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, xx, aotaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

;  Loop over models
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colors[iexpid]
    plots, xx, aotmodel[*,iexpid,iloc], psym=-8, thick=4, color=colors[iexpid], lin=lins[iexpid]
    for i = 0, nt-1 do begin
     x = xx[i]
     y = aotmodel[i,0,iloc]
     yf = aotmodelstd[i,0,iloc]
     if(finite(y) and nexpid eq 1) then begin
      plots, x, y+[-yf,yf], color=colors[iexpid], noclip=0, thick=2
      plots, x+[-.5,.5], y-yf, color=colors[iexpid], thick=2, noclip=0
      plots, x+[-.5,.5], y+yf, color=colors[iexpid], thick=2, noclip=0
     endif
    endfor
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xtitle=xtitle, ytitle='AOT [550 nm]', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,0]
   for itick = 0, ntick-1 do begin
    xyouts, itick*tickscale, -0.1*ymax, tickname_[itick], align=0
   endfor

   loadct, ct, /silent
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,1], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[iexpid]
    plots, aotaeronet[*,iloc], aotmodel[*,iexpid,iloc], psym=8, color=colors[iexpid]
   endfor

   do_stat = 1
   if(do_stat) then begin
;if(location[iloc] eq 'GSFC') then stop
    a = where(finite(aotaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, aotaeronet[a,iloc], aotmodel[a,0,iloc], $
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
     stattable[0,0,iloc] = n
     stattable[1,0,iloc] = r
     stattable[2,0,iloc] = bias
     stattable[3,0,iloc] = rms
     stattable[4,0,iloc] = skill
     stattable[5,0,iloc] = m
     stattable[6,0,iloc] = b
    endif
   endif


   ymax = max([max(faotbin_aer),max(faotbin_mod)])
   dx = taumax[0]-taumin[0]
   f = where(faotbin_aer gt 0)
   g = where(faotbin_mod[0,*] gt 0)
   xmax = max([taumin[max(f)],taumin[max(g)]])+dx
   nx = n_elements(taumin)
   loadct, ct, /silent
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
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[iexpid]
    plots, taumin[g]+dx/2., faotbin_mod[iexpid,g], psym=-8, color=colors[iexpid]
   endfor
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
   ymax = max([max(angaeronet[a,iloc]+angaeronetstd[a,iloc]),max(angmodel[a,0,iloc]+angmodelstd[a,0,iloc])])
   loadct, ct, /silent
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,3], /noerase
   for i = 0, nt-1 do begin
    x = xx[i]
    y = angaeronet[i,iloc]
    yf = angaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, xx, angaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colors[iexpid]
    plots, xx, angmodel[*,iexpid,iloc], psym=-8, thick=4, color=colors[iexpid], lin=lins[iexpid]
    if(nexpid eq 0) then begin
     for i = 0, nt-1 do begin
      x = xx[i]
      y = angmodel[i,0,iloc]
      yf = angmodelstd[i,0,iloc]
      if(finite(y)) then begin
       plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
       plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
       plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
      endif
     endfor
    endif
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xtitle=xtitle, ytitle='!Ma!3!D440-870!N', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,3]
   for itick = 0, ntick-1 do begin
    xyouts, itick*tickscale, -0.1*ymax, tickname_[itick], align=0
   endfor

   loadct, ct, /silent
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,4], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[iexpid]
    plots, angaeronet[*,iloc], angmodel[*,iexpid,iloc], psym=8
   endfor

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(angaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, angaeronet[a,iloc], angmodel[a,0,iloc], $
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
     stattable[0,1,iloc] = n
     stattable[1,1,iloc] = r
     stattable[2,1,iloc] = bias
     stattable[3,1,iloc] = rms
     stattable[4,1,iloc] = skill
     stattable[5,1,iloc] = m
     stattable[6,1,iloc] = b
    endif
   endif



   ymax = max([max(fangbin_aer),max(fangbin_mod)])
   dx = angmax[0]-angmin[0]
   f = where(fangbin_aer gt 0)
   g = where(fangbin_mod[0,*] gt 0)
   xmin = min([angmin[min(f)],angmin[min(g)]])-dx
   xmax = max([angmin[max(f)],angmin[max(g)]])+dx
   nx = n_elements(angmin)
   loadct, ct, /silent
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
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colors[iexpid]
    plots, angmin[g]+dx/2., fangbin_mod[iexpid,g], psym=-8, color=colors[iexpid]
   endfor
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,5], /noerase, $
         xtitle='Angstrom Exponent', ytitle='fraction', $
         yminor=2, $
         title='PDF of Angstrom Exponent'

; ---------------------
; Absorption



   a = where(finite(aotabsaeronet[*,iloc]) eq 1)
   ymax = max([max(aotabsaeronet[a,iloc]+aotabsaeronetstd[a,iloc]),max(aotabsmodel[a,0,iloc]+aotabsmodelstd[a,0,iloc])])
   if(not(finite(ymax))) then ymax=1
   loadct, ct, /silent
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,6], /noerase
   for i = 0, nt-1 do begin
    x = xx[i]
    y = aotabsaeronet[i,iloc]
    yf = aotabsaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, xx, aotabsaeronet[*,iloc], psym=-8, thick=4, lin=2, color=forcolor
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colors[iexpid]
    plots, xx, aotabsmodel[*,iexpid,iloc], psym=-8, thick=4, color=colors[iexpid], lin=lins[iexpid]
   endfor
   if(nexpid eq 0) then begin
    for i = 0, nt-1 do begin
     x = xx[i]
     y = aotabsmodel[i,iloc]
     yf = aotabsmodelstd[i,iloc]
     if(finite(y)) then begin
      plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
      plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
      plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
     endif
    endfor
   endif
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xtitle=xtitle, ytitle='Absorption AOT [550 nm]', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname, $
    position=position[*,6]
   for itick = 0, ntick-1 do begin
    xyouts, itick*tickscale, -0.1*ymax, tickname_[itick], align=0
   endfor

   loadct, ct, /silent
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,7], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[iexpid]
    plots, aotabsaeronet[*,iloc], aotabsmodel[*,iexpid,iloc], psym=8
   endfor

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(aotabsaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, aotabsaeronet[a,iloc], aotabsmodel[a,0,iloc], $
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
     stattable[0,2,iloc] = n
     stattable[1,2,iloc] = r
     stattable[2,2,iloc] = bias
     stattable[3,2,iloc] = rms
     stattable[4,2,iloc] = skill
     stattable[5,2,iloc] = m
     stattable[6,2,iloc] = b
    endif
   endif



   ymax = max([max(fabsbin_aer),max(fabsbin_mod)])
   dx = absmax[0]-absmin[0]
   f = where(fabsbin_aer gt 0)
   g = where(fabsbin_mod[0,*] gt 0)
   xmin = 0.
   xmax = max([absmax[max(f)],absmax[max(g)]])+dx
   nx = n_elements(absmin)
   loadct, ct, /silent
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $   
         position=position[*,8], /noerase, $
         xtitle='Absorption AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of Absorption AOT'
   for ix = 0, nx-1 do begin
    x0 = absmin[ix]
    x1 = x0+dx
    y0 = 0
    y1 = fabsbin_aer[ix]
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=backcolor, /fill, noclip=0
   endfor
   for iexpid = 0, nexpid-1 do begin
    usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=colors[iexpid]
    plots, absmin[g]+dx/2., fabsbin_mod[iexpid,g], psym=-8, color=colors[iexpid]
   endfor
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,8], /noerase, $
         xtitle='Absorption AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of Absorption AOT'

  endif
jump:

  endfor

; Make a map
  loadct, 0, /silent
  map_set, limit=[-60,-170,70,180], position=[.1,.4,.9,.95]
  map_continents, thick=3
  map_continents, /countries
  map_grid, /box


; Make a table grouped regionally
; First, reduce the tables, values to just locations used
  a = where(locuse gt 0)
  location = location[a]
  used = intarr(n_elements(a))
  piname = piname[a]
  latitude = latitude[a]
  longitude = longitude[a]
  elevation = elevation[a]
  stattable = stattable[*,*,a]

  usersym, 2.*[-1,0,1,0,-1], 2.*[0,-1,0,1,0], color=0, /fill
  plots, longitude, latitude, psym=8


; -------------------------------------
; AOT map
; Make a map
  print, 'AOT Table'
  loadct, 0, /silent
  loadct, 39, /silent
  map_set, limit=[-60,-170,70,180], position=[.1,.4,.9,.95]
  map_continents, thick=3
  map_continents, /countries
  map_grid, /box
  incnum = 1

; Region 0: Coconut Island continental, sorted by longitude west to east
  a = where(longitude lt -135)
  if(a[0] ne -1) then begin
   b = sort(longitude[a])
   for i = 0, n_elements(a)-1 do begin
    iloc = a[b[i]]
    tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
                piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
    incnum = incnum+1
   endfor
  endif

; Region 1: North America, sorted by longitude west to east
  a = where(latitude gt 13 and longitude lt -45 and longitude gt -135)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 2: South America and southern Africa, sorted by longitude west to east
  a = where(latitude lt 0 and longitude lt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 3: Africa and Middle East dust, sorted by longitude west to east
  a = where(latitude lt 35 and latitude gt 0 and longitude lt 60 and longitude gt -45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 4: Europe, sorted by longitude west to east
  a = where(latitude gt 35 and longitude gt -45 and longitude lt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 5: Asia, sorted by longitude west to east
  a = where(latitude gt 22 and longitude gt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 6: Australia and everything else, sorted by longitude west to east
  a = where(latitude lt 22 and longitude gt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Plot the key
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=30    ;color=0
  plots, -120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -120, -72, psym=8
  xyouts, -120, -80, 'b< -0.1', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=80    ;color=80
  plots, -60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -60, -72, psym=8
  xyouts, -60, -80, '-0.1 < b < -0.025', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], /fill, color=255        ;color=120
  plots, 0, -72, psym=8
  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], color=0
  plots, 0, -72, psym=8
  xyouts, 0, -80, '-0.025 < b < 0.025', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=208   ;color=200
  plots,  60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  60, -72, psym=8
  xyouts, 60, -80, '0.025 < b < 0.1', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=254   ;color=255
  plots,  120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  120, -72, psym=8
  xyouts, 120, -80, 'b > 0.1', align=.5, charsize=.8


; -------------------------------------
; Angstrom map
; Make a map
  print, 'Angstrom Table'
  loadct, 0, /silent
  loadct, 39, /silent
  map_set, limit=[-60,-170,70,180], position=[.1,.4,.9,.95]
  map_continents, thick=3
  map_continents, /countries
  map_grid, /box
  incnum = 1

; Region 0: Coconut Island continental, sorted by longitude west to east
  a = where(longitude lt -135)
  if(a[0] ne -1) then begin
   b = sort(longitude[a])
   for i = 0, n_elements(a)-1 do begin
    iloc = a[b[i]]
    tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
                piname[iloc], stattable[*,*,iloc]
    used[iloc] = used[iloc]+1
    incnum = incnum+1
   endfor
  endif

; Region 1: North America, sorted by longitude west to east
  a = where(latitude gt 13 and longitude lt -45 and longitude gt -135)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 2: South America and southern Africa, sorted by longitude west to east
  a = where(latitude lt 0 and longitude lt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 3: Africa and Middle East dust, sorted by longitude west to east
  a = where(latitude lt 35 and latitude gt 0 and longitude lt 60 and longitude gt -45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 4: Europe, sorted by longitude west to east
  a = where(latitude gt 35 and longitude gt -45 and longitude lt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 5: Asia, sorted by longitude west to east
  a = where(latitude gt 22 and longitude gt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Region 6: Australia and everything else, sorted by longitude west to east
  a = where(latitude lt 22 and longitude gt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 1
    used[iloc] = used[iloc]+1
   incnum = incnum+1
  endfor
  endif

; Plot the key
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=30    ;color=0
  plots, -120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -120, -72, psym=8
  xyouts, -120, -80, 'b< -0.3', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=80    ;color=80
  plots, -60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -60, -72, psym=8
  xyouts, -60, -80, '-0.3 < b < -0.1', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], /fill, color=255        ;color=120
  plots, 0, -72, psym=8
  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], color=0
  plots, 0, -72, psym=8
  xyouts, 0, -80, '-0.1 < b < 0.1', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=208   ;color=200
  plots,  60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  60, -72, psym=8
  xyouts, 60, -80, '0.1 < b < 0.3', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=254   ;color=255
  plots,  120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  120, -72, psym=8
  xyouts, 120, -80, 'b > 0.3', align=.5, charsize=.8


; -------------------------------------
; Absorption AOT map
; Make a map
  print, 'Absorption AOT Table'
  loadct, 0, /silent
  loadct, 39, /silent
  map_set, limit=[-60,-170,70,180], position=[.1,.4,.9,.95]
  map_continents, thick=3
  map_continents, /countries
  map_grid, /box
  incnum = 1

; Region 0: Coconut Island continental, sorted by longitude west to east
  a = where(longitude lt -135)
  if(a[0] ne -1) then begin
   b = sort(longitude[a])
   for i = 0, n_elements(a)-1 do begin
    iloc = a[b[i]]
    if(stattable[0,2,iloc] lt 0) then continue
    tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
                piname[iloc], stattable[*,*,iloc], statelem = 2
    used[iloc] = used[iloc]+1
    incnum = incnum+1
   endfor
  endif

; Region 1: North America, sorted by longitude west to east
  a = where(latitude gt 13 and longitude lt -45 and longitude gt -135)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Region 2: South America and southern Africa, sorted by longitude west to east
  a = where(latitude lt 0 and longitude lt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Region 3: Africa and Middle East dust, sorted by longitude west to east
  a = where(latitude lt 35 and latitude gt 0 and longitude lt 60 and longitude gt -45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Region 4: Europe, sorted by longitude west to east
  a = where(latitude gt 35 and longitude gt -45 and longitude lt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Region 5: Asia, sorted by longitude west to east
  a = where(latitude gt 22 and longitude gt 60)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Region 6: Australia and everything else, sorted by longitude west to east
  a = where(latitude lt 22 and longitude gt 45)
  if(a[0] ne -1) then begin
  b = sort(longitude[a])
  for i = 0, n_elements(a)-1 do begin
   iloc = a[b[i]]
   if(stattable[0,2,iloc] gt 0) then $
   tablepoint, incnum, location[iloc], latitude[iloc], longitude[iloc], elevation[iloc], $
               piname[iloc], stattable[*,*,iloc], statelem = 2
   incnum = incnum+1
  endfor
  endif

; Plot the key
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=30    ;color=0
  plots, -120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -120, -72, psym=8
  xyouts, -120, -80, 'b< -0.025', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=80    ;color=80
  plots, -60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
  plots, -60, -72, psym=8
  xyouts, -60, -80, '-0.025 < b < -0.005', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], /fill, color=255        ;color=120
  plots, 0, -72, psym=8
  usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], color=0
  plots, 0, -72, psym=8
  xyouts, 0, -80, '-0.005 < b < 0.005', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=208   ;color=200
  plots,  60, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  60, -72, psym=8
  xyouts, 60, -80, '0.005 < b < 0.025', align=.5, charsize=.8

  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=254   ;color=255
  plots,  120, -72, psym=8
  usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
  plots,  120, -72, psym=8
  xyouts, 120, -80, 'b > 0.025', align=.5, charsize=.8


  device, /close


end


