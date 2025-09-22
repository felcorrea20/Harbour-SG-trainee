   set date british
   set epoch to 1940
   setMode(25,80)

   clear

   dDataAtual       := Date()
   nAnoNascimento   := 0
   nDiferencaDeAnos := 0

   @ 01,01 say "DIGITE O ANO QUE VC NASCEU:"
   @ 01,29 get nAnoNascimento picture "9999"
   read

   nDiferencaDeAnos := Year(Date()) - nAnoNascimento
   @ 02,01 say "RETORNO DA FUNCAO Year(Date()) : "
   @ 02,34 say Year(Date())
   @ 03,01 say "VOCE TEM:" + Transform(nDiferencaDeAnos, "9999")
