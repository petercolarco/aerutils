; This is copied and modified from aeronet_site_monmean.pro

; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!
!quiet=0L
  expid = 'dR_F25b18.inst2d_hwl.aeronet'
;  expid = 'F25b18.inst2d_hwl.aeronet'
;  expid = 'dR_MERRA-AA-r2.inst2d_hwl.aeronet'
;  expid = 'bR_F25b23q.inst2d_hwl.aeronet'
;  expid = 'dR_Fortuna-2-4-b4.inst2d_hwl.aeronet'
;  expid = 'R_QFED_22a1.inst2d_hwl.aeronet'
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
   yearstr = years[0]+'_'+years[n_elements(years)-1]
  endelse


  read_mon_mean, expid, years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation, $
                 aotmodeldu=aotmodeldu, aotmodelss=aotmodelss, $
                 aotmodelcc=aotmodelcc, aotmodelsu=aotmodelsu

  read_histogram, expid, years, location, latitude, longitude, $
                  taumin, taumax, angmin, angmax, $
                  aotbin_aer, angbin_aer, aotbin_mod, angbin_mod, $
                  absbin_aer, absbin_mod, absmin, absmax, $
                  elevation=elevation

; make a table to hold the statistics of each site
; variables are number, correlation coefficient, bias, rms, skill,
; slope and offset, first for aot then for angstrom
  stattable = make_array(7,3,n_elements(location),val=-9999.)

  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  filename = './output/plots/aeronet_site_monmean.comp.'+expid+'.'+yearstr+'.ps'
  device, file=filename, color=color, /helvetica, font_size=12, $
          xoff=.5, yoff=.5, xsize=14, ysize=10
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

;print, location[iloc], siteok
;goto, jump
   if(siteok) then begin

;  Massage the histogram input
   nobs = total(aotbin_aer[iloc,*])
   ninv = total(absbin_aer[iloc,*])
   faotbin_aer = reform(aotbin_aer[iloc,*])/nobs
   fabsbin_aer = reform(absbin_aer[iloc,*])/ninv
   fangbin_aer = reform(angbin_aer[iloc,*])/nobs
   faotbin_mod = reform(aotbin_mod[iloc,*])/nobs
   fabsbin_mod = reform(absbin_mod[iloc,*])/ninv
   fangbin_mod = reform(angbin_mod[iloc,*])/nobs

   locuse[iloc] = 1

;  Find a suitable maximum value
   ymax = 1
   loadct, ct, /silent
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xticks=ntick, xminor=nminor, xtickname=tickname
   aotfrac=fltarr(nt,4)
   for it = 0,nt-1 do begin
    aotfrac[it,0] = aotmodelss[it,iloc]/total(aotmodeldu[it,iloc]+aotmodelss[it,iloc]+aotmodelsu[it,iloc]+aotmodelcc[it,iloc])
    aotfrac[it,1] = aotmodelsu[it,iloc]/total(aotmodeldu[it,iloc]+aotmodelss[it,iloc]+aotmodelsu[it,iloc]+aotmodelcc[it,iloc])
    aotfrac[it,2] = aotmodelcc[it,iloc]/total(aotmodeldu[it,iloc]+aotmodelss[it,iloc]+aotmodelsu[it,iloc]+aotmodelcc[it,iloc])
    aotfrac[it,3] = aotmodeldu[it,iloc]/total(aotmodeldu[it,iloc]+aotmodelss[it,iloc]+aotmodelsu[it,iloc]+aotmodelcc[it,iloc])
   endfor
;  seasalt
   for i = 0, nt-1 do begin
    x = xx[i]
    y0 = 0
    dy = aotfrac[i,0]
    if(finite(dy)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y0+[0,0,dy,dy,0], color=74, noclip=0
   endfor
;  sulfate
   for i = 0, nt-1 do begin
    x = xx[i]
    y0 = aotfrac[i,0]
    dy = aotfrac[i,1]
    if(finite(dy)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y0+[0,0,dy,dy,0], color=176, noclip=0
   endfor
;  carbon
   for i = 0, nt-1 do begin
    x = xx[i]
    y0 = aotfrac[i,0]+aotfrac[i,1]
    dy = aotfrac[i,2]
    if(finite(dy)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y0+[0,0,dy,dy,0], color=254, noclip=0
   endfor
;  dust
   for i = 0, nt-1 do begin
    x = xx[i]
    y0 = aotfrac[i,0]+aotfrac[i,1]+aotfrac[i,2]
    dy = aotfrac[i,3]
    if(finite(dy)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y0+[0,0,dy,dy,0], color=208, noclip=0
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=xrange, $
    xtitle=xtitle, ytitle='Component Fraction AOT', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname
   for itick = 0, ntick-1 do begin
    xyouts, itick*tickscale, -0.06*ymax, tickname_[itick], align=0
   endfor

  endif
jump:

  endfor


  device, /close


end


