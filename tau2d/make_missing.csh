#!/bin/csh
# Goal is to write an undef file suitable to fill in missing model
# months of MYD04 comparison

  set undef = /home/colarco/sourcemotel/FVGCM-hold/src/shared/gfio/r8/GFIO_undef_r8.x

  set expid = t003_c32
  set inpdir = /output/colarco/$expid/tau/

  $undef -o $inpdir/Y2003/M01/undef.tau2d.MYD04_005.lnd.200301.hdf $inpdir/Y2003/M01/$expid.tau2d.MYD04_005.lnd.200301.hdf
  $undef -o $inpdir/Y2003/M01/undef.tau2d.MYD04_005.ocn.200301.hdf $inpdir/Y2003/M01/$expid.tau2d.MYD04_005.ocn.200301.hdf
  $undef -o $inpdir/Y2003/M01/undef.tau2d_pw.MYD04_005.lnd.200301.hdf $inpdir/Y2003/M01/$expid.tau2d_pw.MYD04_005.lnd.200301.hdf
  $undef -o $inpdir/Y2003/M01/undef.tau2d_pw.MYD04_005.ocn.200301.hdf $inpdir/Y2003/M01/$expid.tau2d_pw.MYD04_005.ocn.200301.hdf

  foreach yyyy (2000 2001 2002)
  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  ln -s $inpdir/Y2003/M01/undef.tau2d.MYD04_005.lnd.200301.hdf $inpdir/Y$yyyy/M$mm/$expid.tau2d.MYD04_005.lnd.$yyyy$mm.hdf
  ln -s $inpdir/Y2003/M01/undef.tau2d.MYD04_005.ocn.200301.hdf $inpdir/Y$yyyy/M$mm/$expid.tau2d.MYD04_005.ocn.$yyyy$mm.hdf
  ln -s $inpdir/Y2003/M01/undef.tau2d_pw.MYD04_005.lnd.200301.hdf $inpdir/Y$yyyy/M$mm/$expid.tau2d_pw.MYD04_005.lnd.$yyyy$mm.hdf
  ln -s $inpdir/Y2003/M01/undef.tau2d_pw.MYD04_005.ocn.200301.hdf $inpdir/Y$yyyy/M$mm/$expid.tau2d_pw.MYD04_005.ocn.$yyyy$mm.hdf

  end
  end
