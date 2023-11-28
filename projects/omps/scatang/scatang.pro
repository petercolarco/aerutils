; Colarco, June 2015
; Open some sample OMPS-LP scattering angle files provided by Matt
; DeLand and plot and interpolate.
; The files are are provided for 4 dates:
;  lp_scattang_y2014m03d23.dat
;  lp_scattang_y2014m06d22.dat
;  lp_scattang_y2014m09d21.dat
;  lp_scattang_y2014m12d21.dat
; The objective is to see if there is any seasonality in scattering
; angle that I can use to adjust the mixing ratios for compatability
; with the OMPS-LP derived ASI.

; Files
  files = ['lp_scattang_y2014m12d21.dat', $
           'lp_scattang_y2014m03d23.dat', $
           'lp_scattang_y2014m06d22.dat', $
           'lp_scattang_y2014m09d21.dat', $
           'lp_scattang_y2014m12d21.dat']

  lat = findgen(121)-60.
  ang = fltarr(121,5)

  for ifile = 0, 4 do begin

   openr, lun, files[ifile], /get
   data = fltarr(2)
   i = 0
   while(not(eof(lun))) do begin
    readf, lun, data
    if(i eq 0) then begin
     lat_ = data[0]
     ang_ = data[1]
    endif else begin
     lat_ = [lat_,data[0]]
     ang_ = [ang_,data[1]]
    endelse
    i = i+1
   endwhile
   free_lun, lun

;  Interpolate to range of -60 to 60 latitude
   iy = interpol(indgen(n_elements(lat_)),lat_,lat)
   ang[*,ifile] = interpolate(ang_, iy)

  endfor
  ang = transpose(ang)

; Now make a contour plot
  set_plot, 'ps'
  device, file='omps_scattering_angle.ps', /color, /helvetica, $
   xoff=.5, yoff=.5
  !p.font=0

  loadct, 66
  levels = findgen(28)*5+25.
  colors = 25+indgen(28)*8
  contour, ang, findgen(5), lat, $
   xrange=[0,4], xstyle=1, xtitle='date', $
   yrange=[-90,90], ystyle=1, ytitle='latitude', $
   /cell, levels=levels, c_colors=colors, $
   title='OMPS scattering angle', $
   yticks=6, xticks=4, $
   xtickname=['Dec','Mar','Jun','Sep','Dec'], $
   position=[.1,.25,.95,.9]
  levstr = string(levels,format='(i3)')
  levstr[1:27:3] = ' '
  levstr[2:27:3] = ' '
  makekey, .15, .1, .75, .05, 0, -.035, align=0, charsize=1, $
   colors=colors, labels=levstr, /noborder
  device, /close

; Now calculate the sulfate aerosol phase function as a function of
; scattering angle
  filedir = './'
  filename = 'optics_SU.v_OMPS.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag, pmoments=pmoments, pback=pback
  angles = levels
  mu     = cos(angles*!dpi/180.d)
  numang = n_elements(mu)
  p11 = dblarr(numang)
; Pick a wavelength and rh
  iLam = 4
  iRH  = 0
  iBin = 0
  pmom11 = reform(pmoments[iLam,iRH,ibin,*,0])
  nmom = n_elements(pmom11)-1
  for iang = 0, numang-1 do begin
   x = mu[iang]
   leg = dblarr(nmom+1)
   leg[0] = 1.d
   leg[1] = x
   for imom = 2, nmom do begin
    leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
   endfor
   for imom = 0, nmom do begin
    p11[iang] = p11[iang] + pmom11[imom]*leg[imom]
   endfor
  endfor

; Now make a similar plot for phase function as function of latitude
; and season
  phase = ang
  for i = 0, n_elements(phase)-1 do begin
    iy = interpol(indgen(n_elements(angles)),angles,ang[i])
    phase[i] = interpolate(p11, iy)
  endfor

; Now make a contour plot
  set_plot, 'ps'
  device, file='omps_phase_function.ps', /color, /helvetica, $
   xoff=.5, yoff=.5
  !p.font=0

  loadct, 66
  levels = alog10(.2) + findgen(25)*(alog10(5.)-alog10(.2))/25.
  colors = 25+indgen(25)*9
  contour, alog10(phase), findgen(5), lat, $
   xrange=[0,4], xstyle=1, xtitle='date', $
   yrange=[-90,90], ystyle=1, ytitle='latitude', $
   /cell, levels=levels, c_colors=colors, $
   title='OMPS sampled sulfate phase function P11', $
   yticks=6, xticks=4, $
   xtickname=['Dec','Mar','Jun','Sep','Dec'], $
   position=[.1,.25,.95,.9]
  levstr = string(10^levels,format='(f4.2)')
  levstr[1:24:3] = ' '
  levstr[2:24:3] = ' '
  makekey, .15, .1, .75, .05, 0, -.035, align=0, charsize=1, $
   colors=colors, labels=levstr, /noborder

  device, /close

; Now show phase function amplitude as a function of season
  for iy = 0, n_elements(lat)-1 do begin
   phase[*,iy] = phase[*,iy]/max(phase[*,iy])
  endfor
  set_plot, 'ps'
  device, file='omps_phase_function_scaled.ps', /color, /helvetica, $
   xoff=.5, yoff=.5
  !p.font=0

  loadct, 66
  levels = alog10(.15) + findgen(25)*(alog10(1.)-alog10(.15))/25.
  colors = 25+indgen(25)*9
  contour, alog10(phase), findgen(5), lat, $
   xrange=[0,4], xstyle=1, xtitle='date', $
   yrange=[-90,90], ystyle=1, ytitle='latitude', $
   /cell, levels=levels, c_colors=colors, $
   title='OMPS sampled sulfate phase function P11 (fractional amplitude)', $
   yticks=6, xticks=4, $
   xtickname=['Dec','Mar','Jun','Sep','Dec'], $
   position=[.1,.25,.95,.9]
  levstr = string(10^levels,format='(f4.2)')
  levstr[1:24:3] = ' '
  levstr[2:24:3] = ' '
  makekey, .15, .1, .75, .05, 0, -.035, align=0, charsize=1, $
   colors=colors, labels=levstr, /noborder
  
  device, /close

; Now let's cook up a mapping to use to scale mixing ratio in model
  phase_ = make_array(5,121)
  phase_[1:4,*] = phase[1:4,*]
  phase_[0,*] = phase[4,*]  ; repeat december
  x = findgen(5)

  phaseo = make_array(12,91,val=1.)
  lato   = findgen(91)*2-90.
   for j = 0, 90 do begin
    iy = interpol(indgen(n_elements(lat)),lat,lato[j])
    if(iy ge 0 and iy le 120) then begin
     for i = 1, 12 do begin
      ix = interpol(indgen(n_elements(x)),x,i/3.)
      phaseo[i-1,j] = interpolate(phase_[*,iy],ix)
     endfor
    endif
  endfor

  set_plot, 'ps'
  device, file='omps_phaseo_function_scaled.ps', /color, /helvetica, $
   xoff=.5, yoff=.5
  !p.font=0

  loadct, 66
  levels = alog10(.15) + findgen(25)*(alog10(1.)-alog10(.15))/25.
  colors = 25+indgen(25)*9
  contour, alog10(phaseo), findgen(12), lato, $
   xrange=[0,11], xstyle=1, xtitle='date', $
   yrange=[-90,90], ystyle=1, ytitle='latitude', $
   /cell, levels=levels, c_colors=colors, $
   title='OMPS sampled sulfate phase function P11 (fractional amplitude, fit)', $
   yticks=6, xticks=11, $
   xtickname=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'], $
   position=[.1,.25,.95,.9]
  levstr = string(10^levels,format='(f4.2)')
  levstr[1:24:3] = ' '
  levstr[2:24:3] = ' '
  makekey, .15, .1, .75, .05, 0, -.035, align=0, charsize=1, $
   colors=colors, labels=levstr, /noborder
  
  device, /close

; Write these output to a file used to modulate
  openw, lun, 'phaseo_amplitude.txt', /get
  printf, lun, transpose(phaseo)  ; tranpose to be latitude (91) x month (12)
  free_lun, lun



end
