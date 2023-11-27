#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expid ( dR_SMOKEgo )

set expcoll  = tavg2d_aer_x
set expctl   = /misc/prc15/colarco/$expid/$expcoll/


foreach year ( 2007 )
foreach mm (08 09)

set filename = $expctl/Y$year/M$mm/$expid.$expcoll.monthly.${year}${mm}.nc4
#set filename = $expid.$expcoll.ctl
echo $filename
foreach aertype (TOT DU BC SS POM SU)


cat > idlscript << EOF
plot_budget1, '$filename', '$expid.$expcoll', '$aertype', '$year', mm='$mm', \$
wantlon=[-60,60], wantlat=[-30,30]
exit
EOF

  idl idlscript
#  rm -f idlscript


end

end

end
end
