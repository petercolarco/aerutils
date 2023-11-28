function xbits, data, start, number
    if ~keyword_set(number) then number=1
    ;
    seq_on = uint([1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768])
    mask = total(seq_on[start:start+number-1],/preserve_type) ; bit mask
    ;
    ; apply mask to extract bits
    result = data AND mask
    ;
    ; shift to get value of extracted bits
    xb = ishft(result,-start)
    ;
    return, byte(xb) ; convert to byte type and return
    end
