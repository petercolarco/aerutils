; Colarco, December 2010
;
; Read in model and data at AERONET sites and make a plot of all times
; in some time range.  Only do for sites with data in the specified
; date range

  expid = 'dR_MERRA-AA-r2'
  modeltemplate = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/aeronet/'+$
                  expid+'.inst2d_hwl.aeronet.%ch.%y4.nc4'
  expid = 'F25b18'
  modeltemplate = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/aeronet/'+$
                  expid+'.inst2d_hwl.aeronet.%ch.%y4.nc4'
  yyyy = '2007'
  date0 = '20070701'
  date1 = '20070916'
  nymd = [date0,date1]
  nhms = ['000000','230000']
  three = 0
  six   = 0
  hourly = 1
  varwant = [ 'du001', 'du002', 'du003', 'du004', 'du005', $
              'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
              'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'SO4' ]
  varwant = ['duexttau','bcexttau','ocexttau','ssexttau','suexttau']
;  varwant = ['duexttau','ssexttau','bcexttau']

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

; Read the database of aeronet locations
;  read_aeronet_locs, location, lat, lon, ele, database='aeronet_locs.dat.4'
  read_aeronet_locs, location, lat, lon, ele, database='aeronet_locs.dat.4'
  nlocs = n_elements(location)
  aeronetPath = '/misc/prc10/AERONET/LEV30/'
  lambdabase = '550'

  openplotfile = 0

  for iloc = 0, nlocs-1 do begin

;  read in the aeronet aot and angstrom exponents and reduce to
;  specified date range
   locwant = location[iloc]
   aeronetAngstrom = 1.
   read_aeronet2nc, aeronetPath, locwant, lambdabase, yyyy, aeronetAOT, aeronetDate, $
                    angpair=1, angstrom=aeronetAngstrom, naot=aeronetNum, $
                    hourly=hourly, three=three, six=six, pi_name=pi_name

   a = where(aeronetAOT lt -9990.)
   if(a[0] ne -1) then aeronetAOT[a] = !values.f_nan
   if(a[0] ne -1) then aeronetAngstrom[a] = !values.f_nan
   if(a[0] ne -1) then aeronetNum[a] = !values.f_nan
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
   aeronetDate = aeronetDate[a]
   aeronetAOT  = aeronetAOT[a]
   aeronetNum  = aeronetNum[a]
   aeronetAngstrom = aeronetAngstrom[a]

;  At this point read the corresponding model
   if(six)    then tinc = 360.
   if(three)  then tinc = 180.
   if(hourly) then tinc = 60.
stop
   readmodel_aeronet, modeltemplate, locwant, nymd, nhms, lambdabase, $
                      varwant, modeldate, modelAOT, tinc=tinc
   modelaot = total(modelaot,2)
;  Get the model angstrom exponent
   modelang = modelaot
   modelang[*] = 1.
;  Try to get from file
   readmodel_aeronet, modeltemplate, locwant, nymd, nhms, lambdabase, $
                      ['totangstr'], modeldate, angout, tinc=tinc, rc=rc

;  if the variable is found
   if(rc eq 0) then begin
    modelang = angout
   endif else begin
;   Otherwise try to get from aot
    readmodel_aeronet, modeltemplate, locwant, nymd, nhms, '440', $
                      varwant, modeldate, modelAOT440, tinc=tinc
    modelaot440 = total(modelaot440,2)
    readmodel_aeronet, modeltemplate, locwant, nymd, nhms, '870', $
                       varwant, modeldate, modelAOT870, tinc=tinc
    modelaot870 = total(modelaot870,2)
    if(modelaot440[0] ne modelaot[0] and modelaot870[0] ne modelaot) then $
       modelAng = -alog(modelAOT440/modelAOT870) / alog(440./870.)
   endelse
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
    filename = './output/plots/aeronet_site.'+expid+'.'+date0+'_'+date1+'.ps'
    device, file=filename, color=color, /helvetica, font_size=10, $
            xoff=.5, yoff=.5, xsize=25, ysize=15
    !p.font=0

;    position the plots
     position = fltarr(4,6)
     position[*,0] = [.07,.6,.4,.95]
     position[*,1] = [.47,.6,.68,.95]
     position[*,2] = [.75,.6,.96,.95]
     position[*,3] = [.07,.1,.4,.45]
     position[*,4] = [.47,.1,.68,.45]
     position[*,5] = [.75,.1,.96,.45]
     openplotfile = 1
  endif

;; setup the tick marks on the x-axis of date
;; What is the frequency of tick marks desired (in months)
;  ntick = n_elements(years)
;  nminor = 4
;  tickname=replicate(' ', ntick+1)
;  tickname_=replicate(' ', ntick+1)
;  for it = 0, ntick-1 do begin
;   tickname_[it] = strmid(strcompress(string(date[it*12]),/rem),0,4)
;  endfor
;  nt = n_elements(date)

;  tick marks based on model date
   aeronetdate = string(aeronetdate,format='(i10)')
   mm = strmid(aeronetdate,4,2)
   dd = strmid(aeronetdate,6,2)
   hh = strmid(aeronetdate,8,2)
   a  = where(dd eq '15' and hh eq '00')
;   a = where((mm eq '03' or mm eq '06' or mm eq '09' or mm eq '12') and $
;              dd eq '01' and hh le '03')
   ntick = n_elements(a)
   xtickv = a+1
   xtickname=replicate(' ',ntick+1)
   xtickname[0:ntick-1]=[strmid(aeronetdate[a],0,8)]
   xminor = 1

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
   oplot, indgen(nt), modelaot, thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='AOT [500 nm]', title=locwant, $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,0], charsize=.7
;   for itick = 0, ntick-1 do begin
;    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
;   endfor

   loadct, ct
   plot, indgen(5), /nodata, $
;         xrange=[-4,2], yrange=[-4,2], $
         xrange=[0,1], yrange=[0,1], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,1], /noerase, $
         xtitle='ln(AERONET+.01)', ytitle='ln(Model+.01)'
   ymax=!x.crange[1]   
;   polyfill, [0.01,ymax,ymax,0.01], [0.01,.5*ymax,2*ymax,0.01], /fill, color=backcolor, noclip=0
   oplot, findgen(7)-4., findgen(7)-4.
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   a = where(finite(aeronetAOT) eq 1)
;   plots, alog(aeronetaot[a]+.01), alog(modelAOT[a]+.01), psym=8
   plots, aeronetaot[a], modelAOT[a], psym=8

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(a)
    statistics, aeronetaot[a], modelaot[a], $
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
;   stattable[0,0,iloc] = n
;   stattable[1,0,iloc] = r2
;   stattable[2,0,iloc] = bias
;   stattable[3,0,iloc] = rms
;   stattable[4,0,iloc] = skill
;   stattable[5,0,iloc] = m
;   stattable[6,0,iloc] = b
goto, jump1

   ymax = max([max(faotbin_aer),max(faotbin_mod)])
   dx = taumax[0]-taumin[0]
   f = where(faotbin_aer gt 0)
   g = where(faotbin_mod gt 0)
   xmax = max([taumin[max(f)],taumin[max(g)]])+dx
   nx = n_elements(taumin)
   loadct, ct
   plot, indgen(nx+1), /nodata, $
         xrange=[0,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,2], /noerase, $
         xtitle='AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of AOT'
   for ix = 0, nx-1 do begin
    x0 = taumin[ix]
    x1 = x0+dx
    y0 = 0
    y1 = faotbin_aer[ix]
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=backcolor, /fill
   endfor
   plots, taumin[g]+dx/2., faotbin_mod[g], psym=-8, lin=2
   plot, indgen(nx+1), /nodata, $
         xrange=[0,xmax], $   
         yrange=[0,ymax], $    
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,2], /noerase, $
         xtitle='AOT', ytitle='fraction', $
         yminor=2, $
         title='PDF of AOT' 

jump1:
; ---------------------
; Angstrom

   loadct, ct
   ymax = max([max(aeronetangstrom[where(finite(aeronetangstrom) eq 1)]),max(modelang)])
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,3], /noerase, charsize=.7
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=forcolor
   plots, indgen(nt), aeronetAngstrom, psym=-8, thick=4, lin=2, color=forcolor

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   oplot, indgen(nt), modelAng, thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=9, ythick=3, yrange=[0,ymax], ystyle=8, xrange=[0,nt], $
    xtitle='date', ytitle='!Ma!3!D440-870!N', title=locWant, $
    xticks=ntick, xminor=xminor, xtickname=xtickname, xtickv=xtickv, $
    position=position[*,3], charsize=.7
;   for itick = 0, ntick-1 do begin
;    xyouts, itick*12, -0.1*ymax, tickname_[itick], align=0
;   endfor

   loadct, ct
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,4], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=backcolor, noclip=0
   oplot, indgen(5)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   a = where(finite(aeronetAOT) eq 1)
   plots, aeronetAngstrom[a], modelAng[a], psym=8

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(a)
    statistics, aeronetAngstrom[a], modelAng[a], $
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
goto, jump2
   stattable[0,1,iloc] = n
   stattable[1,1,iloc] = r2
   stattable[2,1,iloc] = bias
   stattable[3,1,iloc] = rms
   stattable[4,1,iloc] = skill
   stattable[5,1,iloc] = m
   stattable[6,1,iloc] = b



   ymax = max([max(fangbin_aer),max(fangbin_mod)])
   dx = angmax[0]-angmin[0]
   f = where(fangbin_aer gt 0)
   g = where(fangbin_mod gt 0)
   xmin = min([angmin[min(f)],angmin[min(g)]])-dx
   xmax = max([angmin[max(f)],angmin[max(g)]])+dx
   nx = n_elements(angmin)
   loadct, ct
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $   
         position=position[*,5], /noerase, $
         xtitle='Angstrom Exponent', ytitle='fraction', $
         yminor=2, $
         title='PDF of Angstrom Exponent'
   for ix = 0, nx-1 do begin
    x0 = angmin[ix]
    x1 = x0+dx
    y0 = 0
    y1 = fangbin_aer[ix]
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=backcolor, /fill
   endfor
   plots, angmin[g]+dx/2., fangbin_mod[g], psym=-8, lin=2
   plot, indgen(nx+1), /nodata, $
         xrange=[xmin,xmax], $
         yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,5], /noerase, $
         xtitle='Angstrom Exponent', ytitle='fraction', $
         yminor=2, $
         title='PDF of Angstrom Exponent'

jump2:
  endfor

jump3:

; Make a map
  loadct, ct
  map_set, /cont
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nlocs-1 do begin
    plots, lon[iloc], lat[iloc], psym=8, noclip=0
    label = location[iloc]
    xyouts, lon[iloc], lat[iloc]-1, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
  endfor

  device, /close

end


