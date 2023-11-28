  pro plotit, rh, ext, cmass, ssa, gasym, tau, max, name, channel
; Where extinction gt 0.01
  a = where(ext gt 0.01 and rh lt 0.1)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=max,nbins=61)
  b = where(pdf eq max(pdf))
  print, name+' '+channel+', bext =', x[b[0]]
  plot, x, pdf, title=name+' - bext (black), bsca (red) [m!E2!Ng!E-1!N]', $
   xrange=[0,max]
  b = where(pdf eq max(pdf))
  pdf = histogram(bsca,loc=x, max=max,nbins=61)
  print, name+' '+channel+', bsca =', x[b[0]]
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=0.5, max=1,nbins=51)
  b = where(pdf eq max(pdf))
  print, name+' '+channel+', asym =', x[b[0]]
  plot, x, pdf, title=name+' - asymmetry parameter', xrange=[.5,1]
  print, ' '
  end


; Set up a plot
  set_plot, 'ps'
  device, filename = 'properties.rh00.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=20
  !p.font=0
  loadct, 39
  !p.multi = [0,2,4]

; Get the RH
  nc4readvar, 'MERRA2_400.inst3_3d_aer_Nv.20150815.nc4', 'rh', rh

; Get the 354 nm properties

; Dust
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.dust'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 1.2
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Dust', '354'

; Sea salt
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.ss'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 1.2
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Sea Salt', '354'

; Sulfate
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.su'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 10
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Sulfate', '354'

; Carbon
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.cc'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 10
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Smoke', '354'

  xyouts, .3, .95, '354 nm', /normal, charsize=1






; Get the 388 nm properties

; Dust
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.dust'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 1.2
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Dust', '388'

; Sea salt
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.ss'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 1.2
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Sea Salt', '388'

; Sulfate
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.su'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 10
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Sulfate', '388'

; Carbon
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.cc'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym
  max = 10
  plotit, rh, ext, cmass, ssa, gasym, tau, max, 'Smoke', '388'

  xyouts, .3, .95, '388 nm', /normal, charsize=1

  device, /close

end
