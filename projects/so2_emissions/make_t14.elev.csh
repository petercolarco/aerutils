#!/bin/tcsh

foreach yyyy (2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 \
              2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 \
              2020 2021 2022 )

echo htapv2.2.emisso2.elevated.x3600y1800t12.$yyyy.integrate.nc4

@ yyyym1 = $yyyy - 1
@ yyyyp1 = $yyyy + 1

cat > htapv2.2.emisso2.elevated.ddf <<EOF
dset tmp/htapv2.2.emisso2.elevated.x3600y1800t12.%y4.integrate.nc4
options template
undef 1.e15
xdef lon 3600 linear -179.95 0.1
ydef lat 1800 linear -89.95  0.1
tdef time 36  linear 12z15jan$yyyym1 732hr
EOF


# lats4d it
lats4d.sh -i htapv2.2.emisso2.elevated.ddf -v -shave \
          -time 12z15dec$yyyym1 12z17jan$yyyyp1 \
          -o t14/htapv2.2.emisso2.elevated.x3600y1800t14.$yyyy.integrate.nc4

# Change attributes
ncatted -O -a units,sanl2,m,c,"kg m-2 s-1" \
           -a long_name,sanl2,m,c,"SO2 emissions" \
           -a source,global,c,c,"HTAP project - European Commission, Joint Research Centre; NASA/GSFC, Global Modeling and Assimilation Office" \
           -a title,global,c,c,"Integrated emissions (Canadian database + HTAP) of SO2 from energy sectors." \
           -a references,global,c,c,"Description of the Canadian database can be found http://www.atmos-chem-phys.net/16/11497/2016/acp-16-11497-2016.pdf. Description of the source categories and emissions data can be found on the HTAP-v2 website http://edgar.jrc.ec.europa.eu/htap_v2/." \
           -a contact,global,c,c,"Fei Liu <fei.liu@nasa.gov>; file finalized by Peter Colarco <Peter.R.Colarco@nasa.gov>" \
           t14/htapv2.2.emisso2.elevated.x3600y1800t14.$yyyy.integrate.nc4


end
