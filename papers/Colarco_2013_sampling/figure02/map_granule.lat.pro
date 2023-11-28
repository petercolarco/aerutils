; Read an ODS of MODIS data and make an illustrative map of the
; retrieval locations and the sampling strategy

; Read an ODS
; TERRA
  odsfile = '/misc/prc10/MODIS/Level3/MOD04/ODS_03/Y2010/M06/MOD04_L2_051.aero_tc8.ocean.20100605.ods'
  kx = 301
  kt = 45
  ktqa = 74
  qathresh = 1
;  readods, odsfile, kx, kt, lat, lon, lev, time, obs, rc=fail, ks=ks, $
;           ktqa=ktqa, qathresh=qathresh, obsq=obsq
  minsyn = 1240
  dt = 90
  limit = [-5.1,-166.1,5.1,-137.9]
;  limit = [-5,-166,60,-120]
  plotfile = 'map_terra.ps'

; Aqua
  odsfile = '/misc/prc10/MODIS/Level3/MYD04/ODS_03/Y2010/M06/MYD04_L2_051.aero_tc8.ocean.20100605.ods'
  odsfile = '/fvol/calculon2/MODIS/Level2/MYD04/ODS/Y2010/M06/MYD04_L2_051.aero_tc8.ocean.20100605.ods'
  kx = 311
  kt = 45
  ktqa = 74
  qathresh = 1
  readods, odsfile, kx, kt, lat, lon, lev, time, obs, rc=fail, ks=ks, $
           ktqa=ktqa, qathresh=qathresh, obsq=obsq
  minsyn = 1300
  dt = 90
;  limit = [-4,-140,4,-112]
  limit = [-40,-140,20,-105]
  plotfile = 'map_aqua.lat.ps'

; Limit to a single swath
  a = where(time gt minsyn-dt/2 and time le minsyn+dt/2)
  time = time[a]
  lon = lon[a]
  lat = lat[a]
  ks  = ks[a]


set_plot, 'ps'
device, file=plotfile, /color, font_size=10, /helvetica, $
        xsize=12, ysize=20, xoff=.5, yoff=.5
!p.font=0

loadct, 0
if(kx eq 301) then begin
 map_set, /cont, limit=limit, position=[.1,.1,.9,.9]
 polyfill, [-166.1,-137.9,-137.9,-166.1,-166.1],[-5.1,-5.1,5.1,5.1,-5.1], color=220
 polyfill, [-165,-143,-140.5,-162.5,-165],[-5.1,-5.1,5.1,5.1,-5.1], color=255
 xyouts, -150, 0, 'glint', /data, charsize=2, orient=80, align=.5
endif else begin
 map_set, /cont, limit=limit, position=[.1,.1,.9,.9], /noborder
 polyfill, [-140,-105,-105,-140,-140],[-40,-40,20,20,-40], color=220
; polyfill, [-135.5,-114,-116,-137,-135.5],[-4,-4,4,4,-4], color=255
 polyfill, [-131,-105,-118,-140,-131],[-40,-40,20,20,-40], color=255
 xyouts, -129, 3, 'glint', /data, charsize=2, align=.5
 map_continents
endelse

; Make a vector of 16 points, A[i] = 2pi/16:
A = FINDGEN(17) * (!PI*2/16.)
; Define the symbol to be a unit circle with 16 points, 
; and set the filled flag:
USERSYM, COS(A), SIN(A), /FILL


a = where(lev eq 550.)
plots, lon[a], lat[a], psym=8, noclip=0, color=100, symsize=.5

loadct, 1
a = where(lev eq 550. and ((ks-1) mod (135*135)) le 134)
plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

loadct, 3
a = where(lev eq 550. and ((ks+(135.*135.)-(4.*27*135.)-1) mod (135*135)) le 134)
plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

loadct, 8
a = where(lev eq 550. and ((ks+(135.*135.)-(3.*27*135.)-1) mod (135*135)) le 134)
plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

loadct, 7
a = where(lev eq 550. and ((ks+(135.*135.)-(2.*27*135.)-1) mod (135*135)) le 134)
plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

loadct, 39
a = where(lev eq 550. and ((ks+(135.*135.)-(1.*27*135.)-1) mod (135*135)) le 134)
plots, lon[a], lat[a], psym=8, color=254, noclip=0, symsize=.5


map_grid, /box, londel=5, latdel=5, $
          lons=findgen(8)*5-140, $
          lats=findgen(13)*5-40.



device, /close


end
