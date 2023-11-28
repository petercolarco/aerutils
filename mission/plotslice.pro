; Colarco, May 2007
; Given a lat/lon/lev range make a plot

; Specify the data wanted
  varwant = 'dumass'
  directory = '/science/dao_ops/GEOS-4_INTEXB/a_flk_04C/forecast/'
  date0 = '2006062600'
  ctlfile = 'ctlfile.ddf'
  filehead = 'a_flk_04C.chem_diag.prs.'
  wantlon = [-180,0]
  wantlat = [10]
  wantlev = [1000,0]
  position = [.1,.25,.95,.9]


; Specify what to do with the data
  scalefac   = 1e9
  levelarray = [10,25,50,75,100,125,150]
  colorarray = [48,84,126,176,192,208,254]
  colortable = 39
  loadct, 39
  title = 'duh'


; -------------------------------------------------------------------------------------------
; This is the function stuff, should not need be modified


; logic for checking what type of plot is requested
  if(n_elements(wantlon) gt 2) then stop
  if(n_elements(wantlat) gt 2) then stop
  if(n_elements(wantlex) gt 2) then stop
  flag =    n_elements(wantlon)-1
  flag = 2*(n_elements(wantlat)-1) + flag
  flag = 4*(n_elements(wantlev)-1) + flag


  write_ddf, ctlfile, directory, filehead, date0, /forecast, incstr='3'
  ga_getvar, ctlfile, varwant, varval, lev=lev, lat=lat, lon=lon, $
    wantlon=wantlon, wantlat=wantlat, wantlev=wantlev
  a = where(varval ge 1e15)
  if(a[0] ne -1) then varval[a] = !values.f_nan
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  a = size(varval)
  nt = 1
  if(a[0] eq 4) then nt = a[4]

  varval = varval*scalefac

; If the file requested is on the eta surface, then get either the
; delp or surfp variables
; for now: assume get surfp (diagnostic)
  if(strpos(filehead,'eta') ne -1) then begin
   ga_getvar, ctlfile, 'surfp', surfp, lat=lat, lon=lon, $
     wantlon=wantlon, wantlat=wantlat
   nz = n_elements(lev)
   set_eta, hyai, hybi, nz=nz
   pressure_levels, surfp, hyai, hybi, p, delp
   p = p/100.
   delp = delp/100.
  endif

; If pressure level file, construct array of delp centered on pressure levels
  if(strpos(filehead,'prs') ne -1) then begin
   delp  = fltarr(nx,ny,nz,nt)
   p     = fltarr(nx,ny,nz,nt)
   delp_ = fltarr(nz)
   for iz = 0, nz-2 do begin
    delp_[iz] = lev[iz]-lev[iz+1]
    delp[*,*,iz,*] = delp_[iz]
    p[*,*,iz,*] = lev[iz]-delp_[iz]/2.
   endfor
   delp[*,*,nz-1,*] = lev[nz-1]
   p[*,*,nz-1,*] = lev[nz-1]-lev[nz-1]/2.
  endif

; Check the plot type
  case flag of
   0: begin
      print, 'point value: ', varval[0]
      end
   1: begin
      print, 'lon series'
      xtitle = 'longitude'
      ytitle = title
      x = lon
      y = varval[*,0,0,0]
      plot, x, y, max_value=1e14
      end
   2: begin
      print, 'lat series'
      xtitle = 'latitude'
      ytitle = title
      x = lat
      y = varval[0,*,0,0]
      plot, x, y, max_value=1e14
      end
   3: begin
      print, 'lat/lon map'
      x = lon
      y = lat
      dx = x[1]-x[0]
      dy = y[1]-y[0]
      contour, varval[*,*,0,0], x, y, max_value=1e14
      end
   4: begin
      print, 'profile'
      xtitle = title
      ytitle = 'pressure'
      end
   5: begin
      print, 'lon/lev'
      xtitle = 'longitude'
      ytitle = 'pressure'
      x = fltarr(nx,ny,nz,nt)
      for ix =0, nx-1 do begin
       x[ix,*,*,*] = lon[ix]
      endfor
      y = p
      dx = x[1]-x[0]
      dy = delp
      contour, reform(varval), reform(x), reform(y), /nodata, $
        /ylog, yrange=[1000,100], ystyle=9, ythick=3, $
        xrange=[min(x),max(x)], xthick=3, xstyle=9, $
        position=position
      plotgrid, reform(varval), levelarray, colorarray, $
       reform(x), reform(y), reform(dx), reform(dy)
      contour, reform(varval), reform(x), reform(y), /nodata, /noerase, $
        /ylog, yrange=[1000,100], ystyle=9, ythick=3, $
        xrange=[min(x),max(x)], xthick=3, xstyle=9, $
        position=position, $
        xtitle=xtitle, ytitle=ytitle
      x0 = position[0]
      dx0 = position[2]-position[0]
      y0 = .35*position[1]
      dy0 = .2*position[1]
      makekey, x0, y0, dx0, dy0, 0, -dy0/2., align=0, color=colorarray, label=['','']
      end
   6: begin
      print, 'lat/lev'
      xtitle = 'latitude'
      ytitle = 'pressure'
      x = fltarr(nx,ny,nz,nt)
      for iy =0, ny-1 do begin
       x[*,iy,*,*] = lat[iy]
      endfor
      y = p
      dx = x[1]-x[0]
      dy = delp
      contour, reform(varval), reform(x), reform(y), /nodata, $
        /ylog, yrange=[1000,200], ystyle=9, ythick=3, $
        xrange=[min(x),max(x)], xthick=3, xstyle=9, $
        position=position
      plotgrid, reform(varval), levelarray, colorarray, $
       reform(x), reform(y), reform(dx), reform(dy)
      contour, reform(varval), reform(x), reform(y), /nodata, /noerase, $
        /ylog, yrange=[1000,200], ystyle=9, ythick=3, $
        xrange=[min(x),max(x)], xthick=3, xstyle=9, $
        position=position, $
        xtitle=xtitle, ytitle=ytitle
      end
   7: begin
      print, 'lat/lon/lev cube; I don''t know what to do; stopping'
      stop
      end
  endcase




end
