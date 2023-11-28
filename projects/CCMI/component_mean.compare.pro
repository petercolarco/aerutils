; Like component_mean, but compare it to a year from another experiment
;  expid = 'bench_i329_gmi_free_c180_132lev'
;  ddf   = expid+'.ddf'
  expid = 'RefD1.tavg2d_aer_x'
  ddf   = expid+'.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename_ = strtemplate(parsectl_dset(ddf),nymd,nhms)

; expids for comparisons
  expid = ['RefD1.tavg2d_aer_x']
  nexpid = n_elements(expid)
  cexpid = [84,254,0,176,176]
  tau_ = fltarr(12,nexpid)
  tau_oc_ = fltarr(12,nexpid)


; Make a plot of the 2010 - 2019 climatology of component aod
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off a date range
  a = where(long(nymd) gt 20150000L and long(nymd) lt 20200000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

; By component
  comp = ['duexttau','suexttau','ocexttau','bcexttau','ssexttau']
  cct  = [65, 63, 61, 0, 49]
  name = ['DUST','SULFATE','ORGANIC CARBON','BLACK CARBON','SEA SALT']

  taut  = 0.
  taut_ = make_array(12,nexpid,val=0.)

  for icomp = 0, 4 do begin

; Get AOT
  print, comp[icomp]
  nc4readvar, filename, comp[icomp], ext, lon=lon, lat=lat

; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau = aave(ext,area,/nan)
  a = where(tau eq 0)
  if(a[0] ne -1) then tau[a] = !values.f_nan
  tau = reform(tau,12,n_elements(tau)/12)
  taut = taut+tau

; Get the compare experiment(s)
  for iexpid = 0, nexpid-1 do begin

   ddf   = expid[iexpid]+'.ctl'
   ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
   filename_ = strtemplate(parsectl_dset(ddf),nymd,nhms)

   if( (expid[iexpid] eq 'c180R_J10p12p3dev_asd.tavg2d_aer_x' or $
        expid[iexpid] eq 'c180R_J10p12p3dev_asd_gk.tavg2d_aer_x' or $
        expid[iexpid] eq 'c180R_J10p12p3dev_asd_vol.tavg2d_aer_x' or $
        expid[iexpid] eq 'c180R_pI33p7.tavg2d_aer_x' or $
        expid[iexpid] eq 'c180R_pI33p9s12_GFED2.tavg2d_aer_x' or $
        expid[iexpid] eq 'cR180_Dev_jasd.tavg2d_aer_x' or $
        expid[iexpid] eq 'cR180_Dev_jasd2017.tavg2d_aer_x' or $
        expid[iexpid] eq 'c180R_pI33p9s12_volc.tavg2d_aer_x') and $
        comp[icomp] eq 'ocexttau') then begin
     nc4readvar, filename_, ['ocexttau'], ext_oc, lon=lon, lat=lat
     nc4readvar, filename_, ['brcexttau'], ext_brc, lon=lon, lat=lat
     ext = ext_oc+ext_brc
     area, lon, lat, nx, ny, dx, dy, area
     tau_oc_[*,iexpid] = aave(ext_oc,area,/nan)
     a = where(tau_oc_ eq 0)
     if(a[0] ne -1) then tau_oc_[a] = !values.f_nan
   endif else begin
     if(expid[iexpid] eq 'RefD1.tavg2d_aer_x' and $
        comp[icomp] eq 'suexttau') then begin
        nc4readvar, filename_, ['suexttau'], ext_oc, lon=lon, lat=lat
        nc4readvar, filename_, ['suexttauvolc'], ext_brc, lon=lon, lat=lat
        ext = ext_oc+ext_brc
     endif else begin
       nc4readvar, filename_, comp[icomp], ext, lon=lon, lat=lat, rc=rc
     endelse
print, rc
   endelse
   area, lon, lat, nx, ny, dx, dy, area
   tau__ = aave(ext,area,/nan)
   a = where(tau__ eq 0)
   if(a[0] ne -1) then tau__[a] = !values.f_nan
   tau__ = reform(tau__,12,n_elements(tau__)/12)
   tau_[*,iexpid] = mean(tau__, dimension=2)
;if(comp[icomp] eq 'suexttau') then print, tau_[*,iexpid]
   a = where(tau_ eq 0)
   if(a[0] ne -1) then tau_[a] = !values.f_nan
   taut_[*,iexpid] = taut_[*,iexpid]+tau_[*,iexpid]

  endfor


; Make a nice plot!
  set_plot, 'ps'
  device, file='component_mean.compare.'+comp[icomp]+'.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=10, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  ymax = 0.08
  if(cct[icomp] eq 0) then ymax=0.01
  plot, findgen(14), /nodata, color=0, $
    xrange=[0,13], yrange=[0,ymax], xstyle=9, ystyle=9, thick=3, $
    ytitle=name[icomp]+' AOT', xticks=13, $
    xtickname=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  loadct, cct[icomp]
  if(cct[icomp] ne 0) then begin
;  MERRA2
   polymaxmin, indgen(12)+1, tau, fillcolor=120, color=255, edgecolor=200
;  Compare experiments
   for iexpid = 0, nexpid-1 do begin
    loadct, 39
    oplot, indgen(12)+1, tau_[*,iexpid], thick=6, color=cexpid[iexpid]
    if( (expid[iexpid] eq 'c180R_J10p12p3dev_asd.tavg2d_aer_x' or $
         expid[iexpid] eq 'c180R_J10p12p3dev_asd_gk.tavg2d_aer_x' or $
         expid[iexpid] eq 'c180R_J10p12p3dev_asd_vol.tavg2d_aer_x' or $
         expid[iexpid] eq 'c180R_pI33p7.tavg2d_aer_x' or $
         expid[iexpid] eq 'c180R_pI33p9s12_GFED2.tavg2d_aer_x' or $
         expid[iexpid] eq 'cR180_Dev_jasd.tavg2d_aer_x' or $
         expid[iexpid] eq 'cR180_Dev_jasd2017.tavg2d_aer_x' or $
         expid[iexpid] eq 'c180R_pI33p9s12_volc.tavg2d_aer_x') and $
         comp[icomp] eq 'ocexttau') then begin
      loadct, 39
      oplot, indgen(12)+1, tau_oc_[*,iexpid], thick=6, color=cexpid[iexpid], lin=2
    endif
    loadct, cct[icomp]
   endfor
  endif else begin
   polymaxmin, indgen(12)+1, tau, fillcolor=120, color=0, edgecolor=50
   for iexpid = 0, nexpid-1 do begin
    loadct, 39
    oplot, indgen(12)+1, tau_[*,iexpid], thick=6, color=cexpid[iexpid]
   endfor
  endelse
 ; if(expid[iexpid] eq 'S2S_ctrlTest') then begin
 ;  if(comp[icomp] eq 'ssexttau') then oplot, indgen(12)+1, tau_/0.875*0.75, thick=6, lin=1, color=255
 ;  if(comp[icomp] eq 'duexttau') then oplot, indgen(12)+1, tau_/0.7*0.5, thick=6, lin=1, color=255
 ; endif
  device, /close

  endfor


; Make a nice plot of total!
  set_plot, 'ps'
  device, file='component_mean.compare.totexttau.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=10, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(14), /nodata, color=0, $
    xrange=[0,13], yrange=[0.1,0.2], xstyle=9, ystyle=9, thick=3, $
    ytitle='TOTAL AOT', xticks=13, $
    xtickname=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  loadct, 65
  polymaxmin, indgen(12)+1, taut, fillcolor=120, color=255, edgecolor=200
  for iexpid = 0, nexpid-1 do begin
   loadct, 39
   oplot, indgen(12)+1, taut_[*,iexpid], thick=6, color=cexpid[iexpid]
  endfor
;  if(expid[iexpid] eq 'S2S_ctrlTest') then begin
;   if(comp[icomp] eq 'ssexttau') then oplot, indgen(12)+1, tau_/0.875*0.75, thick=6, lin=1, color=255
;   if(comp[icomp] eq 'duexttau') then oplot, indgen(12)+1, tau_/0.7*0.5, thick=6, lin=1, color=255
;  endif
  device, /close



end
