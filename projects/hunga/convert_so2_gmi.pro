; Read degassing SO2 file and convert to GMI format

openr, lun0, 'so2_volcanic_emissions_CARN_v202106.degassing_only.rc', /get
openw, lun1, 'so2_volcanic_emissions_CARN_v202106.GMI.degassing_only.rc', /get

; Read and write the header
str = 'a'
readf, lun0, str
printf, lun1, '###  LAT (-90,90), LON (-180,180), SULFUR [kg SO2/s], ELEVATION [m], CLOUD_COLUMN_HEIGHT [m]'
readf, lun0, str
printf, lun1, str
readf, lun0, str
printf, lun1, str
readf, lun0, str
printf, lun1, 'SO2::'

while(not(eof(lun0))) do begin
readf, lun0, str
if(str eq '::') then goto, jump
str_ = strsplit(str,' ',/extract)
str_[2] = string(float(str_[2]*2.),format='(e11.4)')
printf, lun1, str_[0],' ',str_[1],' ',str_[2],' ',str_[3],' ',str_[4], $
        ' 000000 240000'
endwhile
jump:
printf, lun1, '::'

free_lun, lun0
free_lun, lun1

end
