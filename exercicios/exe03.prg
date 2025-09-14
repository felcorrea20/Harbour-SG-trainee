   clear

   nValor1 := 0
   nValor2 := 0

   @ 01,01 say "Digite o primeiro valor:"
   @ 02,01 say "Digite o segundo valor.:"

   @ 01,26 get nValor1 picture "@E 999.9"
   @ 02,26 get nValor2 picture "@E 999.9"
   read

   nProduto := nValor1 * nValor2

   @ 04,01 say "Produto dos valores informados:"
   @ 04,32 say nProduto picture "@E 999,999.99"
