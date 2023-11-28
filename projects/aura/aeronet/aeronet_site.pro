; Colarco, December 2015
;
; Read in model and data at AERONET sites and make a plot of all times
; in some time range.  Only do for sites with data in the specified
; date range

; Read the database of aeronet locations
  sites = 'south_america'
;  sites = 'dust'
  sites = 'smoke_africa'
;  sites = 'asia'
  read_aeronet_locs, location, lat, lon, ele, database='aeronet_locs.dat.'+sites
  nlocs = n_elements(location)
  aeronetPath = '/misc/prc10/AERONET/LEV30/'
  lambdabase = '440'

; Model
  expid = 'dR_MERRA-AA-r2'
  ver   = ['v0','v7_5','v5_5']
;  ver   = ['v0','v11_5','v7_5']
  modeltemplate = '/misc/prc15/colarco/'+expid+'/inst2d_aer_x/'+ver+'/aeronet/'+ $
                   expid+'.'+ver+'.inst2d_aer.aeronet.'

  yyyy = '2007'
  date0 = '20070601'
  date1 = '20070930'
  nymd = [date0,date1]
  nhms = ['000000','210000']
  three = 1
  six   = 0
  hourly = 0

  color = 1   ; 1 if I want color output, else 0 for gray scale

  if(color) then begin
   backcolor=254
   forcolor = 254
   ct = 39
  endif else begin
   backcolor = 150
   forcolor = 70
   ct = 0
  endelse

  openplotfile = 0

  for iloc = 0, nlocs-1 do begin

;  read in the aeronet aot and angstrom exponents and reduce to
;  specified date range
   locwant = location[iloc]
   aeronetAngstrom = 1.
   read_aeronet2nc, aeronetPath, locwant, lambdabase, yyyy, aeronetAOT, $
                    aeronetDate, $
                    angpair=1, angstrom=aeronetAngstrom, naot=aeronetNum, $
                    /hourly, pi_name=pi_name

   read_aeronet_inversions2nc, aeronetPath, locwant, lambdabase, yyyy, $
                    aeronetInvAOT, aeronetInvAbs, $
                    dateaeronet, ninv=ninvaeronet, $
                    /hourly
;  To increase the number of inversion matches, take the average of
;  values at +/- 1 hour
   a = where(aeronetinvAbs lt 0)
   aeronetinvAbs[a] = !values.f_nan
   nt = n_elements(dateaeronet)
   for it = 3, nt-1, 3 do begin
    aeronetinvAbs[it] = mean(aeronetinvAbs[it-1:it+1],/nan)
   endfor

;  sort to three hourly
   nt              = n_elements(dateaeronet)
   aeronetAOT      = aeronetAOT[0:nt-1:3]
   aeronetInvAOT   = aeronetInvAOT[0:nt-1:3]
   aeronetInvAbs   = aeronetInvAbs[0:nt-1:3]
   aeronetAngstrom = aeronetAngstrom[0:nt-1:3]
   aeronetNum      = aeronetNum[0:nt-1:3]
   aeronetDate     = aeronetDate[0:nt-1:3]

   a = where(aeronetAOT lt -9990.)
   if(a[0] ne -1) then aeronetAOT[a] = !values.f_nan
   if(a[0] ne -1) then aeronetAngstrom[a] = !values.f_nan
   if(a[0] ne -1) then aeronetNum[a] = !values.f_nan
   a = where(aeronetInvAbs lt -9990.)
   if(a[0] ne -1) then aeronetInvAbs[a] = !values.f_nan
   aeronetNYMD = string(aeronetDate/100,format='(i8)')
   a = where(aeronetNYMD ge date0 and aeronetNYMD le date1)
   if(a[0] eq -1) then begin
    print, 'No dates in requested range; exit'
    stop
   endif

   b = where(finite(aeronetAOT[a]) eq 1)
;   if(b[0] eq -1 or n_elements(b) lt 100) then continue
   if(b[0] eq -1) then continue
print, locwant
   aeronetDate     = aeronetDate[a]
   aeronetAOT      = aeronetAOT[a]
   aeronetInvAbs   = aeronetInvAbs[a]
   aeronetNum      = aeronetNum[a]
   aeronetAngstrom = aeronetAngstrom[a]

;  get the model fields
   nmod = n_elements(modeltemplate)
   for imod = 0, nmod-1 do begin
    filename = modeltemplate[imod]+locwant+'.'+yyyy+'.nc4'
    nc4readvar, filename, 'totexttau', modelaot_, lev=lev, time=time
    nc4readvar, filename, 'totabstau', modelabs_, lev=lev
    a = where(lev*1e9 ge float(lambdabase)-1.e-9 and $
              lev*1e9 le float(lambdabase)+1.e-9)
    if(a[0] eq -1) then stop
    nt = n_elements(time)
    if(imod eq 0) then begin
     modelaot = fltarr(nt,nmod)
     modelabs = fltarr(nt,nmod)
     modelang = fltarr(nt,nmod)
    endif
    modelaot[*,imod] = reform(modelaot_[a,*])
    modelabs[*,imod] = reform(modelabs_[a,*])
    a = where(lev*1e9 ge 439. and $
              lev*1e9 le 441.)
    if(a[0] eq -1) then stop
    b = where(lev*1e9 ge 860. and $
              lev*1e9 le 880.)
    if(b[0] eq -1) then stop
    fac = lev[a]/lev[b]
    modelang[*,imod] = -alog(reform(modelaot_[a,*]/modelaot_[b,*])) / alog(fac[0])
   endfor

   pi_name = string(pi_name)
   a = 0
   while(a[0] ne -1) do begin
    a = strpos(pi_name,'_')
    if(a[0] ne -1) then strput, pi_name,' ',a
   endwhile
   a = 0
   while(a[0] ne -1) do begin
    a = strpos(locwant,'_')
    if(a[0] ne -1) then strput, locwant,' ',a
   endwhile

;  Create a plot file
   if(not(openplotfile)) then begin
    set_plot, 'ps'
    filename = './output/plots/aeronet_site.'+sites+'.'+expid+'.'+date0+'_'+date1+'.ps'
    device, file=filename, color=color, /helvetica, font_size=10, $
            xoff=.5, yoff=.5, xsize=25, ysize=25
    !p.font=0

;    position the plots
     position = fltarr(4,6)
     position[*,0] = [.07,.7,.6,.95]
     position[*,1] = [.65,.7,.95,.95]
     position[*,2] = [.07,.4,.6,.65]
     position[*,3] = [.65,.4,.95,.65]
     position[*,4] = [.07,.1,.6,.35]
     position[*,5] = [.65,.1,.95,.35]
     openplotfile = 1
  endif

;  tick marks based on model date
   aeronetdate = string(aeronetdate,format='(i10)')
   mm = strmid(aeronetdate,4,2)
   dd = strmid(aeronetdate,6,2)
   hh = strmid(aeronetdate,8,2)
   a  = where(dd eq '15' and hh eq '00')
   ntick = n_elements(a)
   xtickv = a+1
   xtickname=replicate(' ',ntick+1)
   xtickname[0:ntick-1]=[strmid(aeronetdate[a],0,8)]
   xminor = 1

;  AOT
   nt = n_elements(aeronetDate)
   loadct, ct
   ymax = max([max(aeronetaot[where(finite(aeronetaot) eq 1)]),max(modelaot)])
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,0], charsize=.7
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), aeronetaot, psym=-8, thick=4, lin=2, color=forcolor
   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   oplot, indgen(nt), modelaot[*,0], thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='AOT [500 nm]', title=locwant, $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,0], charsize=.7

   loadct, ct
   plot, indgen(5), /nodata, $
         xrange=[.02,3], yrange=[.02,3], /xlog, /ylog, $
;         xrange=[0,1], yrange=[0,1], $
         xstyle=9, ystyle=9, $
         xthick=4, ythick=4, $
         xticks=5, yticks=5, $
         xtickv=[.02,.05,.13,.36,1,3], $
         ytickv=[.02,.05,.13,.36,1,3], $
         position=position[*,1], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   oplot, [.01,3],[.01,3]
   a = where(finite(aeronetAOT) eq 1)
;   plots, alog10(aeronetaot[a]+.01), alog10(modelAOT[a]+.01), psym=8
   colors = [208,0,84]
   for imod = 0, nmod-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[imod]
    plots, aeronetaot[a], modelAOT[a,imod], psym=8, noclip=0
   endfor
;  Assemble the summary
   if(iloc eq 0) then begin
    aeronetAot_Sum = aeronetaot[a]
    aeronetLoc_Sum = make_array(n_elements(a),val=iloc)
    modelAot_Sum   = modelAOT[a,*]
   endif else begin
    aeronetAot_Sum = [aeronetAot_Sum,aeronetaot[a]]
    aeronetLoc_Sum = [aeronetLoc_Sum,make_array(n_elements(a),val=iloc)]
    modelAot_Sum   = [modelAot_Sum,modelAOT[a,*]]
   endelse

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(a)
    statistics, aeronetaot[a], modelaot[a,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n, format='(i4)'),/rem)
     r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     polyfill, [.025,1,1,.025,.025], [1.5,1.5,2.8,2.8,1.5], color=255, /fill
     xyouts, .03, 2.5, 'n = '+n, charsize=.65
     xyouts, .03, 2, 'r!E2!N = '+r2, charsize=.65
     xyouts, .03, 1.6, 'bias = '+bias, charsize=.65
     xyouts, .1, 2.5, 'rms = '+rms, charsize=.65
     xyouts, .1, 2, 'skill = '+skill, charsize=.65
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .1, 1.6, 'y = '+m+'x + '+b, charsize=.65
    endif
   endif
;   stattable[0,0,iloc] = n
;   stattable[1,0,iloc] = r2
;   stattable[2,0,iloc] = bias
;   stattable[3,0,iloc] = rms
;   stattable[4,0,iloc] = skill
;   stattable[5,0,iloc] = m
;   stattable[6,0,iloc] = b

; ---------------------
; Angstrom

   loadct, ct
   ymax = max([max(aeronetangstrom[where(finite(aeronetangstrom) eq 1)]),max(modelang)])
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,2], /noerase, charsize=.7
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), aeronetAngstrom, psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   oplot, indgen(nt), modelAng, thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='!Ma!3!D440-870!N', title=locWant, $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,2], charsize=.7
;   for itick = 0, ntick-1 do begin
;    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
;   endfor

   loadct, ct
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,3], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   oplot, indgen(5)
   a = where(finite(aeronetAOT) eq 1)
   for imod = 0, nmod-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[imod]
    plots, aeronetAngstrom[a], modelang[a,imod], psym=8, noclip=0
   endfor

;  Assemble the summary
   if(iloc eq 0) then begin
    aeronetAng_Sum = aeronetAngstrom[a]
    modelAng_Sum   = modelAng[a,*]
   endif else begin
    aeronetAng_Sum = [aeronetAng_Sum,aeronetAngstrom[a]]
    modelAng_Sum   = [modelAng_Sum,modelAng[a,*]]
   endelse

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(a)
    statistics, aeronetAngstrom[a], modelAng[a,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n, format='(i4)'),/rem)
     r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
     xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
     xyouts, .05*scale, .85*scale, 'r!E2!N = '+r2, charsize=.65
     xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
     xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
     xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
    endif
   endif
;   stattable[0,1,iloc] = n
;   stattable[1,1,iloc] = r2
;   stattable[2,1,iloc] = bias
;   stattable[3,1,iloc] = rms
;   stattable[4,1,iloc] = skill
;   stattable[5,1,iloc] = m
;   stattable[6,1,iloc] = b


; ---------------------
; Absorption

   loadct, ct
   nt = n_elements(aeronetDate)
   loadct, ct
   ymax = max([max(aeronetInvAbs[where(finite(aeronetInvAbs) eq 1)]),max(modelabs)])
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,4], charsize=.7
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), aeronetInvAbs, psym=-8, thick=4, lin=2, color=forcolor
   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   oplot, indgen(nt), modelabs, thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='Abs AOT [500 nm]', title=locwant, $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,4], charsize=.7
;   for itick = 0, ntick-1 do begin
;    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
;   endfor

   loadct, ct
   plot, indgen(5), /nodata, $
         xrange=[.01,.4], yrange=[.01,.4], $
         /xlog, /ylog, $
         xstyle=9, ystyle=9, $
         xthick=4, ythick=4, $
         xticks=5, yticks=5, $
         xtickv=[.01,.03,.06,.1,.2,.4], $
         ytickv=[.01,.03,.06,.1,.2,.4], $
         position=position[*,5], /noerase, $
         xtitle='AERONET', ytitle='Model'
   oplot, [.01,.4],[.01,.4]
   a = where(finite(aeronetInvAbs) eq 1)
   for imod = 0, nmod-1 do begin
    usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=colors[imod]
    plots, aeronetInvAbs[a], modelabs[a,imod], psym=8, noclip=0
   endfor

;  Assemble the summary
   if(iloc eq 0) then begin
    aeronetAbs_Sum = aeronetInvAbs[a]
    aeronetLocAbs_Sum = make_array(n_elements(a),val=iloc)
    modelAbs_Sum   = modelABS[a,*]
   endif else begin
    aeronetAbs_Sum = [aeronetAbs_Sum,aeronetInvAbs[a]]
    aeronetLocAbs_Sum = [aeronetLocAbs_Sum,make_array(n_elements(a),val=iloc)]
    modelAbs_Sum   = [modelAbs_Sum,modelABS[a,*]]
   endelse

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(a)
    statistics, aeronetInvAbs[a], modelabs[a,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n, format='(i4)'),/rem)
     r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
     xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
     xyouts, .05*scale, .85*scale, 'r!E2!N = '+r2, charsize=.65
     xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
     xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
     xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
    endif
   endif


  endfor

; Make a map
  loadct, ct
  if(sites eq 'dust') then limit=[0,-30,45,20]
  if(sites eq 'smoke_africa') then limit=[-40,0,10,40]
  if(sites eq 'south_america') then limit=[-40,-80,10,-30]
  if(sites eq 'asia') then limit=[0,70,45,130]
  isym = [1,2,3,4,5,14,15,11,13]
  map_set, /cont, position=[.1,.5,.45,.95], limit=limit
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nlocs-1 do begin
    plots, lon[iloc], lat[iloc], psym=sym(isym[iloc]), symsize=2
    label = location[iloc]
    xyouts, lon[iloc]-2, lat[iloc]-2, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
  endfor

  plot, indgen(5), /nodata, /noerase, $
        xrange=[.02,3], yrange=[.02,3], /xlog, /ylog, $
        xstyle=9, ystyle=9, $
        xthick=4, ythick=4, $
        xticks=5, yticks=5, $
        xtickv=[.02,.05,.13,.36,1,3], $
        ytickv=[.02,.05,.13,.36,1,3], $
        xtitle='AERONET', ytitle='Model', $
        position=[.65,.7,.95,.95]
  npts = n_elements(aeronetloc_sum)
  for ipts = 0, npts-1 do begin
   for imod = 1, 1 do begin
    plots, aeronetaot_sum[ipts], modelaot_sum[ipts,imod], $
           psym=sym(isym[aeronetloc_sum[ipts]]), color=colors[imod]
   endfor
  endfor
  oplot, [.01,3], [.01,3]
  statistics, alog10(aeronetaot_sum+.01), alog10(modelaot_sum[*,1]+.01), $
              mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
print, r, bias
  rstr = string(r,format='(f5.2)')
  bstr = string(bias,format='(f6.3)')
  xyouts, .03, 2, 'r!El!N = '+rstr
  xyouts, .03, 1.5, 'bias!El!N = '+bstr

   plot, indgen(5), /noerase, $
         xrange=[-.1,3], yrange=[-.1,3], $
         xstyle=9, ystyle=9, $
         xthick=4, ythick=4, $
         xtitle='AERONET', ytitle='Model', $
         position=[.65,.4,.95,.65]
  for ipts = 0, npts-1 do begin
   for imod = 1, 1 do begin
    plots, aeronetang_sum[ipts], modelang_sum[ipts,imod], $
           psym=sym(isym[aeronetloc_sum[ipts]]), color=colors[imod]
   endfor
  endfor
  oplot, [-1,3], [-1,3]

  plot, indgen(5), /nodata, /noerase, $
        xrange=[.01,.4], yrange=[.01,.4], $
        /xlog, /ylog, $
        xstyle=9, ystyle=9, $
        xthick=4, ythick=4, $
        xticks=5, yticks=5, $
        xtickv=[.01,.03,.06,.1,.2,.4], $
        ytickv=[.01,.03,.06,.1,.2,.4], $
        xtitle='AERONET', ytitle='Model', $
        position=[.65,.1,.95,.35]
  npts = n_elements(aeronetlocabs_sum)
  for ipts = 0, npts-1 do begin
   for imod = 0, nmod-1 do begin
    plots, aeronetabs_sum[ipts], modelabs_sum[ipts,imod], $
           psym=sym(isym[aeronetlocabs_sum[ipts]]), color=colors[imod]
   endfor
  endfor
  oplot, [.01,.4],[.01,.4]

  for imod = 0, nmod-1 do begin
   statistics, alog10(aeronetabs_sum+.001), alog10(modelabs_sum[*,imod]+.001), $
               mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
   print, r, bias
   rstr = string(r,format='(f5.2)')
   bstr = string(bias,format='(f6.3)')
   y0 = 10.^(-2.+(.95-.12*imod)*1.6)
   y1 = 10.^(-2.+(.9 -.12*imod)*1.6)
   xyouts, .0125, y0, 'r!El!N = '+rstr, color=colors[imod]
   xyouts, .0125, y1, 'bias!El!N = '+bstr, color=colors[imod]
  endfor



  device, /close

end


