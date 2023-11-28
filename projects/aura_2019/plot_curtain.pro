  pro read_trj_profile, expid, date, time, lon, lat, h, rhoa, bc, brc, oc


  cdfid = ncdf_open(expid+'.'+date+'.trj.nc')
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, rhoa
  id = ncdf_varid(cdfid,'BCPHOBIC')
  ncdf_varget, cdfid, id, bcphobic
  id = ncdf_varid(cdfid,'BCPHILIC')
  ncdf_varget, cdfid, id, bcphilic
  id = ncdf_varid(cdfid,'BRCPHOBIC')
  ncdf_varget, cdfid, id, brcphobic
  id = ncdf_varid(cdfid,'BRCPHILIC')
  ncdf_varget, cdfid, id, brcphilic
  id = ncdf_varid(cdfid,'OCPHOBIC')
  ncdf_varget, cdfid, id, ocphobic
  id = ncdf_varid(cdfid,'OCPHILIC')
  ncdf_varget, cdfid, id, ocphilic
  ncdf_close, cdfid
  bc  = transpose(bcphilic+bcphobic)
  brc = transpose(brcphilic+brcphobic)
  oc  = transpose(ocphilic+ocphobic)
  rhoa = transpose(rhoa)
  h = transpose(h)

  end

; ----
  pro read_ext_profile, expid, date, ext, ssa

  cdfid = ncdf_open(expid+'.'+date+'.ext.rh40.nc')
  id = ncdf_varid(cdfid,'ssa')
  ncdf_varget, cdfid, id, ssa
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  ncdf_close, cdfid
  ext = transpose(ext)
  ssa = transpose(ssa)

  end


  date = '20160924'
  expid = 'c180R_v10p21p1_aura_t6p0_phil_bb'

  read_trj_profile, expid, date, time, lon, lat, h, rhoa, bc, brc, oc
  read_ext_profile, expid, date, ext, ssa


  set_plot, 'ps'
  device, file='plot_curtain.'+expid+'.'+date+'.ssa.ps', /color, $
    xsize=24, ysize=16
  !p.font=0

  loadct, 39
  contour, ssa, time, reform(h[0,*])/1000., $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   levels=findgen(10)*.02+.8, position=[.1,.2,.95,.95], $
   /fill, c_colors=250-indgen(10)*25
  


device, /close
stop

set_plot, 'ps'
device, file='plot_curtain.'+date+'.ext.ps', /color
!p.font=0

loadct, 39
plot, ssa, h/1000., /nodata, $
 yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
 xrange=[0,200], xtitle='Extinction [532 m, Mm!E-1!N]'
oplot, ext0[*,i]*1e3, h[*,i]/1000, thick=8
oplot, ext1[*,i]*1e3, h[*,i]/1000, thick=8, color=84
oplot, ext2[*,i]*1e3, h[*,i]/1000, thick=8, color=254
oplot, ext3[*,i]*1e3, h[*,i]/1000, thick=8, color=84, lin=2
oplot, ext4[*,i]*1e3, h[*,i]/1000, thick=8, color=254, lin=2

device, /close


set_plot, 'ps'
device, file='plot_curtain.'+date+'.bc.ps', /color
!p.font=0

loadct, 39
plot, ssa0[*,i], h[*,i]/1000., /nodata, $
 yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
 xrange=[0,5], xtitle='Black Carbon [!Mm!3g m!E-3!N]'
oplot, bc0[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8
oplot, bc1[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=84
oplot, bc2[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=254
oplot, bc3[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=84, lin=2
oplot, bc4[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=254, lin=2

device, /close



set_plot, 'ps'
device, file='plot_curtain.'+date+'.oa.ps', /color
!p.font=0

loadct, 39
plot, ssa0[*,i], h[*,i]/1000., /nodata, $
 yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
 xrange=[0,30], xtitle='Organic Aerosol [!Mm!3g m!E-3!N]'
;oplot, brc0[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, lin=2
;oplot, brc1[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=84, lin=2
;oplot, brc2[*,i]*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=254, lin=2
oplot, (oc0[*,i]+brc0[*,i])*rhoa[*,i]*1e9, h[*,i]/1000, thick=8
oplot, (oc1[*,i]+brc1[*,i])*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=84
oplot, (oc2[*,i]+brc2[*,i])*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=254
oplot, (oc3[*,i]+brc3[*,i])*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=84, lin=2
oplot, (oc4[*,i]+brc4[*,i])*rhoa[*,i]*1e9, h[*,i]/1000, thick=8, color=254, lin=2

device, /close


set_plot, 'ps'
device, file='plot_curtain.'+date+'.ratio.ps', /color
!p.font=0

loadct, 39
plot, ssa0[*,i], h[*,i]/1000., /nodata, $
 yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
 xrange=[0,20], xtitle='OA:BC'
;oplot, brc0[*,i]/bc0[*,i], h[*,i]/1000, thick=8, lin=2
;oplot, brc1[*,i]/bc1[*,i], h[*,i]/1000, thick=8, color=84, lin=2
;oplot, brc2[*,i]/bc2[*,i], h[*,i]/1000, thick=8, color=254, lin=2
oplot, (oc0[*,i]+brc0[*,i])/bc0[*,i], h[*,i]/1000, thick=8
oplot, (oc1[*,i]+brc1[*,i])/bc1[*,i], h[*,i]/1000, thick=8, color=84
oplot, (oc2[*,i]+brc2[*,i])/bc2[*,i], h[*,i]/1000, thick=8, color=254
oplot, (oc3[*,i]+brc3[*,i])/bc3[*,i], h[*,i]/1000, thick=8, color=84, lin=2
oplot, (oc4[*,i]+brc4[*,i])/bc4[*,i], h[*,i]/1000, thick=8, color=254, lin=2

device, /close



end
