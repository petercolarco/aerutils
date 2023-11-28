; Colarco, June 2015
; 
; Tabazadeh wtpct of sulfuric acid aerosol as function of temperature
; and RH, valid for t >=185 to t <=260 K

  function wtpct, relhum, t=t

; Input is relative humidity
  activ = relhum

; If no temperature provided assume 220 K
  if(not(keyword_set(t))) then t = 220.


  rhopdry = 1.923

  if (activ lt 0.05) then begin
      activ = max([activ,1.e-6])    ; restrict minimum activity
      atab1 	= 12.37208932	
      btab1 	= -0.16125516114
      ctab1 	= -30.490657554
      dtab1 	= -2.1133114241
      atab2 	= 13.455394705	
      btab2 	= -0.1921312255
      ctab2 	= -34.285174607
      dtab2 	= -1.7620073078
  endif else begin
   if (activ ge 0.05 and activ le 0.85) then begin
       atab1 	= 11.820654354
       btab1 	= -0.20786404244
       ctab1 	= -4.807306373
       dtab1 	= -5.1727540348
       atab2 	= 12.891938068	
       btab2 	= -0.23233847708
       ctab2 	= -6.4261237757
       dtab2 	= -4.9005471319
   endif else begin
       activ = min([activ,1.])      ; restrict maximum activity
       atab1 	= -180.06541028
       btab1 	= -0.38601102592
       ctab1 	= -93.317846778
       dtab1 	= 273.88132245
       atab2 	= -176.95814097
       btab2 	= -0.36257048154
       ctab2 	= -90.469744201
       dtab2 	= 267.45509988
   endelse
  endelse

  contl = atab1*(activ^btab1)+ctab1*activ+dtab1
  conth = atab2*(activ^btab2)+ctab2*activ+dtab2
      
  contt = contl + (conth-contl) * ((t -190.)/70.)
  conwtp = (contt*98.) + 1000.

  wtpct_tabaz = (100.*contt*98.)/conwtp
  wtpct_tabaz = min([max([wtpct_tabaz,1.]),100.]) ; restrict between 1 and 100 %

  return, wtpct_tabaz

end
