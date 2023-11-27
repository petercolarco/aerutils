pro altpres,alt,pres,dens,temp,err
;
;  This routine gives the pressure, density (in kg per cubic meter),
;   and temperature at a given altitude for the US standard 
;   atmosphere.  
;
;  INPUT:
;     alt:  Altitude in km
;     err:  Error value for input altitude
;
;  OUTPUT:
;     pres: Pressure in mb
;     dens: Density in kg per cubic meter
;     temp: Temperature in K
;
altkm = alt
rgas=287.
grav=9.8
p0=1013.25
z0=0.0
aa0=-6.5
bb0=288.15
pon0 = -grav/(rgas*.001*aa0)
;pon0=-aa0*rgas*.001/grav
;tbl0=(aa0*z0)+bb0
p1=226.3
z1=11.0
sca=6.344
p2=54.75
z2=20.0
aa2=1.0
bb2=216.65
pon2 = -grav/(rgas*.001*aa2)
;pon2=-aa2*rgas*.001/grav
;tbl2=(aa2*z2)+bb2
loc1 = where(altkm lt z1 and altkm ne err,num1)
loc2 = where(altkm ge z1 and altkm lt z2 and altkm ne err,num2)
loc3 = where(altkm ge z2 and altkm ne err,num3)
locerr = where(altkm eq err,numerr)
pres = altkm
temp = altkm
dens = altkm
if numerr ne 0 then begin
  temp(locerr) = err
  pres(locerr) = err
  dens(locerr) = err
endif
if num1 ne 0 then begin
  temp(loc1) = (aa0*(altkm(loc1)-z0)) + bb0
  pres(loc1) = p0*((temp(loc1)/bb0)^pon0)
  dens(loc1) = 100.*(pres(loc1)/(rgas*temp(loc1)))
endif
if num2 ne 0 then begin
  temp(loc2) = bb2
  pres(loc2) = p1*(exp(-(altkm(loc2)-z1)/sca))
  dens(loc2) = 100.*(pres(loc2)/(rgas*temp(loc2)))
endif
if num3 ne 0 then begin
  temp(loc3) = (aa2*(altkm(loc3)-z2)) + bb2
  pres(loc3) = p2*((temp(loc3)/bb2)^pon2)
  dens(loc3) = 100.*(pres(loc3)/(rgas*temp(loc3)))
endif
return
end
