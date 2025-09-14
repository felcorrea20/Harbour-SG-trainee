   clear

   nValor1 := 0
   nValor2 := 0
   nValor3 := 0

   @ 01,01 say "Digite o primeiro valor:"
   @ 02,01 say "Digite o segundo valor.:"
   @ 03,01 say "Digite o terceiro valor:"

   @ 01,26 get nValor1 picture "@E 999.9"
   @ 02,26 get nValor2 picture "@E 999.9"
   @ 03,26 get nValor3 picture "@E 999.9"
   read

   nMedia := (nValor1 + nValor2 + nValor3) / 3

   @ 05,01 say "Media dos valores informados:"
   @ 05,31 say nMedia picture "@E 999.99"
