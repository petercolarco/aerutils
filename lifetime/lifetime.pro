; Colarco, February 2006
; Idea is to read in from the surface diagnostic file the burden of relevant
; species and the loss and emission rates to compute the lifetime.
; Lifetime calculation follows from Textor ACPD 2006.
;  lifetime = burden/sinks

; Note: you need the surface area per grid box to determine the integrated
; burdens and sinks.

; Return the lifetime in days

  pro lifetime, ctlfile, varwant, date, $
                lon, lat, tau, kscav, kwet, ksed, kdry, $
                gocart=gocartInp, resolution=resolutionInp

  gocart = 0
  if(keyword_set(gocartInp)) then gocart=gocartInp
  resolution = 'c'
  if(keyword_set(resolutionInp)) then resolution=resolutionInp

  if(resolution eq 'b') then begin
   nx = 144
   ny = 91
  endif else begin
   nx = 288
   ny = 181
  endelse

  ga_get_mask, mask, lon, lat, res=resolution
  area, lon, lat, nx, ny, dxx, dyy, area

  params, ndu, nss, nbc, noc, nsu

  case varwant of
   'du': begin
         i = 1
         j = ndu
         dosed = 1
         vargcload = ['tcmasa_DU1', 'tcmasa_DU2', 'tcmasa_DU3', 'tcmasa_DU4', 'tcmasa_DU5']
         vargcwet  = ['bwetkg_du1', 'bwetkg_du2', 'bwetkg_du3', 'bwetkg_du4', 'bwetkg_du5']
         vargcsca  = ['bscakg_du1', 'bscakg_du2', 'bscakg_du3', 'bscakg_du4', 'bscakg_du5']
         vargcdry  = ['bdrykg_du1', 'bdrykg_du2', 'bdrykg_du3', 'bdrykg_du4', 'bdrykg_du5']
         vargcset  = ['bsettl_du1', 'bsettl_du2', 'bsettl_du3', 'bsettl_du4', 'bsettl_du5']
         gcfile = 'du'
         gcscale = 1.
         end
   'ss': begin
         i = 1
         j = nss
         dosed = 1
         vargcload = ['tcmasa_SS1', 'tcmasa_SS2', 'tcmasa_SS3', 'tcmasa_SS4']
         gcfile = 'ss'
         end
   'bc': begin
         i = 1
         j = nbc
         dosed = 0
         vargcload = ['tcmasa_BC1', 'tcmasa_BC2']
         vargcwet  = ['bwetmo2d_BC2']
         vargcsca  = ['bscamo2d_BC2']
         vargcdry  = ['bdrymo_BC1', 'bdrymo_BC2']
         gcfile = 'cc'
         gcscale = 0.012
         end
   'oc': begin
         i = 1
         j = noc
         dosed = 0
         vargcload = ['tcmasa_OC1', 'tcmasa_OC2']
         vargcwet  = ['bwetmo2d_OC2']
         vargcsca  = ['bscamo2d_OC2']
         vargcdry  = ['bdrymo_OC1', 'bdrymo_OC2']
         gcfile = 'cc'
         gcscale = 0.012
         end
   'su': begin
         i = 3
         j = 3
         dosed = 0
         end
  endcase

; fix the GOCART file name
  if(gocart) then ctlfile = strsplit(ctlfile,'.ctl',/extract,/regex)+'_'+gcfile+'.ctl'

; get the burden
  varwant = strlowcase(varwant)
  varUse = varwant+'cmass'
  if(varwant eq 'su') then varUse = 'so4cmass'
  if(not gocart) then begin
   ga_getvar, ctlfile, varuse, burden, wanttime=date
  endif else begin
   burden = 0.
   for ivar = 0, n_elements(vargcload)-1 do begin
    varuse = vargcload[ivar]
    ctlfile_ = strsplit(ctlfile,'.ctl',/extract,/regex)+'.2d.ctl'
    ga_getvar, ctlfile_, varuse, out, wanttime=date
    burden = burden+out
   endfor
  endelse

  sink = 0.
  sinksed = 0.
  sinkdry = 0.
  sinkwet = 0.
  sinkscav = 0.

  if(not gocart) then begin
; GEOS-4

  if(varwant ne 'su') then begin
   sinksed = 0.
   if(dosed) then $
    ga_getvar, ctlfile, varwant+'sd', sinksed, wanttime=date, /template
   ga_getvar, ctlfile, varwant+'dp', sinkdry, wanttime=date, /template
   ga_getvar, ctlfile, varwant+'wt', sinkwet, wanttime=date, /template
   ga_getvar, ctlfile, varwant+'sv', sinkscav, wanttime=date, /template
  endif else begin
; doing suldate
   sinksed = 0.
   ga_getvar, ctlfile, varwant+'dp003', sinkdry, wanttime=date, /template
   ga_getvar, ctlfile, varwant+'wt003', sinkwet, wanttime=date, /template
   ga_getvar, ctlfile, varwant+'sv', sinkscav, wanttime=date, /template
  endelse


  endif else begin
; GOCART

  if(dosed) then begin
   for ivar = 0, n_elements(vargcset)-1 do begin
    varuse = vargcset[ivar]
    ga_getvar, ctlfile, varuse, out, wanttime=date
    sinksed = sinksed+out
   endfor
  endif

  for ivar = 0, n_elements(vargcdry)-1 do begin
   varuse = vargcdry[ivar]
   ga_getvar, ctlfile, varuse, out, wanttime=date
   sinkdry = sinkdry+out
  endfor

  for ivar = 0, n_elements(vargcwet)-1 do begin
   varuse = vargcwet[ivar]
   ga_getvar, ctlfile, varuse, out, wanttime=date
   sinkwet = sinkwet+out
  endfor

  for ivar = 0, n_elements(vargcsca)-1 do begin
   varuse = vargcsca[ivar]
   ga_getvar, ctlfile, varuse, out, wanttime=date
   sinkscav = sinkscav+out
  endfor

  lon = findgen(144)*2.5
  lat = -90 + findgen(91)*2
  lat[0] = -89.
  lat[90] = 89.
  area, lon, lat, nx, ny, dxx, dyy, area

  endelse

; reform the arrays to take out the (bogus) level dimension
  sinksed = reform(sinksed)
  sinkdry = reform(sinkdry)
  sinkwet = reform(sinkwet)
  sinkscav = reform(sinkscav)
  burden = reform(burden)

; time dimension
  nt = n_elements(burden[0,0,*])

; If gocart, need to scale
  if(gocart) then begin
   for it = 0, nt-1 do begin
    burden[*,*,it]   = burden[*,*,it]/area*gcscale
    if(dosed) then $
     sinksed[*,*,it]  = -sinksed[*,*,it]/30./86400/area*gcscale
    sinkdry[*,*,it]  = -sinkdry[*,*,it]/30./86400/area*gcscale
    sinkwet[*,*,it]  = -sinkwet[*,*,it]/30./86400/area*gcscale
    sinkscav[*,*,it] = -sinkscav[*,*,it]/30./86400/area*gcscale
   endfor
  endif


  tau = fltarr(nt)
  ksed = fltarr(nt)
  kscav = fltarr(nt)
  kdry = fltarr(nt)
  kwet = fltarr(nt)

  if(dosed) then begin
   sink = sinksed+sinkdry+sinkwet+sinkscav
  endif else begin
   sink = sinkdry+sinkwet+sinkscav
  endelse

  for it = 0, nt-1 do begin
   tau[it] = total(burden[*,*,it]*area)/total(sink[*,*,it]*area*86400.)

   if(dosed) then begin
    ksed[it]  = total(sinksed[*,*,it]*area)/total(sink[*,*,it]*area)/tau[it]
   endif else begin
    ksed[it] =0.
   endelse
   kscav[it] = total(sinkscav[*,*,it]*area)/total(sink[*,*,it]*area)/tau[it]
   kdry[it]  = total(sinkdry[*,*,it]*area)/total(sink[*,*,it]*area)/tau[it]
   kwet[it]  = total(sinkwet[*,*,it]*area)/total(sink[*,*,it]*area)/tau[it]
  endfor

end
