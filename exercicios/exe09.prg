   set epoch to 1940   //limitador de seculos -> 00-39 (2000) e 40-99 (1900)
   set date to british //padrao britanico (DD/MM/YY)

   clear

   cLetra   := space(1)
   dData    := CToD("") // caracter to date
   nInteiro := 0
   nDecimal := 0
   cString  := space(10)

   @ 00,00 to 06,23 double
   @ 01,01 say " LETRA..:"
   @ 02,01 say " DATA...:"
   @ 03,01 say " INTEIRO:"
   @ 04,01 say " DECIMAL:"
   @ 05,01 say " STRING.:"

   @ 01,12 get cLetra   picture "@!"       valid !Empty(cLetra)
   @ 02,12 get dData                       valid dData <= Date()
   @ 03,12 get nInteiro picture "999"
   @ 04,12 get nDecimal picture "@E 999.99"
   @ 05,12 get cString  picture "@!"       valid !Empty(cString)
   read
