;  expid = 'bench_i329_gmi_free_c180'
;  expip = 3
;  gf = 0

  expid = 'c90F_J10p14p1'
  expip = 11
  expid = 'bench_10-14-1_gmi_free_c180_72lev'
  expip = 3
  gf = 1


  set_plot, 'ps'
  device, file='plot_bc_budget.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  xt = 2000.+findgen(241)/12.

  plot, xt, indgen(241), /nodata, xticks=20, $
   yrange=[0,2], xrange=[2000,2020], $
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
   nc4readvar, filename, 'bccmass', bccmass, lon=lon, lat=lat, time=time
   if(gf) then begin
    nc4readvar, filename, 'bcsv', bcsv
    bcsv = -bcsv
   endif else begin
    nc4readvar, filename, 'bcsv0', bcsv, /sum, /tem
   endelse
   nc4readvar, filename, 'bcsd0', bcsd, /sum, /tem, rc=rc
   nc4readvar, filename, 'bcdp0', bcdp, /sum, /tem
   nc4readvar, filename, 'bcwt0', bcwt, /sum, /tem
   nc4readvar, filename, 'bcem0', bcem, /sum, /tem
   area, lon, lat, nx, ny, dx, dy, area
   bcm = aave(bccmass,area)*total(area)/1.e9
   bcsv = aave(bcsv,area)*total(area)/1.e9*ndaysmon*86400
   if(rc eq 0) then begin
    bcsd = aave(bcsd,area)*total(area)/1.e9*ndaysmon*86400
   endif else begin
    bcsd = bcsv
    bcsd[*] = 0.
   endelse
   bcdp = aave(bcdp,area)*total(area)/1.e9*ndaysmon*86400
   bcwt = aave(bcwt,area)*total(area)/1.e9*ndaysmon*86400
   bcem = aave(bcem,area)*total(area)/1.e9*ndaysmon*86400
   x = 2000+expip+findgen(n_elements(time))/12.
   oplot, x, bcwt+bcsv, thick=6, color=84
   oplot, x, bcsd+bcdp, thick=6, color=208
   oplot, x, bcem, thick=6, color=160
   oplot, x, bcwt+bcsv+bcsd+bcdp, thick=6, color=254, lin=2

; print the average values
  mloss = mean(bcwt+bcsv+bcsd+bcdp)
  mwet  = mean(bcwt+bcsv)
  mdry  = mean(bcdp+bcsd)
  memi  = mean(bcem)
  if(expip ge 5) then begin
   xoff1 = min(x)-2
   xoff2 = min(x)-4
  endif else begin
   xoff1 = max(x)+1
   xoff2 = max(x)+3
  endelse
  xyouts, xoff1, memi, string(memi,format='(f5.2)')+' Tg', color=176
  xyouts, xoff1, mwet, string(mwet,format='(f5.2)')+' Tg', color=84
  xyouts, xoff1, mdry, string(mdry,format='(f5.2)')+' Tg', color=208
  xyouts, xoff2, mloss, string(mloss,format='(f5.2)')+' Tg', color=254

  plot, xt, /nodata, xticks=20, /noerase, $
   xtickn=string([xt[0:240:12]],format='(i4)'), $
   yrange=[-.05,.30], xrange=[2000,2020], $
   position=[.05,.05,.95,.4], xminor=1, yticks=7, $
   ytickn=[string((indgen(7)-1)*.05,format='(f5.2)'),' '], yminor=2
   oplot, x, bcm, thick=6
   tot = bcem - (bcsd+bcdp+bcwt+bcsv)
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
  mcm = mean(bcm)
  mac = mean(accum)
  xyouts, xoff1, mcm, string(mcm,format='(f5.2)')+' Tg'
  xyouts, xoff1, mac, string(mac,format='(f5.2)')+' Tg', color=254



  device, /close

end
