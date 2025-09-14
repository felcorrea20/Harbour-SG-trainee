   clear

   nValor1 := 0
   nValor2 := 0

   @ 01,01 say "Digite o primeiro valor:"
   @ 02,01 say "Digite o segundo valor.:"

   @ 01,26 get nValor1 picture "@E 999.9"
   @ 02,26 get nValor2 picture "@E 999.9"
   read

   nTmp    := nValor1
   nValor1 := nValor2
   nValor2 := nTmp

   @ 04,01 say "VALORES TROCADOS"
   @ 05,01 say "Valor 1:"
   @ 06,01 say "Valor 2:"

   @ 05,10 say nValor1 picture "@E 999.9"
   @ 06,10 say nVAlor2 picture "@E 999.9"

