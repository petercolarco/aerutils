; Get the AERONET extracts
  yyyy = string(2010+indgen(7),format='(i4)')
  dir  = '/misc/prc13/MERRA2/aeronet/'
  ny = n_elements(yyyy)

; Get and concatenate the AOD
  for iy = 0, ny-1 do begin
   ijul = (31+28+31+30+31+30)*24
   njul = 31*24
   iaug = ijul+(31)*24
   naug = 31*24
   isep = ijul+(31+31)*24
   nsep = 30*24
   cdfid = ncdf_open(dir+'MERRA2.tavg1_2d_aer_Nx.aeronet.'+yyyy[iy]+'.nc4')
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau, offset=[ijul,150], count=[njul,1]
   ncdf_close, cdfid
   if(iy eq 0) then begin
    tauj = tau
   endif else begin
    tauj = [tauj,tau]
   endelse
   cdfid = ncdf_open(dir+'MERRA2.tavg1_2d_aer_Nx.aeronet.'+yyyy[iy]+'.nc4')
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau, offset=[iaug,150], count=[naug,1]
   ncdf_close, cdfid
   if(iy eq 0) then begin
    taua = tau
   endif else begin
    taua = [taua,tau]
   endelse
   cdfid = ncdf_open(dir+'MERRA2.tavg1_2d_aer_Nx.aeronet.'+yyyy[iy]+'.nc4')
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau, offset=[isep,150], count=[nsep,1]
   ncdf_close, cdfid
   if(iy eq 0) then begin
    taus = tau
   endif else begin
    taus = [taus,tau]
   endelse
  endfor

; fake up a histogram
  njul = n_elements(tauj)
  naug = n_elements(taua)
  nsep = n_elements(taus)

  histv = [0,.01,.05,findgen(21)*.1+.1]
  nhist = n_elements(histv)
  hist = fltarr(nhist,3)
  for i = 0, nhist-1 do begin
   hist[i,0] = n_elements(tauj[where(tauj gt histv[i])])*1./njul
   hist[i,1] = n_elements(taua[where(taua gt histv[i])])*1./naug
   hist[i,2] = n_elements(taus[where(taus gt histv[i])])*1./nsep
  endfor

  set_plot, 'ps'
  device, file='capo_verde.freq.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, histv, hist[*,0], /nodata, $
   xrange=[0,2.], xtitle='AOD', $
   yrange=[0.001,1], /ylog, ytitle='frequency', $
   ytickn=['0.1%','1%','10%','100%']
  oplot, histv, hist[*,0], color=0, thick=6
  oplot, histv, hist[*,1], color=208, thick=6
  oplot, histv, hist[*,2], color=254, thick=6
  device, /close
end

