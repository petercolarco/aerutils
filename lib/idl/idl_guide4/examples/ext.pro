PRO ext

a=2.0
b=3.0
c=0.0
result=CALL_EXTERNAL('ext.so', 'ext_', a, b, c)

PRINT, 'The result of ', a, ' times ', b, ' is ', c

END
