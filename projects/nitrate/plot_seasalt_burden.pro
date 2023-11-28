  expid = ['c180R_J10p14p1_aura', 'c90F_J10p14p1_GF', $
           'c90R_du_Jasper_run1', 'c90F_J10p14p1', $
           'c90F_J10p14p1_RAS', 'bench_i329_gmi_free_c180', $
           'bench_10-14-1_gmi_free_c180_72lev']

  expip = [16, 11, 4, 11, 11, 2, 4]
  lin   = [0, 0, 2, 0, 0, 2, 2]
  col   = [254, 84, 254, 84, 84, 84, 84]

  set_plot, 'ps'
  device, file='plot_seasalt_burden.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  x = 2000.+findgen(241)/12.

  plot, x, indgen(241), /nodata, xticks=20, $
   xtickn=string([x[0:240:12]],format='(i4)'), $
   yrange=[0,25], xrange=[2000,2020]

  loadct, 39

  for iexpid = 0, 6 do begin
print, expid[iexpid]
   filetemplate = expid[iexpid]+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, 'sscmass', nicmass, lon=lon, lat=lat, time=time
   area, lon, lat, nx, ny, dx, dy, area
   nim = aave(nicmass,area)*total(area)/1.e9
   x = 2000+expip[iexpid]+findgen(n_elements(time))/12.
   oplot, x, nim, lin=lin[iexpid], color=col[iexpid], thick=6

  endfor

  device, /close

end
