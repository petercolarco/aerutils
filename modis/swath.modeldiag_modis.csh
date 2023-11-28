#!/bin/tcsh

  set swath = /misc/prc10/MODIS/Level3/MOD04/c/SWATH/
  set model = /misc/prc10/colarco/t003_c32/diag/


  set YYYY = 2002
  set MM   = 04
  set DD   = 25

  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

  foreach YYYY ( 2000 2001 2002 2003 2004 2005 2006  )
  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  foreach DD   ( 01 02 03 04 05 06 07 08 09 10 \
                 11 12 13 14 15 16 17 18 19 20 \
                 21 22 23 24 25 26 27 28 29 30 31 )

cat > model.ddf << EOF
dset $model/Y$YYYY/M$MM/t003_c32.chem_diag.sfc.$YYYY$MM${DD}_%h200z.hdf
options template
tdef time 4 linear 03z$DD$month[$MM]$YYYY 6hr
EOF
cat > swath.ddf << EOF
dset $swath/Y$YYYY/M$MM/mod04_c06.mask.sfc.$YYYY$MM$DD.nc
options template
tdef time 4 linear 03z$DD$month[$MM]$YYYY 6hr
EOF
cat > modis.ddf << EOF
dset /misc/prc10/MODIS/Level3/MOD04/c/GRITAS/Y$YYYY/M$MM/MOD04_L2_ocn.aero_005.qawt.$YYYY$MM$DD.hdf
options template
tdef time 4 linear 03z$DD$month[$MM]$YYYY 6hr
EOF
cat > tmp.ddf << EOF
dset tmp.nc
options template
tdef time 4 linear 03z$DD$month[$MM]$YYYY 6hr
EOF

  set modelf = $model/Y$YYYY/M$MM/t003_c32.tau2d.v2.total.$YYYY$MM$DD.hdf
  set modelo = $model/Y$YYYY/M$MM/t003_c32.chem_diag.sfc
  set modiso = /misc/prc10/MODIS/Level3/MOD04/c/GRITAS/Y$YYYY/M$MM/MOD04_L2_ocn.aero_005.qawt.$YYYY$MM$DD.hdf
  set swathf = $swath/Y$YYYY/M$MM/mod04_c06.mask.sfc.$YYYY$MM$DD.nc

  if( -e $swathf) then

# First sample the model with the MODIS AOT retrievals
  lats4d -i model.ddf -j modis.ddf -o tmp -func "maskout(@,aodtau.2(z=6))" -ftype xdf \
   -vars duexttau suexttau ssexttau bcexttau ocexttau ducmass so4cmass occmass bccmass sscmass
  lats4d -i tmp.ddf -j swath.ddf -o modis -func "maskout(@,modis.2)" -ftype xdf
  lats4d -i tmp.ddf -j swath.ddf -o misr  -func "maskout(@,misr.2)"  -ftype xdf
  lats4d -i tmp.ddf -j swath.ddf -o subpoint -func "maskout(@,subpoint.2)" -ftype xdf

  /bin/rm -f tmp.nc
  h4zip modis.nc &
  h4zip misr.nc &
  h4zip subpoint.nc &
  wait

  \mv -f modis.nc    $modelo.MOD04.qawt.modis.$YYYY$MM$DD.hdf
  \mv -f misr.nc     $modelo.MOD04.qawt.misr.$YYYY$MM$DD.hdf
  \mv -f subpoint.nc $modelo.MOD04.qawt.subpoint.$YYYY$MM$DD.hdf

  endif

  end
  end
  end

