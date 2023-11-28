#!/bin/csh

cd /misc/prc18/colarco/

#foreach expid (C90c_HTcntl C90c_HTcntl_b C90c_HTcntl_c C90c_HTcntl_d \
#               C90c_HTerupV02a C90c_HTerupV02b C90c_HTerupV02c C90c_HTerupV02d \
#	       C90c_HTerupH2Oonly C90c_HTerupH2Oonlyb C90c_HTerupH2Oonlyc C90c_HTerupH2Oonlyd \
# )

foreach expid (C90c_HTcntl_b C90c_HTcntl_c C90c_HTcntl_d)

 cd $expid
 foreach YYYY (2022)
 foreach MM (01 02 03 04 05)
  if ( ! -f Y$YYYY/M$MM/$expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4) then
   cd Y$YYYY/M$MM/
   ln -s ../../../C90c_HTcntl/Y$YYYY/M$MM/C90c_HTcntl.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4 $expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4
   cd ../../
  endif
 end
 end
 cd ..
end

foreach expid (C90c_HTerupV02b C90c_HTerupV02c C90c_HTerupV02d)

 cd $expid
 foreach YYYY (2022)
 foreach MM (01 02 03 04 05)
  if ( ! -f Y$YYYY/M$MM/$expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4) then
   cd Y$YYYY/M$MM/
   ln -s ../../../C90c_HTerupV02a/Y$YYYY/M$MM/C90c_HTerupV02a.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4 $expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4
   cd ../../
  endif
 end
 end
 cd ..
end

foreach expid (C90c_HTerupH2Oonlyb C90c_HTerupH2Oonlyc C90c_HTerupH2Oonlyd)

 cd $expid
 foreach YYYY (2022)
 foreach MM (01 02 03 04 05)
  if ( ! -f Y$YYYY/M$MM/$expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4) then
   cd Y$YYYY/M$MM/
   ln -s ../../../C90c_HTerupH2Oonly/Y$YYYY/M$MM/C90c_HTerupH2Oonly.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4 $expid.tavg24_2d_dad_Nx.monthly.$YYYY$MM.nc4
   cd ../../
  endif
 end
 end
 cd ..
end
