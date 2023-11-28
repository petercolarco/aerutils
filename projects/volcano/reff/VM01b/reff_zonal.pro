; Restore the already computed effective zonal mean radius
  restore, 'compute_reff_zonal.sav'

; Screen for low sulfate
  a = where(suext lt 0.01)
  reff[a] = !values.f_nan

  lat = findgen(91)*2.-90.

  expid = strarr(nf)
  for i = 0, nf-1 do begin
   str = strsplit(ddflist[i],'.',/extract)
   expid[i] = str[0]
  endfor

; Get an atmospheric profile
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

  x = findgen(nt)*(1./12.)
  colors = 25. + findgen(9)*25

; Now make a series of plots, one for each eruption/season at each of
; 5 latitudes (+/- 2 points)
  for ilat = 0, 4 do begin
   wantlat = 60. - ilat*30.
   latstr = strcompress(string(abs(wantlat),format='(i2)'),/rem)
   if(wantlat eq 0.) then latstr = '0'+latstr
   if(wantlat lt 0) then latstr = latstr+'S'
   if(wantlat ge 0) then latstr = latstr+'N'
   a = where(lat eq wantlat)
   a = a[0]+[-2,-1,0,1,2]

   for iexpid = 0, nf-1 do begin
    reff_ = transpose(reform(total(reff[a,*,*,iexpid],1)/5.))*1e6  ; um
    set_plot, 'ps'
    device, file='reff_zonal.'+expid[iexpid]+'.'+latstr+'.ps', /color, /helvetica, font_size=11, $
     xoff=.5, yoff=.5, xsize=16, ysize=8
    !p.font=0
    loadct, 0
    plot, indgen(100), /nodata, $
          position=[.15,.25,.95,.9], $
          ytitle='Altitude [km]', $
          xrange=[0,nt/12], yrange=[10,45], xstyle=9, ystyle=9, $
          xticks=nt/12, xminor=2
    loadct, 56
    levels = [.1,.15,.2,.25,.3,.4,.5,.75,1]
    plotgrid, reff_, levels, colors, x, z, 1./12., delz
    loadct, 0
    plot, indgen(100), /nodata, noerase=1, $
          position=[.15,.25,.95,.9], $
          xrange=[0,nt/12], yrange=[10,45], xstyle=9, ystyle=9, $
          xticks=nt/12, xminor=2

    xyouts, .15, .92, expid[iexpid]+' '+latstr, /normal
    xyouts, .15, .12, 'Effective Radius [!9m!3m]', /normal
    makekey, .15, .06, .8, .05, 0., -.05, align=0, $
             color=colors, labels=string(levels,format='(f5.2)')
    loadct, 56
    makekey, .15, .06, .8, .05, 0., -.05, align=0, $
             color=colors, labels=make_array(9,val='')

    device, /close

   endfor
  endfor

end
