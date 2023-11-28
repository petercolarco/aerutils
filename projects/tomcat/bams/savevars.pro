  pro savevars, ddfhead, varname, fnoff, nts, wantlat=wantlat, wantlon=wantlon, tag=tag, hourly=hourly, day=day

  ddf = ddfhead+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  if(keyword_set(hourly)) then begin
   filename= filename[fnoff:fnoff+nts-1]
  endif else begin
   filename= filename[fnoff:fnoff+nts-1:24]
  endelse
  print, filename
  nc4readvar, filename, varname, varout, lon=lon, lat=lat, wantlat=wantlat, wantlon=wantlon
  a = where(varout gt 1e14)
  if(a[0] ne -1) then varout[a] = !values.f_nan
  
; If day keyword is set assume you sampled primary ddf during daylight
; only, and day is supplying a secondary ddf that is the full diurnal
; field and use its values only where they exist and the primary file
; was null
  if(keyword_set(day)) then begin
   ddf = day+'.ddf'
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   if(keyword_set(hourly)) then begin
    filename= filename[fnoff:fnoff+nts-1]
   endif else begin
    filename= filename[fnoff:fnoff+nts-1:24]
   endelse
   print, filename
   nc4readvar, filename, varname, varout_, lon=lon, lat=lat, wantlat=wantlat, wantlon=wantlon
   a = where(varout_ gt 1e14)
   if(a[0] ne -1) then varout_[a] = !values.f_nan
   a = where(finite(varout) ne 1)
   if(a[0] ne -1) then varout[a] = varout_[a]
  endif


  savefile = ddfhead+'.sav'
  if(keyword_set(tag)) then savefile = ddfhead+'.'+tag+'.sav'
  save, filename=savefile, /variables

end
