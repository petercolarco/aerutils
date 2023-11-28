; Colarco, Feb. 2006
; Driver code to make plots of aeronet AOT versus model AOT
; Options are to plot daily averages or monthly averages
; Requires database 'aeronet_locs.dat' which contains the locations
; of desired sites to plot on.

; Path to Experiment AOD values
  expid   = 'u000_c32_c'
  expPath = '/output/colarco/'+expid+'/tau/'

; Path to AERONET dataset
  aerPath = '/output/colarco/AERONET/AOT_Version2/'

; date range
  date0 = 20030501L
  date1 = 20030531L

  openr, lun, 'aeronet_locs.dat.1', /get_lun
  a = 'a'
  while(not eof(lun)) do begin
   readf, lun, a
   strparse = strsplit(a,' ',/extract)
   if(strpos(strparse[0],'#') eq -1) then begin
;   if(strparse[0] eq 'Mongu') then begin
    print, strparse[0]
    plot_aeronet, exppath, expid, aerPath, strparse[0], '500', date0, date1;, /modis
    plot_aeronet_angstrom, exppath, expid, aerPath, strparse[0], date0, date1
   endif
  endwhile
  free_lun, lun

end
