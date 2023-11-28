; Plot the absorbing aerosol optical depth angstrom exponent (AAE) for
; various model run optics versions
  ver = 'v7_5'
  filedir = '/misc/prc20/colarco/MERRA2/inst2d_aer_x/'+ver+'/'
  filen = filedir+'MERRA2_300.taod_Nc.20070601_1200z.nc4'
  vars = ['du001','du002','du003','du004','du005',$
          'ss001','ss002','ss003','ss004','ss005',$
          'ocphobic','ocphilic','bcphobic','bcphilic','so4']
; BCOC = just bc/oc tracers
  nc4readvar, filen, vars, aod, lon=lon, lat=lat, lev=lev, /sum
  aod = aod[*,*,1]

  set_plot, 'ps'
  device, file='aod.'+ver+'.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 43

  levels = findgen(8)*.25
  colors = [208,16,0,48,64,144,160,112]

  p0 = 0
  p1 = 0

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase
  contour, aod, lon, lat, /over, /cell, lev=levels, c_color=colors
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  labels = ['0','0.25','0.5','0.75','1','1.25','1.5','1.75']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=colors, $
           labels=labels, /noborder

  device, /close

end
