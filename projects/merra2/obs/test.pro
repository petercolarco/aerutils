  filename = 'merra2_aeronet.20030131_0000z.ods'
  kxwant   = 323  ; aeronet
  ktwant   = 43   ; log-transformed AOD

  readods, filename, $
           kxwant, ktwant, $
           lata, lona, leva, timea, obsa;, /list


end
