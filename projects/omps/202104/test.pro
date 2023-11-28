  pro line, x, a, y, pder
   y = a[0]*x+a[1]
print, n_params()
   if(n_params() ge 4) then  $
    pder = [[x],[replicate(1.,n_elements(x))]]
  end


  x = findgen(200)
  m = 1.
  b = -2.
  seed = 1001L
  y = m*x+b+randomu(seed,200)*m

  a = [m,b]
  yfit = curvefit(x,y,1./y,a, function_name='line')

end
