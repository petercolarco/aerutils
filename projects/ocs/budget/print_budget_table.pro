; Colarco, June 2010
; For a given expid print & plot various budget components
; Must give a range of years (or at least give the same
; year twice if only one year).
; Use: draft = 1 to print expid on plots

  pro print_budget_table, expidIn, yyyy, vars=vars, carma=carma

  !quiet=1L

;  expid = 'bR_newvolc'
;  vars = ['DIAG','DU','SS','BC','POM','SU']
   if(not(keyword_set(vars))) then vars = ['DU','SS','BC','POM','SU']
;  yyyy = strcompress(string(2000 + indgen(8)),/rem)
;  yyyy = ['2007','2007']
  draft = 1

  ny = n_elements(yyyy)
  ndaysmon = [31,28,31,30,31,30,31,31,30,31,30,31]
  if(ny eq 2) then begin
   if(yyyy[0] ne yyyy[1]) then begin
    ny = fix(yyyy[1])-fix(yyyy[0]) + 1
    yyyy = strpad(fix(yyyy[0])+indgen(ny),1000L)
   endif
  endif
  if(ny eq 1) then begin
   yyyy = [yyyy[0],yyyy[0]]
   ny = 2
  endif
  ndaysmon_ = intarr(13,ny)
  for iy = 0, ny-1 do begin
   ndaysmon_[0:11,iy] = ndaysmon
   if( fix(yyyy[iy]/4) eq (yyyy[iy]/4.)) then ndaysmon_[1,iy] = 29.
   ndaysmon_[12,iy] = total(ndaysmon_[0:11,iy])
  endfor

  for ivar = 0, n_elements(vars)-1 do begin

   expid = expidIn+'.tavg2d_aer_x'
   if(keyword_set(carma)) then expid = expidIn+'.tavg2d_carma_x'
   aertype = vars[ivar]
   print, ''

  pm25 = 0
  case aertype of
  'DIAG':  begin
           str = 'Diagnostics'
           expid = expidIn+'.geosgcm_surf'
           read_diags_table, expid, yyyy, $
                             precipls, precipcu, precipsno, preciptot, t2m, $
                             cldtt, cldlo, cldmd, cldhi
           precipRange = [0,4]
           cloudRange  = [0,1]
           end
   'BC':   begin
           str = 'Black Carbon'
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau
           emisRange = [0,20]
           emisClimRange = [0,2]
           lossRange = [0,12]
           lossClimRange = [0,2]
           burdenRange = [0,1]
           burdenClimRange = [0,1]
           lifetimeRange = [6,12]
           dryLifetimeRange = [20,40]
           dryLifetimeClimRange = [20,60]
           wetLifetimeRange = [10,20]
           wetLifetimeClimRange = [10,20]
           aotRange = [0,.01]
           aotClimRange = [0,.01]
           end
   'POM':  begin
           str = 'Particulate Organic Matter'
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau
           emisRange = [40, 120]
           emisClimRange = [0,15]
           lossRange = [0,120]
           lossClimRange = [0,15]
           burdenRange = [.5,3]
           burdenClimRange = [.5,2.5]
           lifetimeRange = [4,12]
           dryLifetimeRange = [30,50]
           dryLifetimeClimRange = [30,50]
           wetLifetimeRange = [4,12]
           wetLifetimeClimRange = [4,12]
           aotRange = [0,.04]
           aotClimRange = [0,.06]
           end
   'DU':   begin
           str = 'Dust'
           pm25 = 1
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau, burden25=burden25
           emisRange = [1200,3000]
           emisClimRange = [50,300]
           lossRange = [500,3000]
           lossClimRange = [50,300]
           burdenRange = [0,40]
           burdenClimRange = [0,50]
           lifetimeRange = [0,10]
           dryLifetimeRange = [4,10]
           dryLifetimeClimRange = [4,12]
           wetLifetimeRange = [0,20]
           wetLifetimeClimRange = [0,20]
           aotRange = [0,.04]
           aotClimRange = [0,.06]
           end
   'DZ':   begin
           str = 'Dust'
           pm25 = 1
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau, burden25=burden25
           emisRange = [600,1400]
           emisClimRange = [40,120]
           lossRange = [200,1600]
           lossClimRange = [20,160]
           burdenRange = [0,30]
           burdenClimRange = [0,40]
           lifetimeRange = [2,8]
           dryLifetimeRange = [0,10]
           dryLifetimeClimRange = [0,10]
           wetLifetimeRange = [10,30]
           wetLifetimeClimRange = [10,30]
           aotRange = [0,.04]
           aotClimRange = [0,.06]
           end
   'SS':   begin
           str = 'Sea Salt'
           pm25 = 1
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau, burden25=burden25
           emisRange = [2000,5000]
           emisClimRange = [200,500]
           lossRange = [1000,5000]
           lossClimRange = [0,500]
           burdenRange = [0,20]
           burdenClimRange = [0,20]
           lifetimeRange = [0.5,1]
           dryLifetimeRange = [0,2]
           dryLifetimeClimRange = [0,2]
           wetLifetimeRange = [0,4]
           wetLifetimeClimRange = [0,4]
           aotRange = [0,.1]
           aotClimRange = [0,.1]
           end
   'SU':   begin
           str = 'Sulfate'
           read_budget_table, expid, aertype, yyyy, $
                  emis, sed, dep, wet, scav, burden, tau, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms

           emisRange = [2,8]
           emisClimRange = [0,1]
           emisRangeSO2 = [100,200]
           emisClimRangeSO2 = [0,20]
           emisRangeDMS = [0,40]
           emisClimRangeDMS = [0,5]
           pSO4Range = [80,180]
           pSO4ClimRange = [5,15]
           pSO2Range = [0,40]
           pSO2ClimRange = [0,5]
           lossRange = [0,200]
           lossClimRange = [0,20]
           burdenRange = [0,4]
           burdenClimRange = [0,4]
           lifetimeRange = [0,10]
           dryLifetimeRange = [10,100]
           dryLifetimeClimRange = [10,100]
           wetLifetimeRange = [4,16]
           wetLifetimeClimRange = [4,16]
           aotRange = [0,.05]
           aotClimRange = [0,.05]
          end
   'CO':   begin
           vars = ['emis','prod','loss','load']
           end
   'CO2':  begin
           vars = ['emis','load']
           end
  endcase

  print, aertype, expid


  months = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Make a plot, setup for dust now
  set_plot, 'ps'
  device, file='output/plots/print_budget_table.'+expid+'.'+aertype+'.ps', /color, $
   /helvetica, font_size=14, xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0

if(aertype eq 'DIAG') then begin
; Precip - Interannual
  loadct, 39
  plot, yyyy, preciptot[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=precipRange, ystyle=9, ythick=3,ytitle='Precipitation [mm/day]', $
   title = 'Interannual Precipitation'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [84,48,176]
  ix = 0
  ysave = fltarr(ny)
  precip = fltarr(13,ny,3)
  precip[*,*,0] = precipls
  precip[*,*,1] = precipcu
  precip[*,*,2] = precipsno
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = precip[12,iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 2 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+precip[12,iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(precipRange)-min(precipRange))+min(precipRange)
  xyouts, xa, y0, 'Large Scale', color=84, charsize=.75
  xyouts, xb, y0, 'Convective', color=48, charsize=.75
  xyouts, xc, y0, 'Snow', color=176, charsize=.75


; Precip - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=precipRange, ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of Precipitation', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(precip,2)/ny
  colors = [84,48,176]
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 2 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  xyouts, xa, y0, 'Large Scale', color=84, charsize=.75
  xyouts, xb, y0, 'Convective', color=48, charsize=.75
  xyouts, xc, y0, 'Snow', color=176, charsize=.75
  y0 = .95*(max(precipRange)-min(precipRange))+min(precipRange)

; Clouds - Interannual
  loadct, 1
  plot, yyyy, cldtt[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Total Cloud Fraction', $
   title = 'Interannual Total Cloud Fraction'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = cldtt[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

;  if(aertype eq 'SU') then begin
;   print, 'Emissions', total(emis[12,*])/ny, total(emis[12,*])/ny/3, format='(a-30,2(1x,f20.3))'
;  endif else begin
;   print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'
;  endelse

; Clouds - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Total Cloud Fraction', $
   title = 'Monthly Climatology of Total Cloud Fraction', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(cldtt,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Low Clouds - Interannual
  loadct, 1
  plot, yyyy, cldlo[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Low Cloud Fraction', $
   title = 'Interannual Low Cloud Fraction'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = cldlo[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

;  if(aertype eq 'SU') then begin
;   print, 'Emissions', total(emis[12,*])/ny, total(emis[12,*])/ny/3, format='(a-30,2(1x,f20.3))'
;  endif else begin
;   print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'
;  endelse

; Low Clouds - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Low Cloud Fraction', $
   title = 'Monthly Climatology of Low Cloud Fraction', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(cldlo,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Mid Clouds - Interannual
  loadct, 1
  plot, yyyy, cldmd[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Mid Cloud Fraction', $
   title = 'Interannual Mid Cloud Fraction'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = cldmd[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

;  if(aertype eq 'SU') then begin
;   print, 'Emissions', total(emis[12,*])/ny, total(emis[12,*])/ny/3, format='(a-30,2(1x,f20.3))'
;  endif else begin
;   print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'
;  endelse

; Low Clouds - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='Mid Cloud Fraction', $
   title = 'Monthly Climatology of Mid Cloud Fraction', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(cldmd,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; High Clouds - Interannual
  loadct, 1
  plot, yyyy, cldhi[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='High Cloud Fraction', $
   title = 'Interannual High Cloud Fraction'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = cldhi[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

;  if(aertype eq 'SU') then begin
;   print, 'Emissions', total(emis[12,*])/ny, total(emis[12,*])/ny/3, format='(a-30,2(1x,f20.3))'
;  endif else begin
;   print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'
;  endelse

; High Clouds - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=cloudRange, ystyle=9, ythick=3,ytitle='High Cloud Fraction', $
   title = 'Monthly Climatology of High Cloud Fraction', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(cldhi,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

endif else begin
; Aerosols

; Emissions - Interannual
  loadct, 3
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=emisRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual '+Str+' Emissions'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = emis[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  if(aertype eq 'SU') then begin
   print, 'Emissions', total(emis[12,*])/ny, total(emis[12,*])/ny/3, format='(a-30,2(1x,f20.3))'
  endif else begin
   print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'
  endelse

; Emissions - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=emisClimRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of '+str+' Emissions', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(emis,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


if(aertype eq 'SU') then begin

; Emissions (SO2) - Interannual
  loadct, 3
  plot, yyyy, emisso2[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=emisRangeSO2, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual SO2 Emissions'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = emisso2[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  print, 'Emissions (SO2)', total(emisso2[12,*])/ny, total(emisso2[12,*])/ny/2., format='(a-30,2(1x,f20.3))'

; Emissions (SO2) - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=emisClimRangeSO2, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of SO2 Emissions', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(emisso2,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Emissions (DMS) - Interannual
  loadct, 3
  plot, yyyy, emisdms[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=emisRangeDMS, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual DMS Emissions'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = emisdms[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  print, 'Emissions (DMS)', total(emisdms[12,*])/ny, total(emisdms[12,*])/ny/(62./32.), format='(a-30,2(1x,f20.3))'

; Emissions (DMS) - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=emisClimRangeDMS, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of DMS Emissions', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(emisdms,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Production (SO4) - Interannual
  loadct, 3
  plot, yyyy, emisdms[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=pSO4Range, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual SO4 Chemical Production'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = pso4liq[12,iy]+pso4g[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  loadct, 39
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = pso4liq[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=80, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  print, 'Production (SO4)', total(pso4liq[12,*]+pso4g[12,*])/ny, $
                             total(pso4liq[12,*]+pso4g[12,*])/ny/3., format='(a-30,2(1x,f20.3))'

; Production (SO4) - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=pSO4ClimRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of SO4 Chemical Production', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(pSO4liq+pso4g,2)/ny
  loadct, 3
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  loadct, 39
  aveinput = total(pSO4liq,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=80, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Production (SO2) - Interannual
  loadct, 3
  plot, yyyy, emisdms[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=pSO2Range, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual SO2 Chemical Production'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = pso2[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  print, 'Production (SO2)', total(pso2[12,*])/ny, $
                             total(pso2[12,*])/ny/2., format='(a-30,2(1x,f20.3))'

; Production (SO2) - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=pSO2ClimRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of SO2 Chemical Production', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(pSO2,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

endif

; Losses - interannual
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lossRange, ystyle=9, ythick=3,ytitle='Losses [Tg/year]', $
   title = 'Interannual '+str+' Losses'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  loss = fltarr(13,ny,4)
  loss[*,*,0] = sed
  loss[*,*,1] = dep
  loss[*,*,2] = wet
  loss[*,*,3] = scav
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = loss[12,iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+loss[12,iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossRange)-min(lossRange))+min(lossRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75

  if(aertype eq 'SU') then begin
   print, 'Losses', total(loss[12,*,*])/ny, total(loss[12,*,*])/ny/3., format='(a-30,2(1x,f20.3))'
   print, '-Dry', total(loss[12,*,0:1])/ny, total(loss[12,*,0:1])/ny/3., format='(a-30,2(1x,f20.3))'
   print, '-Wet', total(loss[12,*,2:3])/ny, total(loss[12,*,2:3])/ny/3., format='(a-30,2(1x,f20.3))'
  endif else begin
   print, 'Losses', total(loss[12,*,*])/ny, format='(a-30,1x,f20.3)'
   print, '-Dry', total(loss[12,*,0:1])/ny, format='(a-30,1x,f20.3)'
   print, '-Wet', total(loss[12,*,2:3])/ny, format='(a-30,1x,f20.3)'
  endelse

; Losses - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lossClimRange, ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of '+str+' Losses', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(loss,2)/ny
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossClimRange)-min(lossClimRange))+min(lossClimRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75


; Burdens
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=burdenRange, ystyle=9, ythick=3,ytitle='Annual Average Burden [Tg]', $
   title = 'Interannual '+str+' Burden'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,254]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = burden[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  if(pm25) then begin
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = burden25[12,iy]
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[1], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  endif
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  y0 = .95*(max(burdenRange)-min(burdenRange))+min(burdenRange)
  xyouts, xa, y0, 'Total '+str+'', color=208, charsize=.75
  if(pm25) then xyouts, xb, y0, 'PM2.5', color=254, charsize=.75

  if(aertype eq 'SU') then begin
   print, 'Burden', total(burden[12,*])/ny, total(burden[12,*])/ny/3., format='(a-30,2(1x,f20.3))'
  endif else begin
   print, 'Burden', total(burden[12,*])/ny, format='(a-30,1x,f20.3)'
  endelse

; Burden - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=burdenClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Burden [Tg]', $
   title = 'Monthly Climatology of '+str+' Burden', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = total(burden[iy,*])/ny
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  if(pm25) then begin
  for iy = 0,11 do begin
   x = iy+.5
   y = total(burden25[iy,*])/ny
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[1], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  endif
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  y0 = .95*(max(burdenClimRange)-min(burdenClimRange))+min(burdenClimRange)
  xyouts, xa, y0, 'Total '+str+'', color=208, charsize=.75
  if(pm25) then xyouts, xb, y0, 'PM2.5', color=254, charsize=.75


; Lifetime
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Lifetime [days]', $
   title = 'Interannual '+str+' Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden/(total(loss,3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, 'Lifetime [days]', total(lifetime[12,*])/ny, format='(a-30,1x,f20.3)'

; Lifetime - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lifetimeRange, ystyle=9, ythick=3,ytitle='Monthly Average Lifetime [Days]', $
   title = 'Monthly Climatology of '+str+' Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; Wet Lifetime
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=wetLifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Wet Lifetime [days]', $
   title = ''+str+' Wet Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,2:3],3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, '-Wet Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'

; Wet Lifetime - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=wetLifetimeClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Wet Lifetime [Days]', $
   title = 'Monthly Climatology of '+str+' Wet Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; Dry Lifetime
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=dryLifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Dry Lifetime [days]', $
   title = ''+str+' Dry Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,0:1],3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, '-Dry Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,0]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -Settling Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,1]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -DryDep Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'

; Dry Lifetime - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=dryLifetimeClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Dry Lifetime [Days]', $
   title = 'Monthly Climatology of '+str+' Dry Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,0:1],3)/ndaysmon_))
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; AOT
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=aotRange, ystyle=9, ythick=3,ytitle='Annual Average AOT [550 nm]', $
   title = 'Interannual '+str+' AOT'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = total(tau[0:11,iy])/12.
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; AOT - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=aotClimRange, ystyle=9, ythick=3,ytitle='AOT [550 nm]', $
   title = 'Monthly Climatology of '+str+' AOT', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(tau,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


  print, 'AOT', mean(tau[0:11,*]), format='(a-30,1x,f20.3)'
endelse

  device, /close


  endfor

end
