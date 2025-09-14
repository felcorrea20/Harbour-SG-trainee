   set date to british
   set scoreBoard off

   clear

   cNomeCliente   := Space(20)
   cCpfCliente    := Space(14)
   cNomeProdutoA  := Space(10)
   cNomeProdutoB  := Space(10)
   cNomeProdutoC  := Space(10)
   nPrecoProdutoA := 0
   nPrecoProdutoB := 0
   nPrecoProdutoC := 0
   nQtdProdutoA   := 0
   nQtdProdutoB   := 0
   nQtdProdutoC   := 0
   nTotalCompra   := 0
   dDataAtual     := Date()

//=============================================================================
   @ 00,00 to 03,43 double
   @ 01,01 say "   NOME DO CLIENTE     |        CPF       "

   @ 02,02 get cNomeCliente picture "@!" valid !Empty(cNomeCliente)
   @ 02,26 get cCpfCliente
   read

   @ 04,01 say "DIGITE QUALQUER TECLA PARA CONTINUAR..."
   InKey(0)
//=============================================================================
   clear
   @ 01,00 to 06,57 double
   @ 02,01 say "  PRODUTO   |    PRECO    | QUANTIDADE |    TOTAL     "
   @ 03,01 say "            | R$          |            | R$           "
   @ 04,01 say "            | R$          |            | R$           "
   @ 05,01 say "            | R$          |            | R$           "

   @ 07,00 to 09,57 double //traca uma reta na linha 07
   @ 08,01 say " TOTAL DA COMPRA: R$"
//=============================================================================
   @ 03,02 get cNomeProdutoA  picture "@!"        valid !Empty(cNomeProdutoA)
   @ 03,18 get nPrecoProdutoA picture "@E 999.99" valid nPrecoProdutoA > 0
   @ 03,32 get nQtdProdutoA   picture "999"       valid nQtdProdutoA >= 0
   read

   nTotalProdutoA := nQtdProdutoA * nPrecoProdutoA
   nTotalCompra   += nTotalProdutoA

   @ 03,02 say AllTrim(cNomeProdutoA)
   @ 03,45 say nTotalProdutoA picture "@E 999,999.99"
   @ 08,22 say nTotalCompra   picture "@E 9,999,999.99"
//=============================================================================
   @ 04,02 get cNomeProdutoB  picture "@!"        valid !Empty(cNomeProdutoB)
   @ 04,18 get nPrecoProdutoB picture "@E 999.99" valid nPrecoProdutoB > 0
   @ 04,32 get nQtdProdutoB   picture "999"       valid nQtdProdutoB >= 0
   read

   nTotalProdutoB := nQtdProdutoB * nPrecoProdutoB
   nTotalCompra   += nTotalProdutoB

   @ 04,02 say AllTrim(cNomeProdutoB)
   @ 04,45 say nTotalProdutoB picture "@E 999,999.99"
   @ 08,22 say nTotalCompra   picture "@E 9,999,999.99"
//=============================================================================
   @ 05,02 get cNomeProdutoC  picture "@! "       valid !Empty(cNomeProdutoC)
   @ 05,18 get nPrecoProdutoC picture "@E 999.99" valid nPrecoProdutoC > 0
   @ 05,32 get nQtdProdutoC   picture "999"       valid nQtdProdutoC >= 0
   read

   nTotalProdutoC := nQtdProdutoC * nPrecoProdutoC
   nTotalCompra   += nTotalProdutoC

   @ 05,02 say AllTrim(cNomeProdutoC)
   @ 05,45 say nTotalProdutoC picture "@E 999,999.99"
   @ 08,22 say nTotalCompra   picture "@E 9,999,999.99"
//=============================================================================
   @ 10,01 say "[      ]"
   InKey(1)
   @ 10,02 say "="
   InKey(1)
   @ 10,03 say "="
   InKey(1)
   @ 10,04 say "="
   InKey(1)
   @ 10,05 say "="
   InKey(1)
   @ 10,06 say "="
//=============================================================================
   @ 06,00 clear to 09,57  //limpa o conteudo
   @ 01,00 to 15,57 double //reescreve a caixinha

   @ 08,01 say " TOTAL DA COMPRA: R$" + Transform(nTotalCompra, "@E 9,999,999.99")
   @ 09,01 say " CLIENTE........: " + AllTrim(cNomeCliente)
   @ 10,01 say " CPF............: " + AllTrim(cCpfCliente)
   @ 11,01 say " DATA...........: "
   @ 11,19 say dDataAtual
   @ 13,17 say "AGRADECEMOS A PREFERENCIA"
   @ 14,22 say " VOLTE SEMPRE :)"
//=============================================================================

   @ 24,01 say ""
