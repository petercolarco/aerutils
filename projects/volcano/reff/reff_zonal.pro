; Make a plot of the time varying zonal mean effective radius versus
; height at a given latitude

  pro reff_zonal, g5v, g5s

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

  wantlat = latr
  expid = 'VM'+g5v+g5s
  filetemplate = expid+['01','02','03','04','05']+'.tavg3d_carma_v.ddf'

  for j = 0, 4 do begin
print, j
  ga_times, filetemplate[j], nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'su0', su, /template, wantlat=wantlat, lat=lat, lon=lon, lev=lev
  nc4readvar, filename, 'airdens', rhoa, wantlat=wantlat
  nc4readvar, filename, 'rh', rh, wantlat=wantlat
  nc4readvar, filename, 'suextcoef', suext, wantlat=wantlat
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)

; set up size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3

; Compute the effective radius at each grid cell
  if(j eq 0) then reff = make_array(nx,ny,nz,nt,5,val=!values.f_nan)
  if(j eq 0) then suexto = make_array(nx,ny,nz,nt,5,val=!values.f_nan)
  vtot = make_array(nx,ny,nz,nt,val=!values.f_nan)
  suexto[*,*,*,*,j] = suext*1e6  ; Mm-1
  suext = mean(suext,dim=1)*1e6  ; Mm-1
  for it = 0, nt-1 do begin
  for iz = 0, nz-1 do begin
   for iy = 0, ny-1 do begin
;   Threshold on minimum zonal extinction coefficient
;    if(suext[iy,iz,it] gt 1) then begin
; for background
    if(suext[iy,iz,it] gt 0) then begin
     for ix = 0, nx-1 do begin
;     Compute growth factor for grid point RH
      gf  = sulfate_growthfactor(rh[ix,iy,iz,it])
      dr_ = dr*gf
      r_  = r*gf
      dndr_ = su[ix,iy,iz,it,*]/dr_ / (4./3.*!pi*r^3.*rhop)*rhoa[ix,iy,iz,it]
      vtot[ix,iy,iz,it] = total(r_^3.*dndr_*dr_)
      reff[ix,iy,iz,it,j] = total(r_^3.*dndr_*dr_) / total(r_^2.*dndr_*dr_)
     endfor
    endif
   endfor
  endfor
  endfor

  endfor  ; loop over ensemble

; average ensemble
  reff = mean(reff,dim=5)
  suexto = mean(suexto,dim=5)

; Rest processes on ensemble mean

; Straight zonal mean
  reff = mean(reff,dim=1)*1e6  ; um
  suexto = mean(suexto,dim=1)

; latitude mean
  reff = transpose(reform(total(reff,1)/ny))
  su = transpose(total(su,1)/ny)
  suexto = transpose(reform(total(suexto,1)/ny))


  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

; Screen reff where SU < 0.01 ug kg-1
  a = where(su lt .01)
;  reff[a] = -999.

  x = findgen(nt)*(1./12.)
  colors = 25. + findgen(10)*25
  set_plot, 'ps'
  device, file='reff_zonal.'+expid+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=18, ysize=12
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.12,.2,.95,.92], $
        ytitle='Pressure [hPa]', /ylog, $
        xrange=[0,nt/12.], yrange=[500,10], xstyle=9, ystyle=9, $
        yticks=2, ytickv=[500,100,10], ytickn=['500','100','10'], $
        xtitle='Years', title = locstr+' ('+seasstr+')', $
        xticks=nt/12, xminor=2
  loadct, 56
  levels = [.1,.15,.2,.25,.3,.4,.5,.7,1.,2.]
  plotgrid, reff, levels, colors, x, p/100., 1./12., delp/100.
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.12,.2,.95,.92], /ylog, $
        xrange=[0,nt/12.], yrange=[500,10], xstyle=9, ystyle=9, $
        yticks=2, ytickv=[500,100,10], ytickn=['500','100','10'], $
        xticks=nt/12, xminor=2

  contour, /overplot, suexto/1000., x, p/100., lev=findgen(5)*.01+.01, $
           c_thick=6, c_label = make_array(5,val=1)

  xyouts, .12, .1, 'Effective Radius [!9m!3m]', /normal
  makekey, .12, .05, .83, .04, 0., -.035, align=0, $
           color=colors, labels=string(levels,format='(f5.1)')
  loadct, 56
  makekey, .12, .05, .83, .04, 0., -.035, align=0, $
           color=colors, labels=make_array(10,val='')

  device, /close

end
