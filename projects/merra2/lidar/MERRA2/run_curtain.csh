#!/bin/tcsh
  cd /misc/prc11/colarco/aerutils
  source setup.csh
  cd /misc/prc11/colarco/aerutils/lidar/CALIPSO

# create ddf
  foreach lambda (355 532 1064)
  foreach version (v10)
#v1 v5 v6 v7 v8 v10 v11)
  foreach file (`\ls -1 inst3d_ext_v.*ddf_`)
  sed -e "s/VERSION/$version/g" $file > tmp
  sed -e "s/LAMBDA/$lambda/g"   tmp   > $file:r.ddf
cp $file:r.ddf $file:r.ddf.$lambda
  rm -f tmp
  end
  sed -e "s/VERSION/$version/g" create_curtain_calipso.pro_ > tmp
  sed -e "s/LAMBDA/$lambda/g"   tmp > create_curtain_calipso.pro
cp create_curtain_calipso.pro create_curtain_calipso.pro.$lambda
  rm -f tmp
  sed -e "s/LAMBDA/$lambda/g"   calipso_table.txt_ > tmp
  \mv -f tmp calipso_table.txt
cp calipso_table.txt calipso_table.txt.$lambda
  idl idlscript
  end
  end
