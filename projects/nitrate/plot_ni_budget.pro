;  expid = 'bench_i329_gmi_free_c180'
;  expip = 3
;  gf = 0

;  expid = 'c180F_J10p17p1new_uphl0_fs'
;  expip = 11
;  gf = 1

  expid = 'c180R_J10p17p1dev_aura'
  expip = 16
  gf = 1

;  expid = 'c180R_J10p14p1_aura'
;  expip = 16
;  gf = 1

;  expid = 'bench_10-14-1_gmi_free_c180_72lev'
;  expip = 3
;  gf = 1

;expid = 'allaer'
;expip = 11
;gf = 1

;expid = 'ACRI'
;expip = 0
;gf = 0

;expid = 'Icarusr6r6'
;expip = 0
;gf = 0

;;expid = 'c90R_du_Jasper_run1'
;expip = 4
;gf = 0

  set_plot, 'ps'
  device, file='plot_ni_budget.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  xt = 2000.+findgen(241)/12.

  plot, xt, indgen(241), /nodata, xticks=20, $
   yrange=[0,20], xrange=[2000,2020],  $
   position=[.05,.4,.95,.95], xminor=1, xtickn=make_array(21,val=' ')

  loadct, 39

   filetemplate = expid+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   mm       = strmid(nymd,4,2)
   ndaysmon = make_array(n_elements(mm),val=30)
   ndaysmon[where(mm eq '01' or mm eq '03' or mm eq '05' or mm eq '07' or $
                  mm eq '08' or mm eq '10' or mm eq '12')] = 31
   ndaysmon[where(mm eq '02')] = 28
   nc4readvar, filename, 'nicmass', ducmass, lon=lon, lat=lat, time=time
   if(gf) then begin
    nc4readvar, filename, 'nisv', dusv, rc=rc
    if(rc ne 0 and rc ne 4) then begin
     dusv = ducmass
     dusv[*] = 0.
     print, 'no nisv'
    endif else begin
     dusv = -dusv
    endelse
   endif else begin
    nc4readvar, filename, 'nisv0', dusv, /sum, /tem
   endelse
   nc4readvar, filename, 'nisd0', dusd, /sum, /tem
   nc4readvar, filename, 'nidp0', dudp, /sum, /tem
   nc4readvar, filename, 'niwt0', duwt, /sum, /tem
   nc4readvar, filename, 'nh3cmass', nh3cmass, /sum, /tem
   nc4readvar, filename, 'nh4cmass', nh4cmass, /sum, /tem
   nc4readvar, filename, 'niwt0', duwt, /sum, /tem
   nc4readvar, filename, ['nipno3aq','niht001','niht002','niht003'], duem, /sum
   area, lon, lat, nx, ny, dx, dy, area
   dum = aave(ducmass,area)*total(area)/1.e9
   nh3cmass = aave(nh3cmass,area)*total(area)/1.e9
   nh4cmass = aave(nh4cmass,area)*total(area)/1.e9
   dusv = aave(dusv,area)*total(area)/1.e9*ndaysmon*86400
   dusd = aave(dusd,area)*total(area)/1.e9*ndaysmon*86400
   dudp = aave(dudp,area)*total(area)/1.e9*ndaysmon*86400
   duwt = aave(duwt,area)*total(area)/1.e9*ndaysmon*86400
   duem = aave(duem,area)*total(area)/1.e9*ndaysmon*86400
   x = 2000+expip+findgen(n_elements(time))/12.
   oplot, x, duwt+dusv, thick=6, color=84
   oplot, x, dusd+dudp, thick=6, color=208
   oplot, x, duem, thick=6, color=160
   oplot, x, duwt+dusv+dusd+dudp, thick=6, color=254, lin=2

; print the average values
  mloss = mean(duwt+dusv+dusd+dudp,/nan)
  mwet  = mean(duwt+dusv,/nan)
  mdry  = mean(dudp+dusd,/nan)
  memi  = mean(duem,/nan)
  if(expip ge 5) then begin
   xoff1 = min(x)-2
   xoff2 = min(x)-4
  endif else begin
   xoff1 = max(x)+1
   xoff2 = max(x)+3
  endelse
  xyouts, xoff1, memi, string(memi,format='(f6.1)')+' Tg', color=176
  xyouts, xoff1, mwet, string(mwet,format='(f6.1)')+' Tg', color=84
  xyouts, xoff1, mdry, string(mdry,format='(f6.1)')+' Tg', color=208
  xyouts, xoff2, mloss, string(mloss,format='(f6.1)')+' Tg', color=254

  plot, xt, /nodata, xticks=20, /noerase, $
   xtickn=string([xt[0:240:12]],format='(i4)'), $
   yrange=[-0.5,3], xrange=[2000,2020], $
   position=[.05,.05,.95,.4], xminor=1, yticks=7, $
   ytickn=[string((indgen(7)-1)*0.5,format='(f5.2)'),' '], yminor=2
   oplot, x, dum, thick=6
   oplot, x, nh3cmass, thick=6, color=84
   oplot, x, nh4cmass, thick=6, color=176
   tot = duem - (dusd+dudp+duwt+dusv)
;   oplot, x, tot, thick=6, lin=2
; Now plot the assumulated...
  accum = fltarr(n_elements(time))
  accum[0] = tot[0]
  for i = 1, n_elements(time)-1 do begin
   accum[i] = accum[i-1]+tot[i]
endfor
accum = tot
  oplot, x, accum, thick=6, color=254

; plot the average values
  mcm = mean(dum,/nan)
  mac = mean(accum,/nan)
  xyouts, xoff1, mcm, string(mcm,format='(f5.1)')+' Tg'
  xyouts, xoff1, mac, string(mac,format='(f5.1)')+' Tg', color=254



  device, /close

end
