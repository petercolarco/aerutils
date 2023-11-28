; Assume you want the first eight times on the file
  pro readvars, filenames, varname, varval

  nf = n_elements(filenames)
  varval = fltarr(72,nf*8,12)

  for i = 0, nf-1 do begin
   cdfid = ncdf_open(filenames[i])
   id = ncdf_varid(cdfid,varname)
   ncdf_varget, cdfid, id, varval_
   ncdf_close, cdfid
   varval[*,i*8:i*8+7,*] = varval_[*,0:7,*]
  endfor

  end


  ddf = 'forecast.inst3_3d_aer_Nv.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filenames=strtemplate(template,nymd,nhms)
  filenames=filenames[0:n_elements(filenames)-1:8]

; Get the dust fields
  readvars, filenames, 'DU001', du001
  readvars, filenames, 'DU002', du002
  readvars, filenames, 'DU003', du003
  readvars, filenames, 'DU004', du004
  readvars, filenames, 'DU005', du005
  readvars, filenames, 'AIRDENS', rhoa
  du = (du001+du002+du003+du004+du005)*rhoa*1e9 ; ug m-3

  ddf = 'forecast.inst3_3d_asm_Nv.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filenames=strtemplate(template,nymd,nhms)
  filenames=filenames[0:n_elements(filenames)-1:8]

; Get the height
  readvars, filenames, 'H', h
  h = h/1000.

; Get the station names
  cdfid = ncdf_open(filenames[0])
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, station
  ncdf_close, cdfid
  station = strcompress(string(station),/rem)

; Plot the dust mass concentration profile
  for i = 0, 11 do begin

   set_plot, 'ps'
   device, file='plot_forecast_dust_height.'+station[i]+'.ps', font_size=18, $
    xsize=30, ysize=16, /color
   !p.font=0

   xtickn = [' ',string(indgen(13)+18,format='(i2)'),$
                 string(indgen(5)+1,format='(i1)'),' ']
   loadct, 0
   plot, indgen(10), /nodata, $
    xrange=[17,36], xticks=19, xtickn=xtickn, xminor=8, $
    yrange=[0,8], position=[.1,.25,.95,.9], $
    title=station[i]
   val = transpose(reform(du[*,*,i]))
   alt = transpose(reform(h[*,*,i]))
   x = findgen(n_elements(val[*,0]))/8.+1

   loadct, 33
   levels=[0,10,20,30,50,100,150,200,300,400,600,2000]
   colors=reverse(findgen(12)*10+8)
   colors=findgen(12)*8+159
   contour, /overplot, val, x, alt, levels=levels, c_colors=colors, /cell

   loadct, 0
   makekey, .15,.1,.75,.05, $
    0, -0.035, colors=colors, $
    labels=string(levels,format='(i4)'), align=0
   plot, indgen(10), /nodata, /noerase, $
    xrange=[17,36], xticks=19, xtickn=xtickn, xminor=8, $
    yrange=[0,8], position=[.1,.25,.95,.9], $
    title=station[i], ytitle='Altitude [km]'
   xyouts, 23, -1.1, /data, 'June'
   xyouts, 33, -1.1, /data, 'July'
   xyouts, .5, .025, 'Dust Mass Concentration [!Mm!3g m!E-3!N]', align=.5, /normal
   loadct, 33
   makekey, .15,.1,.75,.05, $
    0, -0.035, colors=colors, $
    labels=make_array(n_elements(levels),val=' '), align=0

   device, /close
  endfor

end
