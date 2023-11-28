; Make a plot of the time varying zonal mean effective radius versus
; height at a given latitude
  wantlat = 0.1
  expid = 'c48F_G41-pin'
  filetemplate = expid+'.tavg3d_carma_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910100' and nymd le '20010100')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'su0', su, /template, wantlat=wantlat, lat=lat, lon=lon
  nc4readvar, filename, 'airdens', rhoa, wantlat=wantlat
  nc4readvar, filename, 'rh', rh, wantlat=wantlat
  nt = n_elements(filename)
  nx = n_elements(lon)
  nz = 72

; set up dry particle size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3

; Compute reff at each grid cell
  reff = fltarr(nx,nz,nt)
  vtot = fltarr(nx,nz,nt)
  for it = 0, nt-1 do begin
   for iz = 0, nz-1 do begin
    for ix = 0, nx-1 do begin
;    Compute growth factor for grid point RH
     gf  = sulfate_growthfactor(rh[ix,iz,it])
     dr_ = dr*gf
     r_  = r*gf
     dndr_ = su[ix,iz,it,*]/dr_ / (4./3.*!pi*r_^3.*rhop)*rhoa[ix,iz,it]
     vtot[ix,iz,it] = total(r_^3.*dndr_*dr_)
     reff[ix,iz,it] = total(r_^3.*dndr_*dr_) / total(r_^2.*dndr_*dr_)
    endfor
   endfor
  endfor


; Zonal mean -- effective radius is volume weighted
  reff = total(reff*vtot,1) / total(vtot,1)
  su   = reform(total(su,1))/nx

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

  su = transpose(total(su,3)*1e9) ; ug kg-1
  reff = transpose(reff)*1e6      ; effective radius in um

; Screen reff where SU < 0.01 ug kg-1
  a = where(su lt .01)
  reff[a] = -999.

  x = findgen(nt)*(1./12.)
  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='reff_zonal.test.'+expid+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        ytitle='Altitude [km]', $
        xrange=1991+[0,nt/12], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2
  loadct, 56
  levels = [.05,.1,.15,.2,.25,.3,.4,.5,.7]
  plotgrid, reff, levels, colors, 1991+x, z, 1./12., delz
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=1991+[0,nt/12], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2


  xyouts, .15, .12, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
