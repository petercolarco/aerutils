; Colarco, November 28, 2016
; Plot the zonal mean time series of AOT

  pro plot_horz_wetdep, g5v, g5s

  case g5v of
   'NHL': begin
          locstr = 'Northern Hemisphere High Latitude'   & lat0 = 63.6
          end
   'NML': begin
          locstr = 'Northern Hemisphere Mid Latitude'    & lat0 = 48.1
          end
   'TRO': begin
          locstr = 'Northern Hemisphere Tropics'         & lat0 = 15.15
          end
   'STR': begin
          locstr = 'Southern Hemisphere Tropics'         & lat0 = -8.35
          end
   'SML': begin
          locstr = 'Southern Hemisphere Mid Latitude'    & lat0 = -45.9
          end
   'SHL': begin
          locstr = 'Southern Hemisphere High Latitude'   & lat0 = -77.5
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

  g5expid = 'VM'+g5v+g5s+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'

; Get the g5 aot and save area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  nc4readvar, g5expid[0], ['susv','suwt'], su, time=time, /sum

  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)
  g5 = fltarr(ny,nt,5)
  g5[*,*,0] = total(su,1)/nx


  for i = 1, 4 do begin
   nc4readvar, g5expid[i], ['susv','suwt'], su, time=time, /sum
   g5[*,*,i] = total(su,1)/nx
  endfor

; Get the GEOS-5 climatology and remove
  g5clim = 'VMcontrol'+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'
  nc4readvar, g5clim[0], ['susv','suwt'], su, time=time, /sum
  g5c = fltarr(ny,nt,5)
  g5c[*,*,0] = total(su,1)/nx
  for j = 1, 4 do begin
   nc4readvar, g5clim[j], ['susv','suwt'], su, time=time, /sum
   g5c[*,*,j] = total(su,1)/nx
  endfor

  g5 = transpose(total(g5-g5c,3)/5.) ; time x lat

; zero out (small) negative AOT from subtracting climatology from
; pertubation
;  a = where(g5 lt 0)
;  if(a[0] ne -1) then g5[a] = 0.

  set_plot, 'ps'
  device, file='VM'+g5v+g5s+'.horz_wetdep.ps', /color, /helvetica, font_size=14, $
   xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  contour, g5, findgen(60)/12., lat, /nodata, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, $
   yticks=6, ytickv=-90+findgen(7)*30, $
   xmin=12, xrange=[0,5], xtitle='Years', $
   title = locstr+' ('+seasstr+')', $
   position=[.1,.25,.95,.92]
  loadct, 70
  levels = findgen(16)*.5e-12 - 4.e-12
  colors = 255 - indgen(16)*16
  contour, /over, g5, findgen(60)/12., lat, /fill, $
   levels=levels, c_color=colors
  makekey, .1,.05,.85,.04,0,-.035,colors=colors, $
   label=['-4','-2','0','2','4'], /noborder
  loadct, 0
  xyouts, .1, .1, 'Wet Deposition [10!E-12!N kg m!E-2!N s!E-1!N]', /normal
  contour, /over, g5, findgen(60)/12., lat, $
   levels=findgen(5)*.1+.1, c_color=160, c_label=make_array(5,val=1)
  contour, g5, findgen(60)/12., lat, /nodata, /noerase, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, $
   yticks=6, ytickv=-90+findgen(7)*30, $
   xmin=12, xrange=[0,5], xtitle='Years', $
   title = locstr+' ('+seasstr+')', $
   position=[.1,.25,.95,.92]

  device, /close

end

