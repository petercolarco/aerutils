pro gr_circ_rte,stlat,stlon,enlat,enlon,npts,bearing,dist,del,latp,lonp,rd

;+
; NAME:
;   gr_circ_rte
; PURPOSE:
;   calculates the array of latitudes and longitudes
;   along a great circle route, given the bearing, and range
; CATEGORY:
;   geophysics
; CALLING SEQUENCE:
;   gr_circ_rte,stlat,stlon,enlat,enlon,npts,bearing,dist,del,latp,lonp,rd
; INPUTS:   
;         stlat   = starting latitude (in degs.)
;         stlon   = starting longitude (in degs.)
;         enlat   = ending latitude (in degs.)
;         enlon   = ending longitude (in degs.)
;         npts    = number of points in the latitude, longitude, distance
;                      arrays to be returned (includes the start and end pts.)
; OPTIONAL INPUT PARAMETERS:   
; KEYWORD PARAMETERS:   
; OUTPUTS:  
;         bearing = direction of flight (0=N, 180=S, 270=W, 90=E)
;         dist    = distance in KM between the two points
;         del     = increment in km between points over the path 
;         latp    = an npts element vector of latitudes spaced 
;                   at del km increments
;         lonp    = corresponding longitudes for latp
;         rd      = a npts element vector of distances from origin point
; OPTIONAL OUTPUT PARAMETERS:  
; COMMON BLOCKS:  
; SIDE EFFECTS:  
; RESTRICTIONS: 
;         if [stlat,stlon] and [enlat,enlon] are antipodes, the bearing will
;		default to 0., if the bearing is not zero, the returned latp
;		and lonp arrays will be along the specified bearing.
;         if stlat and enlat are opposite poles, the bearing will be 180 if 
;		stlat is 90 and 0 if stlat is -90.  The returned lingitudes
;		will be along stlon. 
; PROCEDURE:   
; REQUIRED ROUTINES:   
; MODIFICATION HISTORY: 
;    pan 9/7/90
;    PTG 09/24/91 added code to handle cases when the starting and ending
;                 latitudes and longitudes are the same
;    PTG 10/17/94 temporarily converted some of the variables to double
;                 precision to avoid overflow errors (i.e., division by 0,
;                 etc), and then back to floating point before returning to
;                 the calling routine
;    $Header: /cvsroot/esma/sandbox/colarco/aerutils/lib/idl/gr_circ_rte.pro,v 1.1 2008/12/09 15:10:23 colarco Exp $
;-

oo=n_params(0)

  if (oo lt 6) then begin
     print,'gr_circ_rte: wrong number of parameters'
     return
  endif

  if (stlat eq 90) and (enlat eq 90) then begin
     print,'gr_circ_rte: Sorry can not go from the N-pole to the N-pole'
     return
  endif

  if (stlat eq -90) and (enlat eq -90) then begin
     print,'gr_circ_rte: Sorry can not go from the S-pole to the S-pole'
     return
  endif

  if (abs(stlat) gt 90) or (abs(enlat) gt 90) then begin
     print,'gr_circ_rte: check your latitudes, must be in degrees'
     return
  endif

  lons=float(stlon)
  lone=float(enlon)

  lons = lons mod 360.
  lone = lone mod 360.
  if (lons lt 0) then lons=lons+360.
  if (lone lt 0) then lone=lone+360.

  npts=long(npts)

  if (npts lt 2) then npts=2

  if (lons eq lone) and (stlat eq enlat) then begin
    ;
    ; Starting and ending latitudes and longitudes are the same
    ;
    bearing = 0.0
    dist = 0.0
    del = 0.0
    latp = fltarr(npts) + stlat
    lonp = fltarr(npts) + lons
    rd = fltarr(npts)
    return
  endif

  if abs(stlat-enlat) eq 180. then begin
    dist = 20000.
    del  = dist/(npts-1.)
    lonp = fltarr(npts)+lons
    latp = findgen(npts)*(enlat-stlat)/(npts-1)+stlat
    if stlat eq 90. then bearing=180 else bearing=0
    rd   = del * findgen(npts)
    return
  end

  latp=fltarr(npts)
  lonp=fltarr(npts)
  rd  =fltarr(npts)

; ** radius of the earth, radians

  re=40000./2./!pi
  rad=180./!pi

; ** c is great circle angle between st and en

  a=double((90.-stlat)/rad)
  b=double((90.-enlat)/rad)
  CC=double((lone-lons)/rad)

  cosc=cos(a)*cos(b)+sin(a)*sin(b)*cos(cc)

  if (cosc gt 1.0) and ((cosc - 1.0D0) lt 1e-14) then cosc = 1.0D0
  c=acos(cosc)

  dist=c*re

  del=dist/(npts-1.)

; bearing
  if dist ne 0.0 then begin
     if abs(c) ne !pi then begin
       sinBB=sin(CC)*sin(b)/sin(c)
       cosBB=( cos(b)-cos(c)*cos(a) ) /sin(a) /sin(c)
       BB=atan(sinBB,cosBB)
       bearing=bb*rad
     endif else begin
       if n_elements(bearing) eq 0 then BB=0 else BB=bearing/rad
       sinBB = sin(bb)
       cosBB = cos(bb)
     endelse
  endif else begin
     BB = 0.0D0
     bearing = 0.0
     sinBB = 0.0D0
     cosBB = 1.0D0
  endelse
   
  cp=c/(npts-1.)*findgen(npts)

; distances

  rd=cp*re

  cosbp=cos(cp)*cos(a)+sin(cp)*sin(a)*cos(BB)
  bp=acos(cosbp)

; ** calculate the lats and lons
  ; ** sinccp and cosccp are the arrays of sines and cosines of the longitudes
  sinccp = cp-cp
  cosccp = cp-cp
  lonp   = cp-cp + lons
  qq = where(bp ne 0.0)
  if qq(0) ne -1 then begin
    sinccp(qq)=sin(cp(qq))*sin(BB)/sin(bp(qq))
    cosccp(qq)=(cos(cp(qq))-cos(a)*cos(bp(qq)))/sin(a)/sin(bp(qq))
    lonp(qq)=atan(sinccp(qq),cosccp(qq))*rad+lons
  endif
  latp=90.-bp*rad

; ** convert output parameters to floating variables
  bearing = float(bearing)
  dist    = float(dist)
  del     = float(del)
  latp    = float(latp)
  lonp    = float(lonp)
  rd      = float(rd)

return
end
