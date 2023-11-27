; Colarco, April 2011
; Given NYMD and NHMS return the julian date

  function julday_nymd, nymd, nhms

   nymd = string(nymd,format='(i8)')
   nhms = strpad(string(nhms,format='(i6)'),100000L)
   yyyy = fix(   nymd/10000L)
   mm   = fix( ( nymd - 10000L*yyyy)/100L)
   dd   = fix(   nymd - 10000L*yyyy - 100L*mm)
   hh   = fix(   nhms/10000L)
   nn   = fix( ( nhms - hh*10000L)/100L)
   return, julday(mm,dd,yyyy,hh,nn)

end
