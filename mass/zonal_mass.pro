; Colarco, May 16, 2007

; Purpose of this routine is to read from chem_diag.sfc files and plot the
; zonal mean of specified aerosol fields.

; Idea is to work on monthly mean files and plot a year of information on
; a single page.

; models
  spawn, 'uname -n', nodename
  split = strsplit(nodename,'.',/extract)
  computer = split[0]
  if(computer eq 'calculon') then begin
   ctlfile = ['t003_c32.chem_diag.clim.sfc.regrid_2x25.ctl', 't002_b55.chem_diag.clim.sfc.ctl', $
              't005_b32.chem_diag.clim.sfc.ctl']
  endif else begin
   dodshost = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-4/Experiments/'
   ctlfile = dodshost + ['t003_c32/diag/t003_c32.chem_diag.sfc.ctl', $
                         't002_b55/diag/t002_b55.chem_diag.sfc.ctl', $
                         't005_b32/diag/t005_b32.chem_diag.sfc.ctl' ]
  endelse
  nmod = n_elements(ctlfile)

; model variables
  title   = ['Dust AOT',    'Particle Organic Matter AOT', 'Black Carbon AOT', $
             'Seasalt AOT', 'Sulfate AOT', $
             'Dust Load [g m!E-2!N]',    'Particle Organic Matter Load [g m!E-2!N]', 'Black Carbon Load [g m!E-2!N]', $
             'Seasalt Load [g m!E-2!N]', 'Sulfate Load [g m!E-2!N]', $
             'Dust Emissions [g m!E-2!N]', 'Particulate Organic Matter Emissions [g m!E-2!N]', $
             'Black Carbon Emissions [g m!E-2!N]', 'Seasalt Emissions [g m!E-2!N]', 'Sulfate Emissions [g m!E-2!N]', $
             'Dust Sedimentation [g m!E-2!N]', 'Dust Deposition [g m!E-2!N]', 'Dust Wet Removal [g m!E-2!N]', 'Dust Scavenging [g m!E-2!N]', $
             'Seasalt Sedimentation [g m!E-2!N]', 'Seasalt Deposition [g m!E-2!N]', 'Seasalt Wet Removal [g m!E-2!N]', 'Seasalt Scavenging [g m!E-2!N]', $
             'Particle Organic Matter Deposition [g m!E-2!N]', 'Particle Organic Matter Wet Removal [g m!E-2!N]', 'Particle Organic Matter Scavenging [g m!E-2!N]', $
             'Black Carbon Deposition [g m!E-2!N]', 'Black Carbon Wet Removal [g m!E-2!N]', 'Black Carbon Scavenging [g m!E-2!N]', $
             'Sulfate Deposition [g m!E-2!N]', 'Sulfate Wet Removal [g m!E-2!N]', 'Sulfate Scavenging [g m!E-2!N]' ]

  title   = title + ' (Climatology years 2000 - 2005)'
  varwant = ['duexttau', 'ocexttau', 'bcexttau', 'ssexttau', 'suexttau', $
             'ducmass',  'occmass',  'bccmass',  'sscmass',  'so4cmass', $
             'duem',     'ocem',     'bcem',     'ssem',     'suem003', $
             'dusd',     'dudp',     'duwt',     'dusv', $
             'sssd',     'ssdp',     'sswt',     'sssv', $
             'ocdp',     'ocwt',     'ocsv', $
             'bcdp',     'bcwt',     'bcsv' ]
  xmax     = [ 0.2, 0.1, 0.03, 0.1, 0.2, $      ; exttau
               0.4, 0.01, 0.002, 0.2, 0.02, $   ; load
               3.,  .3,   .03,    10.,  .02, $; emissions
               1.5,  .2,   .4,    1., $; dust loss
               5.,  1.,   3.,    2.5, $; seasalt loss
               .04,   .04,    .04, $; oc loss
               .005,   .005,    .005               ]; bc loss
  fac = 30*86400*1000.
  scalefac = [ 1., 1., 1., 1., 1., $                ; exttau
               1000., 1000., 1000., 1000., 1000., $ ; load
               fac,   fac,   fac,   fac,   fac, $   ; emissions
               fac,   fac,   fac,   fac,   $        ; dust loss
               fac,   fac,   fac,   fac,   $        ; seasalt loss
               fac,   fac,   fac,   $               ; oc loss
               fac,   fac,   fac ]                  ; bc loss
  nvar = n_elements(varwant)

; year want
  yyyy = ['2112']

  set_plot, 'ps'
  plot_file = './output/plots/geos_fvaer_zonal_mass.ps'
  device, filename=plot_file, /landscape, xoff=.5, yoff=26, $
   xsize=25, ysize=18, /helvetica, font_size=12, /color
  !P.font=0
  position = fltarr(4,3,4)
  position[*,0,0] = [.075,.725,.325,.9]
  position[*,1,0] = [.375,.725,.625,.9]
  position[*,2,0] = [.675,.725,.925,.9]

  position[*,0,1] = [.075,.5,.325,.675]
  position[*,1,1] = [.375,.5,.625,.675]
  position[*,2,1] = [.675,.5,.925,.675]

  position[*,0,2] = [.075,.275,.325,.45]
  position[*,1,2] = [.375,.275,.625,.45]
  position[*,2,2] = [.675,.275,.925,.45]

  position[*,0,3] = [.075,.05,.325,.225]
  position[*,1,3] = [.375,.05,.625,.225]
  position[*,2,3] = [.675,.05,.925,.225]

  position = reform(position,4,12)  

  ctwant = 39
  loadct, ctwant
  colors = [0, 80, 254]
  lthick = [4, 6, 4]
  lstyle = [0, 0, 0]

  month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', $
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  for ivar = 0, nvar-1 do begin
   noerase = 0

   for i = 1, 12 do begin
    mm = strcompress(string(i),/rem)
    if(i lt 10) then mm = '0'+mm
    wanttime = yyyy+mm

    for imod = 0, nmod-1 do begin
     ga_getvar, ctlfile[imod], varwant[ivar], varval, wanttime=wanttime, $
                lon=lon, lat=lat, time=time, /bin

;    we assume here a 2d array returned
;    straight, simple zonal average
     nx = n_elements(lon)
     varval = reform(varval)
     varval = total(varval,1)/nx

;    Now possibly degrade to 2x2.5 resolution
     varout = c_to_b(varval)
     latb = findgen(91)*2. - 90.

     ytitle = ''
     if(i eq 1 or i eq 4 or i eq 7 or i eq 10) then ytitle='latitude'

     if(imod eq 0) then begin
      plot, varout*scalefac[ivar], latb, /nodata, noerase=noerase, $
            xrange=[0,xmax[ivar]], xstyle=9, xthick=3, xminor=1, $
            yrange=[-90,90], ystyle=9, ythick=3, yticks=6, ytitle=ytitle, $
            position=position[*,i-1], charsize=.85
      oplot, varout*scalefac[ivar], latb, thick=4, color=0, lin=0
      varsave1 = varout
     endif else begin
      oplot, varout*scalefac[ivar], latb, color=colors[imod], thick=lthick[imod], lin=lstyle[imod]
      if(imod eq 1) then varsave2 = varout
     endelse

     noerase = 1

    endfor  ; models

    xyouts, xmax[ivar], 60, month[i-1], align=1, charsize=.85

    dx = position[2,i-1]-position[0,i-1]
    x = position[0,i-1] + .5*dx
    y0 = position[1,i-1]
    y1 = position[3,i-1]
    plot, indgen(10), /nodata, /noerase, $
          position=[x,y0,x+.3*dx,y1], $
          yrange=[-90,90], ystyle=5, $
          xrange=[.5,2], xstyle=5
    oplot, varsave1/varsave2, latb
    oplot, [.5,.5], [-90,90], lin=1
    oplot, [1.,1.], [-90,90], lin=1
    oplot, [1.5,1.5], [-90,90], lin=1
    oplot, [1.99,1.99], [-90,90], lin=1
    axis, .5, 90, xax=1, charsize=.5, xstyle=1, xticks=3

   endfor   ; months

   xyouts, .075, .94, /normal, title[ivar]

  endfor    ; variables


  device, /close


end
