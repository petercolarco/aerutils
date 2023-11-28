; Colarco, May 2017
; Download a CSV of the PM2.5 daily SPEC file from:
; https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html#Daily
; Unzip file and have large CSV list entire year at (possibly) all
; sites.  Could subset ahead of time by 
; `cat file.csv | grep XXXX |& tee XXXX.csv`
; where XXXX is the site interested in, for example

 ; filename = 'miami.csv'
 ; openr, lun, filename, /get

; get a specific set of parameters
 ; paramwant = 'Iron'

  pro read_spec, filename, paramwant, state, county, site, lat, lon, param, date, mean, max, maxh

  openr, lun, filename, /get

  ict = 0
  while(not(eof(lun))) do begin
   get_spec_line, lun, state_, county_, site_, lat_, lon_, param_, date_, mean_, max_, maxh_
   res = strpos(param_,paramwant)

   if(res eq -1) then continue
   ict = ict+1
   if(ict eq 1) then begin
    state  = state_
    county = county_
    site   = site_
    lat    = lat_
    lon    = lon_
    param  = param_
    date   = date_
    mean   = mean_
    max    = max_
    maxh   = maxh_
   endif else begin
    state  = [state,state_]
    county = [county,county_]
    site   = [site,site_]
    lat    = [lat,lat_]
    lon    = [lon,lon_]
    param  = [param,param_]
    date   = [date,date_]
    mean   = [mean,mean_]
    max    = [max,max_]
    maxh   = [maxh,maxh_]
   endelse
  endwhile

; Prevent negative values
  a = where(mean lt 0)
  if(a[0] ne -1) then begin
   mean[a] = 0.
   max[a] = 0.
  endif

; Recast the dates as julday
  yyyy = strmid(date,0,4)
  mm   = strmid(date,5,2)
  dd   = strmid(date,8,2)

  date = julday(mm,dd,yyyy)

  free_lun, lun

end

