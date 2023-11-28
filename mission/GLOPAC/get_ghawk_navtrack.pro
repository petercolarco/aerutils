; Colarco
; Get the Global Hawk nav track
; return pressure is in hPa
; return altitude in km
; return date is in YYYYMMDD.fraction

  pro get_ghawk_navtrack, datadir, datewant, lon, lat, lev, prs, date

  navfile = dataDir + 'NP'+datewant+'.GH'
  ex_rd1001, navfile, xname=xname, xvalues=xvals $
             , vname=vname, data=dat, vmiss=vmiss $
             , aname=aname, auxdat=auxdat, amiss=amiss $
             , n_dimens=n_dimens, nauxv=nauxv, err=err $
             , oname=oname,sname=sname,org=org,mname=mname $
             , date=date, mod_date=mod_date $
             , spec_comments=scom, norm_comments=ncom
  lat = dat[*,1]
  lon = dat[*,2]
  lev = dat[*,3]
  gmt  = xvals

; degrade the nav data to about 1x minute
  nx = n_elements(gmt)
  lat = lat[0:nx-1:12]
  lon = lon[0:nx-1:12]
  lev = lev[0:nx-1:12]
  gmt = gmt[0:nx-1:12]

; Do unit conversions, etc.
  lev = lev/1000.
  altpres, lev, prs, dens, temp, 0.
  date = double(datewant) + gmt/86400.d

end
