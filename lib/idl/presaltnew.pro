pro presaltnew,pres,alt,dens,temp,err
;
;  This routine gives the altitude, density (in kg per cubic meter),
;   and temperature at a given pressure for the US standard 
;   atmosphere.  
;
;  INPUT:
;     pres: pressure in mb (vector or array)
;     err:  Error value for input pressure (floating point no)
;
;  OUTPUT:
;      alt: altitude in km (same dims as pres)
;     dens: Density in kg per cubic meter (same dims as pres)
;     temp: Temperature in K (same dims as pres)
;
;  Sample Calling sequence
;  err=99999.
;  pres=[200.,150.,100.]
;  presaltnew,pres,alt,dens,temp,err
;  print, pres
;   200.000	150.000		100.000
;  print, alt
;  11.7838	13.6088		16.1811
;
rgas=287.
grav=9.8
p0=1013.25
z0=0.0
aa0=-6.5
bb0=288.15
;pon0 = -grav/(rgas*.001*aa0)
pon0=-aa0*rgas*.001/grav
tbl0=bb0
p1=226.3
z1=11.0
sca=6.344
p2=54.75
z2=20.0
aa2=1.0
bb2=216.65
;pon2 = -grav/(rgas*.001*aa2)
pon2=-aa2*rgas*.001/grav
tbl2=bb2
lochipres = where(pres gt p1,numhipres)
loclopres = where(pres lt p2,numlopres)
locmipres = where(pres ge p2 and pres le p1,nummipres)
locerrpres = where(pres eq err,numerrpres)
alt = pres
temp = pres
dens = pres
if numhipres ne 0 then begin
  alt(lochipres) = ((tbl0*((pres(lochipres)/p0)^pon0))-bb0)/aa0
  temp(lochipres) = (aa0*(alt(lochipres)-z0)) + bb0
  dens(lochipres) = 100.*(pres(lochipres)/(rgas*temp(lochipres)))
endif
if numerrpres ne 0 then begin
  alt(locerrpres) = err
  temp(locerrpres) = err
  dens(locerrpres) = err
endif
if numlopres ne 0 then begin
  alt(loclopres) = (((tbl2*((pres(loclopres)/p2)^pon2))-bb2)/aa2)+z2
  temp(loclopres) = (aa2*(alt(loclopres)-z2)) + bb2
  dens(loclopres) = 100.*(pres(loclopres)/(rgas*temp(loclopres)))
endif
if nummipres ne 0 then begin
  temp(locmipres) = bb2
  alt(locmipres) = z1-(sca*alog(pres(locmipres)/p1))
  dens(locmipres) = 100.*(pres(locmipres)/(rgas*temp(locmipres)))
endif
return
end
