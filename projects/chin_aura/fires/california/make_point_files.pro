; Colarco
; Read QFED files, select a region, and write output to a text file
; suitable for ingest into GEOS-5

  filedir = '/share/colarco/fvInput/PIESA/sfc/QFED/v2.4r6/Y2007/M07/'
  dates = ['20070701','20070702','20070703','20070704', $
           '20070705','20070706','20070707','20070708', $
           '20070709','20070710','20070711','20070712']

  ndates = n_elements(dates)

; qfed data are on "e" grid
  lon2 = 1
  lat2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='e', lon2=lon2, lat2=lat2
; mask
  a = where(lon2 ge -121 and lon2 le -120 and $
            lat2 ge 39.5 and lat2 le 40.5) 


  for id = 0, ndates-1 do begin

   filen = filedir+'qfed2.emis_bc.005.'+dates[id]+'.nc4'
   nc4readvar, filen, 'biomass', biomass_
   biomass = make_array(nx,ny,val=0.)
   biomass[a] = biomass_[a]

   openw, lun, 'qfed.point_fires.emis_bc.'+dates[id]+'.rc', /get
   printf, lun, '### California Fires'
   printf, lun, 'source::'
   b = where(biomass gt 0)
   if(b[0] ne -1) then begin
    for ib = 0, n_elements(b)-1 do begin
     printf, lun, lat2[b[ib]], lon2[b[ib]], $
                  biomass[b[ib]]*area[b[ib]], $
                  '10000 13000', format='(2(f9.4,1x),e11.4,1x,a11)'
    endfor
   endif
   printf, lun, '::'
   free_lun, lun
  endfor

end
