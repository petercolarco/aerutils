PRO psclose, NOVIEW=noview, GV=gv
;Procedure to close and view a postscipt file
;(C) NCAS 2008

;Check !guide exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.
 PRINT, ''
 STOP
ENDIF

DEVICE, /CLOSE

IF (NOT KEYWORD_SET(noview)) THEN BEGIN
 IF ((NOT KEYWORD_SET(GV)) AND (NOT KEYWORD_SET(GHOSTVIEW))) THEN BEGIN
  com='display '
  IF KEYWORD_SET(!guide.portrait) THEN com=com+'-resize 80% '
  IF (!guide.portrait EQ 0) THEN com=com+'-rotate -90 '
  com=com+!guide.psfile
  SPAWN, com
 ENDIF
 
 IF KEYWORD_SET(GV) THEN BEGIN
  com='gv -seascape '+!guide.psfile
  SPAWN, com
 ENDIF
ENDIF

END
