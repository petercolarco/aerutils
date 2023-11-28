; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  colortable = 39
  expid = ['dR_MERRA-AA-r2', 'F25b18', 'cR_F25b18', 'dR_F25b18']+'.inst2d_hwl.aeronet'
  nexp = n_elements(expid)

  years = ['2007']

  for iexp = 0, nexp-1 do begin

  read_mon_mean, expid[iexp], years, location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                     absaeronet, absmodel, $
                     absaeronetstd, absmodelstd
  date = strcompress(string(date),/rem)

; Criteria to select valid sites
; For the multi-year comparison, we require two of each mon (J,F,M,A...)
; to be valid
  nloc = n_elements(location)
  useloc = make_array(nloc,val=0)
  nyr = n_elements(date)/12
  for iloc = 0, nloc-1 do begin
   siteok = 1
   nyr = n_elements(date)/12
   nreq = 1
   if(nyr ge 3) then nreq = 2  ; require at least two of each month
   for imn = 0, 11 do begin
    a = where(finite(aotaeronet[imn:imn+12*(nyr-1):12,iloc]) eq 1)
    if(n_elements(a) lt nreq) then siteok = 0
   endfor
   if(location[iloc] eq 'Mauna_Loa') then siteok = 0
   useloc[iloc] = siteok
  endfor

  a = where(useloc eq 1)
  location  = location[a]
  latitude  = latitude[a]
  longitude = longitude[a]
  angaeronet = angaeronet[*,a]
  aotaeronet = aotaeronet[*,a]
  absaeronet = absaeronet[*,a]
  angmodel   = angmodel[*,a]
  aotmodel   = aotmodel[*,a]
  absmodel   = absmodel[*,a]
  b = where(finite(aotaeronet) eq 1)
  angaeronet = angaeronet[b]
  aotaeronet = aotaeronet[b]
  angmodel   = angmodel[b]
  aotmodel   = aotmodel[b]
  b = where(finite(absaeronet) eq 1)
  absaeronet = absaeronet[b]
  absmodel   = absmodel[b]

; Save for multiple models
  if(iexp eq 0) then begin
   aotaer = fltarr(n_elements(aotaeronet),nexp)
   angaer = fltarr(n_elements(aotaeronet),nexp)
   absaer = fltarr(n_elements(absaeronet),nexp)
   aotmod = fltarr(n_elements(aotaeronet),nexp)
   angmod = fltarr(n_elements(aotaeronet),nexp)
   absmod = fltarr(n_elements(absaeronet),nexp)
  endif

  aotaer[*,iexp] = aotaeronet
  angaer[*,iexp] = angaeronet
  absaer[*,iexp] = absaeronet
  aotmod[*,iexp] = aotmodel
  angmod[*,iexp] = angmodel
  absmod[*,iexp] = absmodel

  endfor

  xtitle = 'AERONET'
  ytitle = 'Model'

; Plot the total of all the points
total:
  set_plot, 'ps'
  device, file='./output/plots/scatter_ann.annual.comparison.'+expid[0]+'.ps', /color, /helvetica, font_size=16, $
          xoff=.5, yoff=.5, xsize=16, ysize=16
  !p.font=0
  loadct, colortable

  n = n_elements(years)
  if(n eq 1) then begin
   yeartitle = years
  endif else begin
   yeartitle = years[0] + ' - '+years[n-1]
  endelse

  x = aotaer[*,0]
  y = aotmod[*,0]
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = .4
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, title= yeartitle+' AOD [550 nm]'
   result = hist_2d(x,y,min1=0.,min2=0.,max1=.4,max2=.4,bin1=.008,bin2=.008)
print, total(result), max(result)
   nlev = 12
   level = findgen(nlev)+1
   dc = 200./(nlev-1)
   color = 254 - findgen(nlev)*dc
   xx = findgen(51)*.008
   loadct, 0
   plotgrid, result, level, color, xx, xx, .008, .008
;;;
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(x)
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, thick=12, noclip=0
    n = strcompress(string(n, format='(i5)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif

;  For other simulations
   loadct, 39
   color=[0,84,208,254]
   for iexp = 1, nexp-1 do begin
    x = aotaer[*,iexp]
    y = aotmod[*,iexp]
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, thick=12, noclip=0, color=color[iexp]
   endfor

; Legend
  plots, [.2,.23], .08, thick=12
  plots, [.2,.23], .06, thick=12, color=84
  plots, [.2,.23], .04, thick=12, color=208
  plots, [.2,.23], .02, thick=12, color=254
  xyouts, .24, .075, 'MERRAero'
  xyouts, .24, .055, 'Hindcast 2!Eo!N x 2.5!Eo!N'
  xyouts, .24, .035, 'Hindcast 1!Eo!N x 1.25!Eo!N'
  xyouts, .24, .015, 'Hindcast 0.5!Eo!N x 0.625!Eo!N'

  device, /close

end
