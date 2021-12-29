10 rem screen configuration
20 poke 53280,13
30 poke 53281,6
40 print chr$(147);
50 open 15,8,15
60 rem variable declarations
70 dim f1%(42),f2%(42),m%(42,42)
80 dim v%,j,i
90 rem initialise screen
100 print chr$(147);
110 print "    neuron network associative memory"
120 print
130 for i=1 to 12: print chr$(17);: next i
140 print "f1 - teach pattern     ";
150 print "f2 - dump matrix"
160 print "f3 - randomize pattern ";
170 print "f4 - forget all"
180 print "f5 - recall pattern    ";
190 print "f6 - quit"
200 print "f7 - disc save         ";
210 print "f8 - disc load"
220 print
230 print "a-z, 0-9: load pattern"
240 r1 = 4 : c1 = 5 : gosub 600
250 r1 = 4 : c1 = 25 : gosub 600
260 gosub 750
270 gosub 860
280 gosub 970:print " ready    "
290 get a$ : if a$="" goto 290
300 gosub 970:print "          "
310 k=asc(a$)
320 ifa$>="0"anda$<="9"thenk=k+64:goto340
330 if a$ < "a" or a$ > "z" then 500
340 gosub 970:print "fetch ";a$
350 l%=0
360 k=(k-64)*8+53248
370 poke56333,127:poke 1,peek(1)and251
380 fori=0to6:poke49408+i,peek(k+i):next
390 poke 1,peek(1) or 4:poke 56333,129
400 for i = 0 to 6
410 j% = peek(49408+i)/2
420 for k=1 to 6
430 l%=l%+1
440 f1%(l%) = -1 + (2 * (j% and 1))
450 j%=j%/2
460 next k
470 next i
480 gosub 750 : gosub 860 : goto 280
490 rem dispatch function key commands
500 j%=asc(a$)-132
510 if j%=1 then gosub 1000:goto 280
520 if j%=5 then gosub 1080:goto 90
530 if j%=2 then gosub 1210:goto 280
540 if j%=6 then gosub 1680:goto 280
550 if j%=3 then gosub 1290:goto 280
560 if j%=7 then print chr$(147);:close15:end
570 if j%=4 then gosub 1800:goto 90
580 if j%=8 then gosub 1990:goto 90
590 go to 280
600 rem draw borders for fields
610 for i=0 to 1
620 v=1024+40*(r1+(i*8))+c1
630 poke v,112+(-3*i)
640 for j=1 to 8
650 poke v+j,67
660 next j
670 poke v+9,110+(15*i)
680 next i
690 for i=1 to 7
700 v=1024+40*(r1+i)+c1
710 poke v,93
720 poke v+9,93
730 next i
740 return
750 rem update field f2% on screen
760 l%=0
770 for i=0 to 6
780 v% = 1024+40*(i+5)+6
790 for j=2 to 7
800 l%=l%+1
810 iff1%(l%)=1thenpokev%+(8-j),81:goto830
820 poke v%+(8-j),32
830 next j
840 next i
850 return
860 rem update field f1% on screen
870 l%=0
880 for i = 0 to 6
890 v%=1024+40*(i+5)+26
900 for j=2 to 7
910 l%=l%+1
920 if f2%(l%)=1 then poke v%+(8-j),81:goto 940
930 poke v%+(8-j),32
940 next j
950 next i
960 return
970 rem position to status area
980 print chr$(19);
982 for i=1 to 21: print chr$(17);: next i
990 return
1000 rem train on pattern in f1%
1010 gosub 970:print "training"
1020 for i = 1 to 42
1030 for j = 1 to 42
1040 m%(i,j)=m%(i,j)+f1%(i)*f1%(j)
1050 next j
1060 next i
1070 return
1080 rem print part of matrix
1090 print chr$(147);
1100 for i=1 to 24
1110 for j=1 to 39
1120 ifm%(i,j)<0thenprint chr$(150);:goto1140
1130 print chr$(154);
1140 print chr$(asc("0")+abs(m%(i,j)));
1150 next j
1160 print
1170 next i
1180 print chr$(154);"press any key to continue:";
1190 get a$ : if a$="" goto 1190
1200 return
1210 rem randomise 10 percent of f1%
1220 gosub 970:print "random"
1230 for i=1 to 42
1240 if rnd(0) > 0.1 then 1260
1250 f1%(i)=-f1%(i)
1260 next i
1270 gosub 750
1280 return
1290 rem recall from pattern
1300 gosub 970:print "recall"
1310 p%=1024+40*9+19
1320 rem initially copy f1 to f2
1330 poke p%+1,asc("=")
1340 for i=1 to 42
1350 f2%(i)=f1%(i)
1360 next i
1370 gosub 860
1380 rem f1 to f2 pass
1390 poke p%,asc("=")
1400 poke p%+2,asc(">")
1410 for j=1 to 42
1420 v%=0
1430 for i=1 to 42
1440 v%=v%+f1%(i)*m%(i,j)
1450 next i
1460 v%=sgn(v%)
1470 if v%<>0 then f2%(j)=v%
1480 next j
1490 gosub 860
1500 rem f2 to f1 pass
1510 c%=0
1520 poke p%,asc("<")
1530 poke p%+2,asc("=")
1540 for i=1 to 42
1550 v%=0
1560 for j=1 to 42
1570 v%=v%+f2%(j)*m%(i,j)
1580 next j
1590 v%=sgn(v%)
1600 ifv%<>0andv%<>f1%(i)thenf1%(i)=v%:c%=1
1610 next i
1620 gosub 750
1630 if c%<>0 goto 1380
1640 poke p%,asc(" ")
1650 poke p%+1,asc(" ")
1660 poke p%+2,asc(" ")
1670 return
1680 rem forget all - clear memory
1690 gosub 970:print "forget"
1700 for i=1 to 42
1710 f1%(i)=0
1720 f2%(i)=0
1730 for j=1 to 42
1740 m%(i,j)=0
1750 next j
1760 next i
1770 gosub 750
1780 gosub 860
1790 return
1800 rem save state to disc file
1810 gosub 970:print "save"
1820 print "";
1830 input "file name: ";a$
1840 a$="@0:"+a$+",s,w"
1850 open 5,8,5,a$
1860 for i=1 to 42:print#5,f1%(i):next
1870 gosub 2240
1880 for i=1 to 42:print#5,f2%(i):next
1890 gosub 2240
1900 for i=1 to 42
1910 for j=1 to 42
1920 print#5,m%(i,j)
1930 next j
1940 gosub 2240
1950 next i
1960 close 5
1970 print "";
1980 return
1990 rem restore state from disc file
2000 gosub 970:print "restore"
2010 print "";
2020 input "file name: ";a$
2030 a$="@0:"+a$+",s,r"
2040 p%=asc("m")
2050 gosub 2240
2060 open 5,8,5,a$
2070 for i=1 to 42
2080 input#5,f1%(i)
2090 next i
2100 gosub 2240
2110 for i=1 to 42
2120 input#5,f2%(i)
2130 next i
2140 gosub 2240
2150 for i=1 to 42
2160 for j=1 to 42
2170 input#5,m%(i,j)
2180 next j
2190 gosub 2240
2200 next i
2210 close 5
2220 return
2230 rem disc error check
2240 input#15,en,em$,et,es
2250 if en>0then print en,em$,et,es:stop
2260 return
