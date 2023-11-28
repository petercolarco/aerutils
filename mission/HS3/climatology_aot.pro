; Colarco
; Read MODIS/MISR/GEOS-5 AOT and produce a climatological plot of
; AOT in various regions

; Get a selection of regions
  getregionsocean, nreg, ymaxwant, maskwant, $
                   lon0want, lon1want, $
                   lat0want, lat1want, $
                   regtitle

  spawn, 'echo ${BASEDIRAER}', basedir
  maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
  maskvar = 'region_mask'
  ga_getvar, maskfile, maskvar, mask, lon=lon, lat=lat
  area, lon, lat, nx, ny, dxx, dyy, area
  q = fltarr(nx,ny,nreg)

; Read the MODIS overocean time series
  nymd0 = '20000115'
  nhms0 = '120000'
  nymd1 = '20101231'
  nhms1 = '120000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, /monthly
  nt = n_elements(nymd)
  regval = make_array(nreg,nt,7,val=!values.f_nan)



; MOD04
  satid = 'MOD04'
  for it = 0, nt-1 do begin
  
   yyyymm = string(nymd[it]/100L,format='(i6)')
   yyyy   = string(nymd[it]/10000L,format='(i4)')
   mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
   fineaot = 1.
   read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d', /old, $
             fineaot=fineaot
   aotsat = reform(aotsat)
   fineaot = reform(fineaot)
   for ireg = 0, nreg-1 do begin
    integrate_region, aotsat, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,0] = varout
    integrate_region, aotsat-fineaot, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,1] = varout
   endfor
print, 'MOD04', yyyymm
  endfor
  mod04  = reform(regval[*,*,0],nreg,12,nt/12)
  mod04c = reform(regval[*,*,1],nreg,12,nt/12)
; discount the first February of record for poor sampling
  mod04[*,1,0]  = !values.f_nan
  mod04c[*,1,0] = !values.f_nan

; MYD04
  satid = 'MYD04'
  for it = 0, nt-1 do begin
  
   yyyymm = string(nymd[it]/100L,format='(i6)')
   yyyy   = string(nymd[it]/10000L,format='(i4)')
   mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
   fineaot = 1.
   read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d', /old, $
             fineaot=fineaot
   aotsat = reform(aotsat)
   fineaot = reform(fineaot)
   for ireg = 0, nreg-1 do begin
    integrate_region, aotsat, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,2] = varout
    integrate_region, aotsat-fineaot, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,3] = varout
   endfor
print, 'MYD04', yyyymm
  endfor
  myd04  = reform(regval[*,*,2],nreg,12,nt/12)
  myd04c = reform(regval[*,*,3],nreg,12,nt/12)

; MISR
  satid = 'MISR'
  for it = 0, nt-1 do begin
  
   yyyymm = string(nymd[it]/100L,format='(i6)')
   yyyy   = string(nymd[it]/10000L,format='(i4)')
   mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
   read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d'
   aotsat = reform(aotsat)
   for ireg = 0, nreg-1 do begin
    integrate_region, aotsat, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,4] = varout
   endfor
print, 'MISR', yyyymm
  endfor
  misr  = reform(regval[*,*,4],nreg,12,nt/12)

; GEOS-5
  satid  = 'MISR'
  expid  = 'dR_Fortuna-2-4-b4'
  ctlocn = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
           expid+'.inst2d_hwl_x.MISR_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  ctllnd = ctlocn
  for it = 84, nt-1 do begin
   yyyymm = string(nymd[it]/100L,format='(i6)')
   yyyy   = string(nymd[it]/10000L,format='(i4)')
   mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
   fileocn = strtemplate(ctlocn,nymd[it],nhms[it],str=expid)
   filelnd = strtemplate(ctllnd,nymd[it],nhms[it],str=expid)
   read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d', $
    ctlmodelocean=fileocn, ctlmodelland=filelnd, /model
   aotsat = reform(total(aotsat,4))
   for ireg = 0, nreg-1 do begin
    integrate_region, aotsat, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg
    regval[ireg,it,5] = varout
   endfor
print, 'GEOS5', yyyymm
  endfor
  geos5  = reform(regval[*,*,5],nreg,12,nt/12)

; GEOS-5 (assimilation)
jump:
  satid  = 'MISR'
  expid  = 'dR_MERRA-AA-r1'
  ctlocn = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
           expid+'.inst2d_hwl_x.MISR_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  ctllnd = ctlocn
  for it = 84, 95 do begin
   yyyymm = string(nymd[it]/100L,format='(i6)')
   yyyy   = string(nymd[it]/10000L,format='(i4)')
   mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
   fileocn = strtemplate(ctlocn,nymd[it],nhms[it],str=expid)
   filelnd = strtemplate(ctllnd,nymd[it],nhms[it],str=expid)
   read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d', $
    ctlmodelocean=fileocn, ctlmodelland=filelnd, /model
   aotsat = reform(total(aotsat,4))
   for ireg = 0, nreg-1 do begin
    integrate_region, aotsat, lon, lat, mask, maskwant[ireg], $
                      lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], varout, /avg, $
                      q=qback
    q[*,*,ireg] = qback
    regval[ireg,it,6] = varout
   endfor
print, 'GEOS5a', yyyymm
  endfor
  geos5a  = reform(regval[*,*,6],nreg,12,nt/12)

; Create a climatology plot
  set_plot, 'ps'

  for ireg = 0, nreg -1 do begin

  device, file = './regional_aot.'+strcompress(regtitle[ireg],/rem)+'.ps', $
   /color, /helvetica, font_size=12, xsize=10, xoff=.5, ysize=10, yoff=.5
  !P.font=0
  loadct, 0
  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, [0,13], [0,1], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='AOT', title=regtitle[ireg]
  polymaxmin, indgen(12)+1, reform(mod04[ireg,*,*]), color=0, fillcolor=208, thick=12
  polymaxmin, indgen(12)+1, reform(mod04c[ireg,*,*]), color=0, fillcolor=-1, linestyle=2, thick=12

  loadct, 39
  polymaxmin, indgen(12)+1, reform(myd04[ireg,*,*]), color=254, fillcolor=-1, thick=12
  polymaxmin, indgen(12)+1, reform(myd04c[ireg,*,*]), color=254, fillcolor=-1, linestyle=2, thick=12

  polymaxmin, indgen(12)+1, reform(misr[ireg,*,*]), color=176, fillcolor=-1, thick=12
  polymaxmin, indgen(12)+1, reform(geos5[ireg,*,*]), color=75, fillcolor=-1, thick=12
  polymaxmin, indgen(12)+1, reform(geos5a[ireg,*,*]), color=40, fillcolor=-1, thick=12

  loadct, 0
  map_set, /noerase, position=[.55,.55,.95,.85]
  area, lon, lat, nx, ny, dxx, dyy, area
  plotgrid, q[*,*,ireg], [.1], [160], lon, lat, dxx, dyy
  map_continents, thick=.5

  device, /close

  endfor

end
