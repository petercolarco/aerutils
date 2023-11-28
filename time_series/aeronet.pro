; Colarco, Feb. 2008
; Read in the monthly mean AERONET AOT at a site and make a climatology
; plot, over-plotting the model results.

  location= 'Capo_Verde'
  sitelon = -23.
  sitelat = 16.75
  aerPath = '/output/AERONET/AOT_Version2/'
  yyyy = string(indgen(7)+2000,format='(i4)')

; read in the aeronet aot and angstrom exponents
  angstromaeronetIn = 1.
  angstrommodel = 1.
  read_aeronet2nc, aerPath, location, '550', yyyy, aotAer, dateAer, /monthly
  dateaer = string(dateaer,format='(i8)')

; Discard missing values
  a = where(aotAer eq -9999.)
  if(a[0] ne -1) then aotAer[a] = !values.f_nan

; Now get the model dust and seasalt at this site
  ga_getvar, 'b32dust.chem_diag.sfc.ctl', 'duexttau', duexttau, $
   wantlon=sitelon, wantlat=sitelat, wanttime = ['200001','200612']
  ga_getvar, 'b32dust.chem_diag.sfc.ctl', 'ssexttau', ssexttau, $
   wantlon=sitelon, wantlat=sitelat, wanttime = ['200001','200612']
  aotModel = reform(duexttau+ssexttau)

; Now turn it all into a climatology
  locsave = location
  nloc = n_elements(location)
; Fix the string names to get rid of "_" character
  for iloc = 0, nloc-1 do begin
   a = strpos(location[iloc],'_')
   loc_ = location[iloc]
   if(a[0] ne -1) then strput, loc_,' ',a
   location[iloc] = loc_
  endfor
  locuse = make_array(nloc,val=0)

; Now turn the aeronet and model into climatology
  aotaeronet_clim = fltarr(12,nloc)
  aotaeronetstd_clim = fltarr(12,nloc)
  aotmodel_clim = fltarr(12,nloc)
  aotmodelstd_clim = fltarr(12,nloc)
  for imon = 1, 12 do begin
   a = where(fix(strmid(dateAer,4,2)) eq imon)
   for iloc = 0, nloc-1 do begin
    aotaeronet_clim[imon-1,iloc] = mean(aotAer[a,iloc],/nan)
    aotmodel_clim[imon-1,iloc]   = mean(aotModel[a,iloc],/nan)
    b = where(finite(aotAer[a,iloc]) eq 1)
    if(n_elements(b) ge 3) then begin
     aotaeronetstd_clim[imon-1,iloc] = stddev(aotAer[a,iloc],/nan)
     aotmodelstd_clim[imon-1,iloc] = stddev(aotmodel[a,iloc],/nan)
    endif
   endfor
  endfor


;  Plot
   set_plot, 'ps'
   device, file=locsave+'.ps', /color, /helvetica, font_size=14, $
    xoff = 0.5, yoff=0.5, xsize=16, ysize=12
   !p.font=0   



;  Find a suitable maximum value
   iloc = 0
   nt = 12
   ntick = 13
   nminor = 1
   tickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
   color = 1   ; 1 if I want color output, else 0 for gray scale
 
   if(color) then begin
    backcolor=208
    forcolor = 254
    ct = 39
   endif else begin
    backcolor = 150
    forcolor = 70
    ct = 0
   endelse

   a = where(finite(aotaeronet_clim[*,iloc]) eq 1)
   ymax = max([max(aotaeronet_clim[a,iloc]+aotaeronetstd_clim[a,iloc]), $
               max(aotmodel_clim[a,iloc]+aotmodelstd_clim[a,iloc])])
   loadct, ct
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt+1], $
    xticks=ntick, xminor=nminor, xtickname=tickname
   for i = 0, nt-1 do begin
    x = i+1
    y = aotaeronet_clim[i,iloc]
    yf = aotaeronetstd_clim[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=backcolor, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt)+1, aotaeronet_clim[*,iloc], psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt)+1, aotmodel_clim[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
    y = aotmodel_clim[i,iloc]
    yf = aotmodelstd_clim[i,iloc]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
     plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
    endif
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='AOT [500 nm]', title=location[iloc], $
    xticks=ntick, xminor=nminor, xtickname=tickname


   device, /close


end
