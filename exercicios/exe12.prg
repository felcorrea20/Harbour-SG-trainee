   setMode(25,80)

   clear

   nValor1 := 0
   nValor2 := 0
   nValor3 := 0

   @ 00,29 to 06,51 double
   @ 01,30 say "Valor 1....:"
   @ 02,30 say "Valor 2....:"
   @ 03,30 say "Valor 3....:"
   @ 04,30 to 04,50
   @ 05,30 say "Maior valor:"

   @ 01,43 get nValor1 picture "@E 9,999.99"
   @ 02,43 get nValor2 picture "@E 9,999.99"
   @ 03,43 get nValor3 picture "@E 9,999.99"
   read

   nMaior := nValor1

   if nValor2 > nMaior
      nMaior := nValor2
   endif

   if nValor3 > nMaior
      nMaior := nValor3
   endif

   @ 05,43 say nMaior picture "@E 9,999.99"

   @ 06,01 say ""
   inKey(0)
