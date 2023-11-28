#!/bin/tcsh
  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set swath = /misc/prc10/MODIS/Level3/MOD04/d/
  set model = /misc/prc10/GEOS5.0/e530_yotc_01/das/

  set mon = (jan feb mar apr may jun jul aug sep oct nov dec)

  foreach YYYY ( 2009 )
#  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  foreach MM   (  11 12 )
  foreach DD   ( 01 02 03 04 05 06 07 08 09 10 \
                 11 12 13 14 15 16 17 18 19 20 \
                 21 22 23 24 25 26 27 28 29 30 31 )

cat > tmp.model.ddf << EOF
dset $model/Y$YYYY/M$MM/D$DD/e530_yotc_01.tavg3_2d_aer_Cx.%y4%m2%d2_%h230z.nc4
options template
tdef time 8 linear 01:30z$DD$mon[$MM]$YYYY 3hr
xdef lon 540 linear -180 0.666666
ydef lat 361 linear -90 0.5
EOF

  set modelf = tmp.model.ddf
  set modelo = $model/Y$YYYY/M$MM/e530_yotc_01.tavg3_2d_aer_Cx.aero_tc8_005
  set swathf = tmp.swath.ddf


#  generate a random number for the strings
   set rand = `ps -A | sum | cut -c1-5`
   set function = '"maskout(duexttau.2(z=1)+ssexttau.2(z=1)+ocexttau.2(z=1)+bcexttau.2(z=1)+suexttau.2(z=1),aodtau.1(z=6))"'

##  MODIS sample
#   set swathf = $swath/GRITAS/Y$YYYY/M$MM/MOD04_L2_ocn.aero_tc8_005.qawt.$YYYY$MM$DD.nc4
#cat > tmp.swath.ddf << EOF
#dset $swathf
#options template
#tdef time 8 linear 01:30z$DD$mon[$MM]$YYYY 3hr
#xdef longitude 540 linear -180 0.666666
#ydef latitude 361 linear -90 0.5
#EOF
#   lats4d.sh -i $swathf -j $modelf -o modis.$rand -func $function -levs 550 -shave

##  Shift MISR sample
#   set swathf = $swath/GRITAS/Y$YYYY/M$MM/MOD04_L2_ocn.aero_tc8_005.qawt.shift.misr.$YYYY$MM$DD.nc4
#cat > tmp.swath.ddf << EOF
#dset $swathf
#options template
#tdef time 8 linear 01:30z$DD$mon[$MM]$YYYY 3hr
#xdef longitude 540 linear -180 0.666666
#EOF
#   lats4d.sh -i $swathf -j $modelf -o misr.$rand -func $function -levs 550 -shave

##  Shift Subpoint sample (old)
#   set swathf = $swath/GRITAS/Y$YYYY/M$MM/MOD04_L2_ocn.aero_tc8_005.qawt.shift.subpoint.$YYYY$MM$DD.nc4
#cat > tmp.swath.ddf << EOF
#dset $swathf
#options template
#tdef time 8 linear 01:30z$DD$mon[$MM]$YYYY 3hr
#xdef longitude 540 linear -180 0.666666
#ydef latitude 361 linear -90 0.5
#EOF
#   lats4d.sh -i $swathf -j $modelf -o subpoint.$rand -func $function -levs 550 -shave

#  Shift Subpoint sample
   set swathf = $swath/GRITAS_SHIFTSUBPOINT/Y$YYYY/M$MM/MOD04_L2_ocn.aero_005.qawt.$YYYY$MM$DD.nc4
cat > tmp.swath.ddf << EOF
dset $swathf
options template
tdef time 8 linear 01:30z$DD$mon[$MM]$YYYY 3hr
xdef longitude 540 linear -180 0.666666
EOF
   lats4d.sh -i $swathf -j $modelf -o subpoint.obs_22.$rand -func $function -levs 550 -shave

#   chmod g+s,g+w modis.$rand.nc4 
#   chmod g+s,g+w misr.$rand.nc4 
#   chmod g+s,g+w subpoint.$rand.nc4
   chmod g+s,g+w subpoint.obs_22.$rand.nc4

#   \mv -f modis.$rand.nc4    $modelo.modis.$YYYY$MM$DD.nc4
#   \mv -f misr.$rand.nc4     $modelo.shift.misr.$YYYY$MM$DD.nc4
#   \mv -f subpoint.$rand.nc4 $modelo.shift.subpoint.$YYYY$MM$DD.nc4
   \mv -f subpoint.obs_22.$rand.nc4 $modelo.shift.subpoint.obs_22.$YYYY$MM$DD.nc4

  end
  end
  end

