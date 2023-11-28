; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  lons = ['-20','-40','-60','-80']
  lons = reverse(lons)

  expid = ['c48_aG40-base-v1',$      ; no forcing
           'c48F_aG40-base-v1', $    ; OPAC-Spheres
           'c48F_aG40-base-v11', $    ; OPAC-Spheroids
           'c48F_aG40-base-v15', $   ; OBS-Spheroids
           'c48F_aG40-kok-v15']      ; OBS-Spheroids/Kok

  nexpid = n_elements(expid)
  colorarray=[0, 254,254,208,84]
  linarray  =[0, 0,  2,  0,  0]

  varwant = [ 'totexttau']

  set_plot, 'ps'
  device, file=expid[0]+'.JJA.aot_lat.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=24, ysize=20, /encap
  !p.font=0
  !p.multi=[0,2,2]


  for ilon = 0, 3 do begin


  wantlat = lons[ilon]

  scale = 1.
  if(abs(fix(wantlat)) gt 50) then scale = .5

  !p.font=0
  loadct, 39
  plot, indgen(10), /nodata, $
        title = 'AOT at '+strpad(abs(fix(wantlat)),10)+'!Eo!N W', $
        yrange=[0,1*scale], xrange=[-10,60], xstyle=9, ystyle=9, $
        xtitle='latitude', ytitle = 'AOT', xthick=3, ythick=3

  if(wantlat eq '-20') then begin
   plots, [35,41], .9*scale, thick=6
   plots, [35,41], .82*scale, thick=6, color=254
   plots, [35,41], .74*scale, thick=6, color=254, lin=2
   plots, [35,41], .66*scale, thick=6, color=208
   plots, [35,41], .58*scale, thick=6, color=84
   xyouts, 43, .88*scale, 'No Forcing', charsize=.9
   xyouts, 43, .8*scale, 'OPAC Spheres', charsize=.9
   xyouts, 43, .72*scale, 'OPAC Spheroids', charsize=.9
   xyouts, 43, .64*scale, 'OBS Spheroids', charsize=.9
   xyouts, 43, .56*scale, 'OBS Spheroids/Kok', charsize=.9
  endif


  loadct, 39

  for iexpid = 0, nexpid-1 do begin

   filetemplate = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.JJA.nc4'
   filename = strtemplate(filetemplate,nymd,nhms)
   nc4readvar, filename, varwant, aot, lon=lon, lat=lat, lev=lev, rc=rc

   i = where(lon eq fix(wantlat))

   oplot, lat, aot[i,*], color=colorarray[iexpid], lin=linarray[iexpid], thick=9

  endfor

; Now put the MODIS field on here
  read_modis, aotsat, lon, lat, '2007', '07', satid='MYD04', res='b', /old, season='JJA'
  aotsat = reform(aotsat)
  loadct, 0
  oplot, lat, aotsat[i,*], color=200, thick=9

  if(wantlat eq '-20') then begin
   plots, [-6,0], .9*scale, thick=6, color=200
   xyouts, 2, .88*scale, 'MODIS Aqua', charsize=.9
  endif


  endfor

  device, /close

end
