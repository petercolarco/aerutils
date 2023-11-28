  filename = '/misc/prc11/colarco//dCR_Fortuna-2_4-b5p2/inst3d_carma_v/'+$
             '/Y2009/M06/dCR_Fortuna-2_4-b5p2.inst3d_carma_v.20090629_0000z.nc4'

; Get the surface area
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  grav = 9.81

; Set up the CARMA size bins
  nbin = 8
  rmrat = (10.d^3/0.1d^3)^(1.d/nbin)
  rmin = 1.d-7*((1.+rmrat)/2.)^(1.d/3)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  

; Get the dust particle size distribution
  nc4readvar, filename, 'delp', delp
  nc4readvar, filename, 'du', dust, /template
  dmassdust = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   cmass = total(delp*dust[*,*,*,ibin],3)/grav  ; kg m-2
   dmassdust[ibin] = total(area*cmass)/total(area)
  endfor
; normalize
  dmassdust_ = dmassdust
  dmassdust = dmassdust/total(dmassdust)


; Get the sea salt particle size distribution
  nc4readvar, filename, 'ss', seasalt, /template
  dmassss = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   cmass = total(delp*seasalt[*,*,*,ibin],3)/grav  ; kg m-2
   dmassss[ibin] = total(area*cmass)/total(area)
  endfor
; normalize
  dmassss = dmassss/total(dmassss)


; From the model
  dmassdust0 = [0.0009, 0.0081, 0.0234, 0.0676, 0.25, 0.25, 0.25, 0.25]
  dmassdust0 = dmassdust0 / total(dmassdust0)

; Plot the dust
  set_plot, 'ps'
  device, file='carma.ps', /helvetica, font_size=12, $
   xsize=12, ysize=16, xoff=.5, yoff=.5, /color
  !p.font=0
  loadct, 39
  !p.multi=[0,1,2]
  plot, r*1e6, 2.*dmassdust0*r/dr, /nodata, /xlog, $
        xstyle=9, xrange=[.1,10], xtitle = 'radius [um]', $
        ystyle=9, yrange=[0,1.5], ytitle = 'dMass/dln(r) [arbitrary]', $
        thick=3, title='dust'
  oplot, r*1e6, dmassdust0*r/dr, thick=6
  oplot, r*1e6, dmassdust*r/dr, thick=6, color=208
; overplot the sea salt
  nbin = 8
  rmrat = (10.d^3/0.03d^3)^(1.d/nbin)
  rmin = 0.3d-7*((1.+rmrat)/2.)^(1.d/3)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
;  oplot, r*1e6, dmassss*r/dr, thick=6, color=75

; Get the blackcarbon on the dust (the cores)
  nbin = 8
  rmrat = (10.d^3/0.1d^3)^(1.d/nbin)
  rmin = 1.d-7*((1.+rmrat)/2.)^(1.d/3)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  nc4readvar, filename, 'dubc', dubc, /template
  dmassdubc = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   cmass = total(delp*dubc[*,*,*,ibin],3)/grav  ; kg m-2
   dmassdubc[ibin] = total(area*cmass)/total(area)
  endfor
  dmassdubc_ = dmassdubc
  dmassdubc = dmassdubc/total(dmassdubc)
  oplot, r*1e6, dmassdubc*r/dr, thick=6, color=254

  plots, [.12,.18], .9*1.5, thick=6, color=0
  plots, [.12,.18], .8*1.5, thick=6, color=208
  plots, [.12,.18], .7*1.5, thick=6, color=254
;  plots, [.12,.18], .6*1.5, thick=6, color=75
  xyouts, .2, .88*1.5, 'dust (initial PSD)'
  xyouts, .2, .78*1.5, 'dust (global average PSD)'
  xyouts, .2, .68*1.5, 'black carbon mass on dust of size r'
;  xyouts, .2, .58*1.5, 'sea salt (global average dry PSD)'

;;;;;;;;;;;;
; Now do for blackcarbon
  nbin = 8
  rmrat = (10.d^3/0.1d^3)^(1.d/nbin)
  rmin = 5.d-9*((1.+rmrat)/2.)^(1.d/3)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  nc4readvar, filename, 'bc', bc, /template
  dmassbc = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   cmass = total(delp*bc[*,*,*,ibin],3)/grav  ; kg m-2
   dmassbc[ibin] = total(area*cmass)/total(area)
  endfor
  dmassbc_ = dmassbc
  dmassbc = dmassbc/total(dmassbc)

; From the model
  dmassbc0 = [0.0077, 0.0533, 0.1848, 0.3213, 0.2803, 0.1227, 0.0269, 0.0030]
  dmassbc0 = dmassbc0 / total(dmassbc0)

  plot, r*1e6, dmassbc0*r/dr, /nodata, /xlog, $
        xstyle=9, xrange=[.005,0.5], xtitle = 'radius [um]', $
        ystyle=9, yrange=[0,1.5], ytitle = 'dMass/dln(r) [arbitrary]', $
        title = 'black carbon', thick=3
  oplot, r*1e6, dmassbc0*r/dr, thick=6
  oplot, r*1e6, dmassbc*r/dr, thick=6, color=208

  plots, [.006,.01], .9*1.5, thick=6, color=0
  plots, [.006,.01], .8*1.5, thick=6, color=208
  xyouts, .012, .88*1.5, 'black carbon (initial PSD)'
  xyouts, .012, .78*1.5, 'black carbon (global average PSD)'

  device, /close


end
