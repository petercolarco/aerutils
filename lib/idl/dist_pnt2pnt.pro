function dist_pnt2pnt,stlat,stlon,enlat,enlon,bearing=bearing

;+
; NAME:
;   dist_pnt2pnt
; PURPOSE:
;   calculates the distances between [stlat,stlon] and [enlat,enlon]
; CATEGORY:
;   spherical triangle
; CALLING SEQUENCE:
;   x=dist_pnt2pnt(stlat,stlon,enlat,enlon)
; INPUTS:
;   stlat =	starting latitude
;   stlon =	starting longitude
;   enlat =	ending latitude
;   enlon =	ending longitude
; OPTIONAL KEYWORD INPUT PARAMETERS:
; OUTPUTS:
;   dist = 	distance in km between [stlat,stlon] and [enlat,enlon]
; OPTIONAL OUTPUT PARAMETERS:
;   bearing = bearing (bearing between [stlat,stlon] and [enlat,enlon])
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; REQUIRED ROUTINES:
; MODIFICATION HISTORY: 
; $Head$
;-

;** earth radius
  re = 40000./2./!dpi	;** in km
  rad=!radeg

  if (n_params(0) ne 4) then begin
     print,'dist_pnt2pnt: wrong number of parameters'
     return,-999.
  endif

;** check input lat/lon
  oo = where(abs(stlat) gt 90.0)
  stlat1 = stlat
  if oo(0) ne -1 then begin
     ;print,'dist_pnt2pnt: stlat gt 90.0, setting to 90.0'
     stlat1(oo) = sgn(stlat(oo)) * 90.0
  endif 
  oo = where(abs(enlat) gt 90.0)
  enlat1 = enlat
  if oo(0) ne -1 then begin
     ;print,'dist_pnt2pnt: enlat gt 90.0, setting to 90.0'
     enlat1(oo) = sgn(enlat(oo)) * 90.
  endif 
  oo = where( (abs(enlat1) eq 90.) and (enlat1-stlat1 eq 0.0) )
  if oo(0) ne -1 then begin
     ;print,'dist_pnt2pnt: enlat and stlat both ',enlat1
     return,0.0
  endif
  nst = n_elements(stlat)
  nen = n_elements(enlat)
  nd  = 1
  if nst ne 1 or nen ne 1 then begin
    if nst ne nen and nen ne 1 and nst ne 1 then begin
      print,'dist_pnt2pnt: enlat and stlat inconsistent'
      ;return,0.0
    endif
    nd = max([nst,nen])
  endif

  
  lons = pos_angle( float(stlon) )
  lone = pos_angle( float(enlon) )

; ** c is great circle angle between st and en

  a=double(90.-stlat1)/rad + fltarr(nd)
  b=double(90.-enlat1)/rad + fltarr(nd)
  CC=double(lone-lons)/rad + fltarr(nd)

  cosc=cos(a)*cos(b)+sin(a)*sin(b)*cos(cc)
  c = cosc-cosc
  oo = where(cosc lt 1.)
  if oo(0) ne -1 then c(oo)=acos(cosc(oo))
  oo = where(cosc ge 1.)
  if oo(0) ne -1 then c(oo)=0.0
  oo = where(cosc le -1.)
  if oo(0) ne -1 then c(oo)=!pi

  cosBB = c-c
  sinBB = c-c+1
  oo = where(c ne 0.)
  if oo(0) ne -1 then begin
    cosBB(oo)   = (cos(b(oo))-cos(c(oo))*cos(a(oo)))/sin(c(oo))/sin(a(oo))
    sinBB(oo)   = sin(CC(oo))/sin(c(oo))*sin(b(oo))
  endif
  Bearing = atan(sinBB,cosBB)*rad
  oo = where(a eq 0.)
  if oo(0) ne -1 then bearing(oo)=180.
  oo = where(a eq !pi)
  if oo(0) ne -1 then bearing(oo)=0.
  oo = where(b eq 0.)
  if oo(0) ne -1 then bearing(oo)=0.
  oo = where(b eq !pi)
  if oo(0) ne -1 then bearing(oo)=180.
  
  if n_elements(c) eq 1 then c=c(0)
  if n_elements(bearing) eq 1 then bearing=bearing(0)
  
  return,c*re
  end
