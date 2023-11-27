; DESEASONALIZE_MISS
; deseasonalizes a multi-dimensional set of timeseries x(m1,m2,...,t).
; year=length of year in timesteps
; accounts for missing values
;
function deseasonalize_miss, x, year, missing, cycle=annual, new=new_miss
;
xs   = size(x)
ndim = xs[0]
nt   = xs[ndim]
;
index    = where(x NE missing)
xmax     = max(abs(x(index)-mean(x(index))))
maxdec   = 10^(1.+ceil(alog10(xmax)))
new_miss = min([-99.0, 1.0 - maxdec])
;

case ndim of
1: begin			; single time series
   annual         = fltarr(year)
   deseasonalized = fltarr(nt)
   series = x
   index0 = where(series EQ missing, count0)
   index1 = where(series NE missing, count1)
   sum = fltarr(year)
   k   = lonarr(year)
   for t=0L,nt-1 do begin
     if (series[t] ne missing) then begin
       l      = t mod year
       k[l]   = k[l]+1
       sum[l] = sum[l]+series[t]
     endif
   endfor
   annual[0:year-1] = sum/k
   ind_ssn = index1 mod year
   if (count1 NE 0) then $
      deseasonalized[index1] = series[index1]-annual[ind_ssn]
   if (count0 NE 0) then $
      deseasonalized[index0] = new_miss
   end

2: begin
   m=xs[1]
   annual         = fltarr(m,year)
   deseasonalized = fltarr(m,nt)
   for i=0,m-1 do begin
     series = x[i,*]
     index0 = where(series EQ missing, count0)
     index1 = where(series NE missing, count1)
     sum = fltarr(year)
     k   = lonarr(year)
     for t=0L,nt-1 do begin
       if (series[t] ne missing) then begin
         l      = t mod year
         k[l]   = k[l]+1
         sum[l] = sum[l]+series[t]
       endif
     endfor
     annual[i,0:year-1] = sum/k
     ind_ssn = index1 mod year
     if (count1 NE 0) then $
        deseasonalized[i,index1] = series[index1]-annual[i,ind_ssn]
     if (count0 NE 0) then $
        deseasonalized[i,index0] = new_miss
   endfor
   end
3: begin
   m1=xs[1]
   m2=xs[2]
   annual         = fltarr(m1,m2,year)
   deseasonalized = fltarr(m1,m2,nt)
   for i=0,m1-1 do begin
     for j=0,m2-1 do begin
       series = x[i,j,*]
       index0 = where(series EQ missing, count0)
       index1 = where(series NE missing, count1)
       sum = fltarr(year)
       k   = lonarr(year)
       for t=0L,nt-1 do begin
         if (series[t] ne missing) then begin
           l      = t mod year
           k[l]   = k[l]+1
           sum[l] = sum[l]+series[t]
         endif
       endfor
       annual[i,j,0:year-1] = sum/k
       ind_ssn = index1 mod year
       if (count1 NE 0) then $
          deseasonalized[i,j,index1] = series[index1]-annual[i,j,ind_ssn]
       if (count0 NE 0) then $
          deseasonalized[i,j,index0] = new_miss
     endfor
   endfor
   end
4: begin
   m1=xs[1]
   m2=xs[2]
   m3=xs[3]
   annual         = fltarr(m1,m2,m3.year)
   deseasonalized = fltarr(m1,m2,m3.nt)
   for i=0,m1-1 do begin
     for j=0,m2-1 do begin
       for k=0,m2-1 do begin
         series = x[i,j,k,*]
         index0 = where(series EQ missing, count0)
         index1 = where(series NE missing, count1)
         sum = fltarr(year)
         k   = lonarr(year)
         for t=0L,nt-1 do begin
           if (series[t] ne missing) then begin
             l      = t mod year
             k[l]   = k[l]+1
             sum[l] = sum[l]+series[t]
           endif
         endfor
         annual[i,j,k,0:year-1] = sum/k
         ind_ssn = index1 mod year
         if (count1 NE 0) then $
            deseasonalized[i,j,k,index1] = series[index1]-annual[i,j,k,ind_ssn]
         if (count0 NE 0) then $
            deseasonalized[i,j,k,index0] = new_miss
       endfor
     endfor
   endfor
   end
else: begin
      print, 'Error (DESEASONALIZE_MISS): '
      print, '  Data arrays with more than 4 dimensions are not supported'
      stop
      end
endcase
;
return, deseasonalized
end
