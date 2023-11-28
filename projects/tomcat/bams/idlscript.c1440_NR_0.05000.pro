 nt = 2208

 tag = 'beij'
 wantlat=[37.5,42.5]
 wantlon=[114,119]
; savevars, 'full.c1440_NR_0.5000.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss1.c1440_NR_0.5000.450km.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss2.c1440_NR_0.5000.450km.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss3.c1440_NR_0.5000.450km.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss4.c1440_NR_0.5000.450km.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss1.c1440_NR_0.5000.nadir.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss2.c1440_NR_0.5000.nadir.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss3.c1440_NR_0.5000.nadir.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
; savevars, 'iss4.c1440_NR_0.5000.nadir.pblh', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly
 savevars, 'iss1.c1440_NR_0.5000.450km.pblh.day', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly, $
  day = 'iss1.c1440_NR_0.5000.nadir.pblh'
 savevars, 'iss2.c1440_NR_0.5000.450km.pblh.day', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly, $
  day = 'iss2.c1440_NR_0.5000.nadir.pblh'
 savevars, 'iss3.c1440_NR_0.5000.450km.pblh.day', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly, $
  day = 'iss3.c1440_NR_0.5000.nadir.pblh'
 savevars, 'iss4.c1440_NR_0.5000.450km.pblh.day', 'pblh', 0, nt, wantlat=wantlat, wantlon=wantlon, tag=tag, /hourly, $
  day = 'iss4.c1440_NR_0.5000.nadir.pblh'

exit
