  filename = './e572_fp.hsrl_532nm.20110706.nc'
  extinction = 1.
  read_curtain, filename, lon, lat, time, z, dz, extinction_tot=extinction
  nt = n_elements(time)
  extinction = transpose(extinction)
  dz = transpose(dz) / 1000.
  z  = transpose(z)  / 1000.
  time = findgen(nt)/nt + 15.

; Get the extinction from Arlindo's file
;  cdfid = ncdf_open('./discoveraq-geos5-HSRL_MODEL_20110705_RA_L2_sub.h5')
;   filestruct = ncdf_inquire(cdfid)
;   id = ncdf_varid(cdfid,'Altitude')
;   ncdf_varget, cdfid, id, ext532
;  ncdf_close, cdfid
;stop

  openr, lun, 'out.bin', /get
  ext532 = fltarr(294,1249)
  readu, lun, ext532
  free_lun, lun
  ext532 = transpose(ext532)
  openr, lun, 'alt.bin', /get
  alt = fltarr(294)
  readu, lun, alt
  free_lun, lun
  alt = alt/1000.

    position = [.15,.2,.95,.9]
    a = where(time lt time[0])
    if(a[0] ne -1) then time[a] = time[a]+24.
    plot, indgen(n_elements(time)), /nodata, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,8], ytitle='altitude [km]', $
     position=position
    loadct, 39
    levelarray = 10.^(-2.+findgen(60)*(alog10(5.)-alog10(.1))/60.)
     
    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, z, time[1]-time[0], dz
;    contour, /over, extinction, time, reform(z[0,*]), $
;             level=levelarray, /fill, c_color=colorarray
;    contour, /over, ext532, time, alt, $
;             level=levelarray, /cell_fill, c_color=colorarray
    labelarray = strarr(60)
    labels = [.01, .02, .03, .04, .06, .1, .16, .25, .4]
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(f5.3)')
    endfor
    makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
     label=labelarray, $
     align=.5, /no

end

