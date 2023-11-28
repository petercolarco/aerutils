  dtitle= '200106'
  expid = 'c48F_G41-pin'
  filedir  = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+dtitle+'.nc4'
print, filedir+filename
; set up size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3


; Get the file
  nc4readvar, filedir+filename, 'su0', su, /template
;  nc4readvar, filedir+filename, 'pso4g', pso4g
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'rh', rh
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat, lev=lev
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat

; Compute the effective radius at each grid cell
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  reff = make_array(nx,ny,nz,val=!values.f_nan)
  vtot = make_array(nx,ny,nz,val=!values.f_nan)
  for iz = 0, nz-1 do begin
   for iy = 0, ny-1 do begin
    for ix = 0, nx-1 do begin
;    Threshold on a minimum value of SU
     if(total(su[ix,iy,iz,*])*1e9 gt 0.01) then begin
;     Compute growth factor for grid point RH
      gf  = sulfate_growthfactor(rh[ix,iy,iz])
      dr_ = dr*gf
      r_  = r*gf
      dndr_ = su[ix,iy,iz,*]/dr_ / (4./3.*!pi*r_^3.*rhop)*rhoa[ix,iy,iz]
      vtot[ix,iy,iz] = total(r_^3.*dndr_*dr_)
      reff[ix,iy,iz] = total(r_^3.*dndr_*dr_) / total(r_^2.*dndr_*dr_)
     endif
    endfor
   endfor
  endfor

; Zonal mean -- effective radius is volume weighted
  reff = total(reff*vtot,1,/nan) / total(vtot,1,/nan)*1e6  ; um
  su   = total(reform(total(su,1))/nx,3)*1e9               ; ug kg-1


  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

; Screen reff where SU < 0.01 ug kg-1
  a = where(su lt .01)
  reff[a] = -999.

  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='reff.'+expid+'.'+dtitle+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        title='Effective radius [!9m!3m], mmr [!9m!3g kg!E-1!N]', $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90
  loadct, 56
  levels = [.05,.1,.15,.2,.25,.3,.4,.5,.7]
  plotgrid, reff, levels, colors, lat, z, 2., delz
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90


  xyouts, .15, .12, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')


; Overplot the zonal mean SU mixing ratio
;  loadct, 0
;  contour, su, lat, z, levels=findgen(10)*.2,/over, color=80, c_label=indgen(10)

;  xyouts, .15, .2, dtitle, /normal

  device, /close

end
