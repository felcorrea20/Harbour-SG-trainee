   clear

   nValor1 := 0
   nValor2 := 0

   @ 01,01 say "Digite o primeiro valor:"
   @ 02,01 say "Digite o segundo valor.:"

   @ 01,26 get nValor1 picture "@E 9999.99"
   @ 02,26 get nValor2 picture "@E 9999.99"
   read

   nSoma          := nValor1 + nValor2
   nSubtracao     := nValor1 - nValor2
   nMultiplicacao := nValor1 * nValor2
   nDivisao       := nValor1 / nValor2

   @ 04,01 say "****** QUATRO OPERACOES MATEMATICAS ******"
   @ 05,01 say "SOMA.........:"
   @ 06,01 say "SUBTRACAO....:"
   @ 07,01 say "MULTIPLICACAO:"
   @ 08,01 say "DIVISAO......:"

   @ 05,16 say nSoma          picture "@E 99,999.99"
   @ 06,16 say nSubtracao     picture "@E 9,999.99"
   @ 07,16 say nMultiplicacao picture "@E 99,999,999.99"
   @ 08,16 say nDivisao       picture "@E 99,999.99"

