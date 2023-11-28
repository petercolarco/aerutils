; Colarco, November 29, 2016
; Plot the zonal mean time series of extinction

;  g5v = 'NHL'
;  giv = 'NHh'
;  g5s = 'jan'
;  gis = 'Win_anl'

  pro plot_ext, g5v, giv, g5s, gis

  case g5v of
   'NHL': begin
          locstr = 'Northern Hemisphere High Latitude'
          latr   = [30,90]
          end
   'NML': begin
          locstr = 'Northern Hemisphere Mid Latitude'
          latr   = [30,90]
          end
   'TRO': begin
          locstr = 'Northern Hemisphere Tropics'
          latr   = [-30,30]
          end
   'STR': begin
          locstr = 'Southern Hemisphere Tropics'
          latr   = [-30,30]
          end
   'SML': begin
          locstr = 'Southern Hemisphere Mid Latitude'
          latr   = [-90,-30]
          end
   'SHL': begin
          locstr = 'Southern Hemisphere High Latitude'
          latr   = [-90,-30]
          end
  endcase

  case g5s of
   'jan': begin
          seasstr = 'January'                            & x0 = 1./12.
          end
   'apr': begin
          seasstr = 'April'                              & x0 = 4./12.
          end
   'jul': begin
          seasstr = 'July'                               & x0 = 7./12.
          end
   'oct': begin
          seasstr = 'October'                            & x0 = 10./12.
          end
  endcase

  g5expid = 'VM'+g5v+g5s+['01','02','03','04','05']+'.tavg3d_carma_p.ddf'

  gidir = '/misc/prc20/colarco/volcano/GISS/'
  gictrl = gidir+'VolK_ctrl/taijlVolK_ctrl.2.series.nc'
  giexp  = 'VolK_'+giv+'_'+gis
  gimod  = gidir+giexp+'/taijl'+giexp+'.2.series.nc'

; Get the g5 aot and save area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  nc4readvar, g5expid[0], 'suextcoef', su, time=time, lev=lev
  b = where(su gt 1e14)
  su[b] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(time)

; zonal mean
  su = total(su,1,/nan)/nx

; latitudinal mean
  a = where(lat ge min(latr) and lat le max(latr))
  su = total(su[a,*,*],1,/nan)/n_elements(a)
  g5 = fltarr(nt,nz,5)
  g5[*,*,0] = transpose(su)
  for i = 1, 4 do begin
   nc4readvar, g5expid[i], 'suextcoef', su, time=time
   b = where(su gt 1e14)
   su[b] = !values.f_nan
   su = total(su,1,/nan)/nx
   su = total(su[a,*,*],1,/nan)/n_elements(a)
   g5[*,*,i] = transpose(su)
  endfor

; Get the GEOS-5 climatology and remove
  g5clim = 'VMcontrol'+['01','02','03','04','05']+'.tavg3d_carma_p.ddf'
  nc4readvar, g5clim[0], 'suextcoef', su, time=time
  b = where(su gt 1e14)
  su[b] = !values.f_nan
  su = total(su,1,/nan)/nx
  su = total(su[a,*,*],1,/nan)/n_elements(a)
  g5c = fltarr(nt,nz,5)
  g5c[*,*,0] = transpose(su)
  for j = 1, 4 do begin
   nc4readvar, g5clim[j], 'suextcoef', su, time=time
   b = where(su gt 1e14)
   su[b] = !values.f_nan
   su = total(su,1,/nan)/nx
   su = total(su[a,*,*],1,/nan)/n_elements(a)
   g5c[*,*,j] = transpose(su)
  endfor
  g5 = total(g5-g5c,3,/nan)/5. ; time x lev

; Make zero the small negative extinction which results from
; differencing perturbation from control
  a = where(g5 lt 0)
  if(a[0] ne -1) then g5[a] = 0.

; Get the GISS
  nc4readvar, gictrl, 'aot', ctrl, time=time, lev=levg
  nc4readvar, gictrl, 'z', z, time=time
  nc4readvar, gimod, 'aot', gmod, time=time

  nzg = n_elements(levg)
  ntg = n_elements(time)
  dz = fltarr(nx,ny,nzg,ntg)
  dz[*,*,0:nzg-2,*] = z[*,*,0:nzg-2,*]-z[*,*,1:nzg-1,*]
  dz[*,*,nzg-1,*] = dz[*,*,nzg-2,*]
  aot = total((gmod-ctrl)/dz,1)/nx
  aot = total(aot[a,*,*],1)/n_elements(a)
  aot = transpose(aot[*,0:59])  ; time x levg

  set_plot, 'ps'
  device, file='VM'+g5v+g5s+'.ext.ps', /color, /helvetica, font_size=14, $
   xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  contour, aot, findgen(60)/12., levg, /nodata, $
   yrange=[500,10], ytitle='Pressure [hPa]', ystyle=1, /ylog, $
   xmin=12, xrange=[0,3], xtitle='Years', $
   yticks=2, ytickv=[500,100,10], ytickn=['500','100','10'], $
   title = locstr+' ('+seasstr+')', $
   position=[.12,.2,.95,.92]
  loadct, 33
  contour, /over, g5*1e3, findgen(60)/12., lev, /fill, $
   levels=findgen(51)*.001, c_color=findgen(51)*4+20
  makekey, .12,.05,.83,.04,0,-.035,colors=findgen(51)*4+20, $
   label=['0','0.01','0.02','0.03','0.04','0.05'], /noborder
  loadct, 0
  xyouts, .12, .1, 'Extinction [km!E-1!N]', /normal
  contour, /over, g5*1e3, findgen(60)/12., lev, $
   levels=findgen(5)*.01+.01, c_color=160, c_label=make_array(5,val=1)
  contour, /over, aot*1e3, findgen(60)/12., levg, levels=findgen(5)*.01+.01, $
   c_thick=6, c_color=255, c_label=make_array(5,val=1)
  contour, aot, findgen(60)/12., levg, /nodata, /noerase, $
   yrange=[500,10], ytitle='Pressure [hPa]', ystyle=1, /ylog, $
   xmin=12, xrange=[0,3], xtitle='Years', $
   yticks=2, ytickv=[500,100,10], ytickn=['500','100','10'], $
   title = locstr+' ('+seasstr+')', $
   position=[.12,.2,.95,.92]

  device, /close

end

