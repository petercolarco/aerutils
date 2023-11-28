  filename = '/home/colarco/Y2007/M06/MYD04_L2_006.aero_tc8.deep.20070626.ods'
  kxwant = 320
  ktwant = 45
  readods, filename, $
           kxwant, ktwant, $
           lata, lona, leva, timea, obsa, $
           qathresh=1, rc=fail, ktqa=74, obsq=obsq

end
