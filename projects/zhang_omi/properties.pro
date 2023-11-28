; Set up a plot
  set_plot, 'ps'
  device, filename = 'properties.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=20
  !p.font=0
  loadct, 39
  !p.multi = [0,2,4]

; Get the 354 nm properties

; Dust
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.dust'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=1.2,nbins=61)
  plot, x, pdf, title='Dust - bext (black), bsca (red) [m!E2!Ng!E-1!N]', yrange=[0,3e5]
  pdf = histogram(bsca,loc=x, max=1.2,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Dust - asymmetry parameter'

; Sea salt
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.ss'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=2.4,nbins=61)
  plot, x, pdf, title='Sea Salt - bext (black), bsca (red) [m!E2!Ng!E-1!N]'
  pdf = histogram(bsca,loc=x, max=2.4,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Sea Salt - asymmetry parameter'

; Sulfate
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.su'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=24,nbins=61)
  plot, x, pdf, title='Sulfate - bext (black), bsca (red) [m!E2!Ng!E-1!N]'
  pdf = histogram(bsca,loc=x, max=24,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Sulfate - asymmetry parameter'

; Carbon
  filename = 'MERRA2_400.inst3d_ext-354nm_v.20150815.nc4.cc'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=24,nbins=61)
  plot, x, pdf, title='Smoke - bext (black), bsca (red) [m!E2!Ng!E-1!N]'
  pdf = histogram(bsca,loc=x, max=24,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Smoke - asymmetry parameter'

  xyouts, .3, .95, '354 nm', /normal, charsize=1






; Get the 388 nm properties

; Dust
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.dust'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=1.2,nbins=61)
  plot, x, pdf, title='Dust - bext (black), bsca (red) [m!E2!Ng!E-1!N]', yrange=[0,3e5]
  pdf = histogram(bsca,loc=x, max=1.2,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Dust - asymmetry parameter'

; Sea salt
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.ss'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=2.4,nbins=61)
  plot, x, pdf, title='Sea Salt - bext (black), bsca (red) [m!E2!Ng!E-1!N]'
  pdf = histogram(bsca,loc=x, max=2.4,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Sea Salt - asymmetry parameter'

; Sulfate
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.su'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=24,nbins=61)
  plot, x, pdf, title='Sulfate - bext (black), bsca (red) [m!E2!Ng!E-1!N]'
  pdf = histogram(bsca,loc=x, max=24,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Sulfate - asymmetry parameter'

; Carbon
  filename = 'MERRA2_400.inst3d_ext-388nm_v.20150815.nc4.cc'
  nc4readvar, filename, 'extinction', ext
  nc4readvar, filename, 'cmass', cmass
  nc4readvar, filename, 'tau', tau
  nc4readvar, filename, 'ssa', ssa
  nc4readvar, filename, 'gasym', gasym

; Where extinction gt 0.01
  a = where(ext gt 0.01)
  bext = tau[a]/cmass[a]/1000.
  bsca = ssa[a]*tau[a]/cmass[a]/1000.
  pdf = histogram(bext,loc=x, max=24,nbins=61)
  plot, x, pdf, title='Smoke - bext (black), bsca (red) [m!E2!Ng!E-1!N]', yrange=[0,3e5]
  pdf = histogram(bsca,loc=x, max=24,nbins=61)
  oplot, x, pdf, color=254
  pdf = histogram(gasym[a],loc=x, min=.5, max=1,nbins=51)
  plot, x, pdf, title='Smoke - asymmetry parameter'

  xyouts, .3, .95, '388 nm', /normal, charsize=1

  device, /close

end
