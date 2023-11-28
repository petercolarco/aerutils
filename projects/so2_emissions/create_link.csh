#!/bin/tcsh
# Link last year of database (2019 presently) to future year files

  cd tmp

  foreach yyyy (1999 2000 2001 2002 2003 2004)
   ln -s htapv2.2.emisso2.elevated.x3600y1800t12.2005.integrate.nc4 \
         htapv2.2.emisso2.elevated.x3600y1800t12.$yyyy.integrate.nc4
   ln -s htapv2.2.emisso2.surface.x3600y1800t12.2005.integrate.nc4 \
         htapv2.2.emisso2.surface.x3600y1800t12.$yyyy.integrate.nc4
  end

  foreach yyyy (2020 2021 2022 2023)
   ln -s htapv2.2.emisso2.elevated.x3600y1800t12.2019.integrate.nc4 \
         htapv2.2.emisso2.elevated.x3600y1800t12.$yyyy.integrate.nc4
   ln -s htapv2.2.emisso2.surface.x3600y1800t12.2019.integrate.nc4 \
         htapv2.2.emisso2.surface.x3600y1800t12.$yyyy.integrate.nc4
  end

  cd ..
