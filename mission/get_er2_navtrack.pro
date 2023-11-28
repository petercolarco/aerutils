; Colarco
; Get the ER-2 nav track

  pro get_er2_navtrack, datadir, datewant, lon, lat, lev, prs, gmt

  navfile = dataDir + 'NR'+datewant+'.ER2.txt'
  ex_rd1001, navfile, xname=xname, xvalues=xvals $
             , vname=vname, data=dat, vmiss=vmiss $
             , aname=aname, auxdat=auxdat, amiss=amiss $
             , n_dimens=n_dimens, nauxv=nauxv, err=err $
             , oname=oname,sname=sname,org=org,mname=mname $
             , date=date, mod_date=mod_date $
             , spec_comments=scom, norm_comments=ncom
  lat = dat[*,17]
  lon = dat[*,18]
  lev = dat[*,16]
  prs = dat[*,20]
  gmt  = xvals

; degrade the nav data to about 1x minute
  nx = n_elements(gmt)
  lat = lat[0:nx-1:60]
  lon = lon[0:nx-1:60]
  lev = lev[0:nx-1:60]
  prs = prs[0:nx-1:60]
  gmt = gmt[0:nx-1:60]

end
