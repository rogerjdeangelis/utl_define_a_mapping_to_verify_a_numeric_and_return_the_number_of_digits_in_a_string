Define a mapping to verify a numeric and return the number of digits in a string

see
https://goo.gl/cQeBFD
https://communities.sas.com/t5/Base-SAS-Programming/How-to-define-a-format-for-a-character-value-differentiating-by/m-p/435022


INPUT
=====

  WORK.HAVE total obs=14

      CHRNUM

      000A00000001
      000B000001
      000C0001
      000D01
      OAB
      00F1

      0000000000000000000001
      000000000000000001
      00000000000001
      0000000001
      000001
      0001
      001
      01


  RULES (use a format)

     If chrNum is just digits return the length as a numeric
     otherwise return -1

     Examples

       0001           NUMBER_OF_DIGITS=4
       001            NUMBER_OF_DIGITS=3
       01             NUMBER_OF_DIGITS=2
       000A00000001   NUMBER_OF_DIGITS=-1
       000B000001     NUMBER_OF_DIGITS=-1

PROCESS
=======

     options cmplib=(work.functions);
     * functions in formats Rick Langston;
     * express t5he rule with FCMP;

     proc fcmp outlib=work.functions.locase;
       function chrLen(chrNum $) $22;
         if notdigit(chrNum) then chrDig=-1;
         else chrDig=length(chrNum);
       return(chrDig);
     endsub;
     run;quit;

     * put the function in a format;
     proc format;
       invalue chrDig other=[chrLen()];
     run;quit;

     * apply the format, note compress is needed because lenght would be default 8;
     data want;
       set have;
       number_of_digits=input(compress(chrNum),chrdig22.);
       put chrNum @24 number_of_digits=;
     run;quit;


OUTPUT
======

  WORK.WANT total obs=14

                                 NUMBER_
      CHRNUM                    OF_DIGITS

      000A00000001                  -1    * string has an alpha;
      000B000001                    -1
      000C0001                      -1
      000D01                        -1
      OAB                           -1
      00F1                          -1

      0000000000000000000001        22
      000000000000000001            18
      00000000000001                14
      0000000001                    10
      000001                         6
      0001                           4
      001                            3
      01                             2


*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


data have;
  format chrNum $22.;
  input chrNum;
cards4;
000A00000001
000B000001
000C0001
000D01
OAB
00F1
0000000000000000000001
000000000000000001
00000000000001
0000000001
000001
0001
001
01
;;;;
run;quit;


*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

* same as above;

options cmplib=(work.functions);
* functions in formats Rick Langston;
* express t5he rule with FCMP;

proc fcmp outlib=work.functions.locase;
  function chrLen(chrNum $) $22;
    if notdigit(chrNum) then chrDig=-1;
    else chrDig=length(chrNum);
  return(chrDig);
endsub;
run;quit;

* put the function in a format;
proc format;
  invalue chrDig other=[chrLen()];
run;quit;

* apply the format, note compress is needed because lenght would be default 8;
data want;
  set have;
  number_of_digits=input(compress(chrNum),chrdig22.);
  put chrNum @24 number_of_digits=;
run;quit;


