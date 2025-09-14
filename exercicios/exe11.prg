   clear

   cNome      := Space(20)
   nIdade     := 0
   cCategoria := ""
   cColor     := ""

   @ 00,00 to 04,32
   @ 01,01 say "NOME.....:"
   @ 02,01 say "IDADE....:"
   @ 03,01 say "CATEGORIA:"

   @ 01,12 get cNome  picture "@!"  valid !Empty(cNome)
   @ 02,12 get nIdade picture "999" valid (nIdade >= 0) .and. (nIdade <= 150)
   read

   if (nIdade >= 5) .and. (nIdade <= 7)
     cCategoria := "INFANTIL A"
     cColor     := "W/N"
   elseif (nIdade >= 8) .and. (nIdade <= 10)
     cCategoria := "INFANTIL B"
     cColor     := "N/W"
   elseif (nIdade >= 11) .and. (nIdade <= 13)
     cCategoria := "JUVENIL A"
     cColor     := "B/N"
   elseif (nIdade >= 14) .and. (nIdade <= 17)
     cCategoria := "JUVENIL B"
     cColor     := "Y/N"
   elseif (nIdade >= 18)
     cCategoria := "SENIOR"
     cColor     := "G/N"
   else
     cCategoria := "SEM CATEGORIA"
     cColor     := "R/N"
   endif

   @ 03,12 say cCategoria color cColor
   @ 05,01 say ""

