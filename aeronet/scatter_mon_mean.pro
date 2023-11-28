; Colarco, Feb. 2006
; Read in the model and AERONET AOT data and form a scatter plot
; (1 per month) that shows the model behavior in the monthly mean sense.

  lambda = '500'
  do_stat = 1

  openw, lun, 'scatter_mon_mean.txt', /get_lun
  expid = ['t003_c32.v2']
  years = ['2000']
  ny = n_elements(years)
  for iy = 0, ny-1 do begin
  yyyy = years[iy]
  exppath = '/output/colarco/'+expid[iy]+'/tau/'

; Read the monthly mean file
  cdfid = ncdf_open('./output/mon_mean/aeronet_model_mon_mean.'+expid[iy]+'.'+yyyy+'.nc')
  id = ncdf_varid(cdfid,'location')
  ncdf_varget, cdfid, id, locations
  locations=string(locations)
  nlocs = n_elements(locations)
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon


; Dimension: months, locations, 2 (model, aeronet),
; Lowest levels of statistics
;     8 (statistics: mean, ndays, species/angstrom color, 
;                    stddev, correlation coefficient, RMS Bias, RMS centered, skill)
  aotmonmean = fltarr(12,nlocs,2,8)

; Select colors for modelcolor -- used to distinguish dominant composition
  colorarray = [208,84,254,176]

; Location label: sort of sorted geographically and hard-wired to the current
; location database
  loclabel = indgen(nlocs)+1

; Make a map
  set_plot, 'ps'
  device, file='./output/plots/map.ps', /landscape, xoff=.5, yoff=26, $
   xsize=25, ysize=18, /helvetica, font_size=10, /color
  !P.font=0
  loadct, 39
  map_set
  map_continents, thick=3
  map_continents, /countries
  for iloc = 0, nlocs-1 do begin
    usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=90
    plots, lon[iloc], lat[iloc], psym=8, noclip=0
    usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], color=0
    plots, lon[iloc], lat[iloc], psym=8, noclip=0
    num = strcompress(string(loclabel[iloc]),/rem)
;    xyouts, lon[iloc], lat[iloc]-1, num, $
;            align=.5, charsize=.75, clip=[0,0,1,1]
  endfor
  device, /close


; Read in the AERONET and model data for the desired locations
  for iloc = 0, nlocs-1 do begin

;  Now select on month
   for imon = 1, 12 do begin
    id = ncdf_varid(cdfid,'aotaeronet')
    ncdf_varget, cdfid, id, aotaeronet, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'angaeronet')
    ncdf_varget, cdfid, id, ang, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'aotmodel')
    ncdf_varget, cdfid, id, aotmodel, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'aotmodeldu')
    ncdf_varget, cdfid, id, aotmodeldu, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'aotmodelss')
    ncdf_varget, cdfid, id, aotmodelss, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'aotmodelsu')
    ncdf_varget, cdfid, id, aotmodelsu, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'aotmodelcc')
    ncdf_varget, cdfid, id, aotmodelcc, offset=[iloc,imon-1], count=[1,1]
    id = ncdf_varid(cdfid,'ndays')
    ncdf_varget, cdfid, id, ndays, offset=[iloc,imon-1], count=[1,1]

;   Only use months with more than 3 days observations in them
    if(ndays le 3) then begin
     aotmonmean[imon-1,iloc,*,*] = -9999.
    endif else begin
     aotmonmean[imon-1,iloc,1,0] = aotaeronet
     aotmonmean[imon-1,iloc,1,1] = ndays
     if(ang lt 0.5) then aotmonmean[imon-1,iloc,1,2] = 208
     if(ang ge 0.5 and ang lt 1.0) then aotmonmean[imon-1,iloc,1,2] = 84
     if(ang ge 1.0 and ang lt 1.5) then aotmonmean[imon-1,iloc,1,2] = 176
     if(ang gt 1.5) then aotmonmean[imon-1,iloc,1,2] = 254

     aotmonmean[imon-1,iloc,0,0] = aotmodel
     aotmonmean[imon-1,iloc,0,1] = ndays

;    Find the species dominance
     aotSpec = [aotmodeldu,aotmodelss,aotmodelcc,aotmodelsu]
     aotMax = max(aotSpec,imax)
     aotmonmean[imon-1,iloc,0,2] = colorarray[imax]
    endelse
   endfor
  endfor

  ncdf_close, cdfid

  plotfile = './output/plots/scatter.'+expid[iy]+'.'+yyyy+'.'+lambda+'.ps'
  set_plot, 'ps'
  device, file=plotfile, /landscape, xoff=.5, yoff=26, $
   xsize=25, ysize=18, /helvetica, font_size=10, /color
  !P.font=0
  loadct, 0
  position = fltarr(4,3,2)
  position[*,0,0] = [.075,.575,.325,.9]
  position[*,1,0] = [.375,.575,.625,.9]
  position[*,2,0] = [.675,.575,.925,.9]

  position[*,0,1] = [.075,.1,.325,.425]
  position[*,1,1] = [.375,.1,.625,.425]
  position[*,2,1] = [.675,.1,.925,.425]

  position = reform(position,4,6)

  month = ['January', 'February', 'March', 'April', 'May', 'June', $
           'July', 'August', 'September', 'October', 'November', 'December']


  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for imon = 0, 11 do begin
   noerase = 1
   iplot = imon
   if(imon gt 5) then begin
    iplot = imon-6
   endif
   if(iplot eq 0) then noerase = 0
   plot, [0,2], [0,2], xstyle=9, ystyle=9, $
         thick=3, $
         xrange=[0,1.5], yrange=[0,1.5], $
         xticks=3, yticks=3, xminor=6, yminor=6, $
         position=position[*,iplot], noerase = noerase, $
         xtitle = 'AERONET', ytitle = 'Model', $
         title = yyyy+' '+month[imon]+' '+lambda+' nm AOT'

      
   for iloc = 0, nlocs-1 do begin
    plots, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0], psym=8, noclip=0
    num = strcompress(string(loclabel[iloc]),/rem)
;    xyouts, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0]-.015, num, $
;            align=.5, charsize=.75, clip=[0,0,1,1]
   endfor
   if(do_stat) then begin
    a = where(aotmonmean[imon,*,0,0] gt 0.)
    n = n_elements(a)
    statistics, aotmonmean[imon,a,0,0], aotmonmean[imon,a,1,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    xyouts, .075, 1.35, 'n = '+n, charsize=.75
    xyouts, .075, 1.275, 'r = '+r, charsize=.75
    xyouts, .075, 1.2, 'bias = '+bias, charsize=.75
    xyouts, .45, 1.35, 'rms = '+rms, charsize=.75
    xyouts, .45, 1.275, 'skill = '+skill, charsize=.75
   endif
  endfor



; Color coded by model dominant species
  loadct, 39
  for imon = 0, 11 do begin
   noerase = 1
   iplot = imon
   if(imon gt 5) then begin
    iplot = imon-6
   endif
   if(iplot eq 0) then noerase = 0
   plot, [0,2], [0,2], xstyle=9, ystyle=9, $
         thick=3, $
         xrange=[0,1.5], yrange=[0,1.5], $
         xticks=3, yticks=3, xminor=6, yminor=6, $
         position=position[*,iplot], noerase = noerase, $
         xtitle = 'AERONET', ytitle = 'Model', $
         title = yyyy+' '+month[imon]+' '+lambda+' nm AOT'

   if(noerase eq 0) then $
    xyouts, .075, .96, /normal, $
    'Colored by model dominant species: dust (orange), seasalt (blue), ' + $
    'sulfate (green), carbon (red)'
      
   for iloc = 0, nlocs-1 do begin
    usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, $
     color=aotmonmean[imon,iloc,0,2]
    plots, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0], psym=8, noclip=0
    num = strcompress(string(loclabel[iloc]),/rem)
;    xyouts, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0]-.015, num, $
;            align=.5, charsize=.75, clip=[0,0,1,1]
   endfor
   if(do_stat) then begin
    a = where(aotmonmean[imon,*,0,0] gt 0.)
    n = n_elements(a)
    statistics, aotmonmean[imon,a,0,0], aotmonmean[imon,a,1,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    xyouts, .075, 1.35, 'n = '+n, charsize=.75
    xyouts, .075, 1.275, 'r = '+r, charsize=.75
    xyouts, .075, 1.2, 'bias = '+bias, charsize=.75
    xyouts, .45, 1.35, 'rms = '+rms, charsize=.75
    xyouts, .45, 1.275, 'skill = '+skill, charsize=.75
   endif
  endfor




; Color coded by aeronet angstrom parameters
  printf, lun, ''
  printf, lun, yyyy, ' ', expid[iy]
  printf, lun, 'month n r bias rms skill'
  loadct, 39
  for imon = 0, 11 do begin
   noerase = 1
   iplot = imon
   if(imon gt 5) then begin
    iplot = imon-6
   endif
   if(iplot eq 0) then noerase = 0
   plot, [0,2], [0,2], xstyle=9, ystyle=9, $
         thick=3, $
         xrange=[0,1.5], yrange=[0,1.5], $
         xticks=3, yticks=3, xminor=6, yminor=6, $
         position=position[*,iplot], noerase = noerase, $
         xtitle = 'AERONET', ytitle = 'Model', $
         title = yyyy+' '+month[imon]+' '+lambda+' nm AOT'

   if(noerase eq 0) then $
    xyouts, .075, .96, /normal, $
    'Colored by AERONET 440-870 Angstrom exponent: a < 0.5 (orange), '+ $
    '0.5 < a < 1.0 (blue), 1.0 < a < 1.5 (green), a > 1.5 (red)'
      
   for iloc = 0, nlocs-1 do begin
    usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, $
     color=aotmonmean[imon,iloc,1,2]
    plots, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0], psym=8, noclip=0
    num = strcompress(string(loclabel[iloc]),/rem)
;    xyouts, aotmonmean[imon,iloc,1,0], aotmonmean[imon,iloc,0,0]-.015, num, $
;            align=.5, charsize=.75, clip=[0,0,1,1]
   endfor
   if(do_stat) then begin
    a = where(aotmonmean[imon,*,0,0] gt 0.)
    n = n_elements(a)
    statistics, aotmonmean[imon,a,0,0], aotmonmean[imon,a,1,0], $
                mean0, mean1, std0, std1, r, bias, rms, skill
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    xyouts, .075, 1.35, 'n = '+n, charsize=.75
    xyouts, .075, 1.275, 'r = '+r, charsize=.75
    xyouts, .075, 1.2, 'bias = '+bias, charsize=.75
    xyouts, .45, 1.35, 'rms = '+rms, charsize=.75
    xyouts, .45, 1.275, 'skill = '+skill, charsize=.75
    printf, lun, imon+1, n, r, bias, rms, skill, format='(i3,2x,i4,4(2x,f6.3))'
   endif
  endfor



  device, /close

  endfor

  free_lun, lun
 
end
