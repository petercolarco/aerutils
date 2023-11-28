; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  scatmxo = make_array(365,nyo,val=!values.f_nan)
  scatmno = make_array(365,nyo,val=!values.f_nan)
  


; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM060/LevelB/Y2019/M'+mm+'/',$
                        '*2019'+mm+dd+'_0000z.nc4')
    if(filen[0] ne '') then begin
     jj = 0
     for ii = 0, n_elements(filen)-1 do begin
print, filen[ii]

      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'time')
       ncdf_varget, cdfid, id, time_
       nt = n_elements(time_)
       offset=[248,0,0]
       count=[500,10,nt]
       id = ncdf_varid(cdfid,'latitude')
       ncdf_varget, cdfid, id, lat_, offset=offset, count=count
       id = ncdf_varid(cdfid,'sza')
       ncdf_varget, cdfid, id, sza_, offset=offset, count=count
       id = ncdf_varid(cdfid,'scatAngle')
       ncdf_varget, cdfid, id, scat_, offset=offset, count=count
      ncdf_close, cdfid
;     Make simple: only select on any view of SZA < 90
      a = where(sza_ lt 70.)
      if(a[0] ne -1) then begin
       if(jj eq 0) then begin
        scat = scat_[a]
        lat  = lat_[a]
        jj = 1
       endif else begin
        scat = [scat,scat_[a]]
        lat  = [lat,lat_[a]]
       endelse
      endif
     endfor

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       scatmxo[iday,j] = max(scat[a])
       scatmno[iday,j] = min(scat[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

; Make a plot
  set_plot, 'ps'
  device, file='gpm060.500km.scat.max.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title='Precessing, Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = 80+findgen(10)*10
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 10+findgen(10)*25
  dx = 1.
  dy = 1.
  loadct, 66
  plotgrid, scatmxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file='gpm060.500km.scat.min.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title='Precessing, Minimum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(13)*10.+20.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 10+findgen(13)*20
  dx = 1.
  dy = 1.
  loadct, 70
  plotgrid, scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close



; Make a plot
  set_plot, 'ps'
  device, file='gpm060.500km.scat.diff.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title='Precessing, Range Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(18)*10
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = reverse(findgen(18)*14)
  dx = 1.
  dy = 1.
  loadct, 70
  plotgrid, scatmxo-scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

; Print the fraction of time scat > 170
  a = where(scatmxo ge 170.)
  b = where(finite(scatmxo) eq 1)
  print, 'Fraction >= 170: '+(n_elements(a)*1.)/n_elements(b)

  openw, lun, 'gpm060.500km.scat.max_freq.txt', /get
  a = where(scatmxo ge 130.)
  b = where(finite(scatmxo) eq 1)
  printf, lun, (n_elements(a)*1.)/n_elements(b)
  a = where(scatmxo ge 140.)
  b = where(finite(scatmxo) eq 1)
  printf, lun, (n_elements(a)*1.)/n_elements(b)
  a = where(scatmxo ge 150.)
  b = where(finite(scatmxo) eq 1)
  printf, lun, (n_elements(a)*1.)/n_elements(b)
  a = where(scatmxo ge 160.)
  b = where(finite(scatmxo) eq 1)
  printf, lun, (n_elements(a)*1.)/n_elements(b)
  a = where(scatmxo ge 170.)
  b = where(finite(scatmxo) eq 1)
  printf, lun, (n_elements(a)*1.)/n_elements(b)
  free_lun, lun

end
