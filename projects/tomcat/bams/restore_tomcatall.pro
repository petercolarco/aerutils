  pro restore_tomcatall, tail, varout, nday, lon, lat
   restore, 'tomcat1.'+tail+'.sav'
   varout1 = varout
   restore, 'tomcat2.'+tail+'.sav'
   varout2 = varout
   restore, 'tomcat3.'+tail+'.sav'
   varout3 = varout
   restore, 'tomcat4.'+tail+'.sav'
   varout4 = varout
;  get shape of array
   for i = 0L, n_elements(varout)-1 do begin
    varout[i] = mean([varout1[i],varout2[i],varout3[i],varout4[i]],/nan)
   endfor
   nday = n_elements(filename)

end
