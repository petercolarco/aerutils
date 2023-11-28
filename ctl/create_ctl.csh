#!/bin/csh
  if ( $#argv < 2 ) then
   echo "Insufficient arguments for create_ctl"
   echo "./create_ctl.csh EXPID YYYY"
   exit 1
  endif

  set EXPID = $1
  set YYYY  = $2

  set basedir = /misc/prc11/colarco/$EXPID

# monthly tavg2d_aer_x files
cat > $EXPID.tavg2d_aer_x.ctl <<EOF
dset $basedir/tavg2d_aer_x/Y%y4/M%m2/$EXPID.tavg2d_aer_x.monthly.%y4%m2.nc4
options template
tdef time 144 linear 15jan$YYYY 1mo
EOF

# monthly MOD04 files
cat > $EXPID.MOD04_l3a.ocn.nnr.ctl <<EOF
dset $basedir/inst2d_hwl_x/Y%y4/M%m2/$EXPID.inst2d_hwl_x.nnr_001.MOD04_l3a.ocean.%y4%m2.nc4
options template
tdef time 144 linear 15jan$YYYY 1mo
EOF

cat > $EXPID.MOD04_l3a.lnd.nnr.ctl <<EOF
dset $basedir/inst2d_hwl_x/Y%y4/M%m2/$EXPID.inst2d_hwl_x.nnr_001.MOD04_l3a.land.%y4%m2.nc4
options template
tdef time 144 linear 15jan$YYYY 1mo
EOF

# monthly MYD04 files
cat > $EXPID.MYD04_l3a.ocn.nnr.ctl <<EOF
dset $basedir/inst2d_hwl_x/Y%y4/M%m2/$EXPID.inst2d_hwl_x.nnr_001.MYD04_l3a.ocean.%y4%m2.nc4
options template
tdef time 144 linear 15jan$YYYY 1mo
EOF

cat > $EXPID.MYD04_l3a.lnd.nnr.ctl <<EOF
dset $basedir/inst2d_hwl_x/Y%y4/M%m2/$EXPID.inst2d_hwl_x.nnr_001.MYD04_l3a.land.%y4%m2.nc4
options template
tdef time 144 linear 15jan$YYYY 1mo
EOF
