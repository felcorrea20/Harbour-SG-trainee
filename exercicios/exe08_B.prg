   setMode(25,80)
   set date to british
   set epoch to 1940

   clear

   //variaveis tela 1
   cNomeCliente        := Space(20)
   dNascimentoCliente  := CToD("")
   cEnderecoCliente    := Space(40)
   nLimiteCompra       := 0
   lLimiteUltrapassado := .f.

   //variaveis tela 2
   cNomeProdutoA     := Space(15)
   cNomeProdutoB     := Space(15)
   cNomeProdutoC     := Space(15)
   nPrecoProdutoA    := 0
   nPrecoProdutoB    := 0
   nPrecoProdutoC    := 0
   nQtdProdutoA      := 0
   nQtdProdutoB      := 0
   nQtdProdutoC      := 0
   nLimiteDisponivel := 0
   nTotalCompra      := 0
   cCorTotalCompra   := "G/N"

   //variaveis para cupom fiscal
   lEntrega     := .t.
   cEntrega     := Space(1)
   dDataEntrega := Date() + 5
   nTaxaEntrega := 0.02        //(2%)
   nTotalVenda  := 0          //com a taxa de entrega

   //variaveis auxiliares
   nLinhaLimite       := 7
   nLinhaTotalCompra  := 8
   nLinhaProdutoA     := 3
   nLinhaProdutoB     := 4
   nLinhaProdutoC     := 5
   nColunaLimite      := 24
   nColunaTotalCompra := 24
   nColunaProduto     := 2
   nColunaPreco       := 23
   nColunaQtd         := 31
   nColunaTotal       := 40
//=============================================================================
   @ 00,00 to 07,44
   @ 01,01 say " NOME DO CLIENTE      | DATA DE NASCIMENTO "
   @ 02,23 say "|"
   @ 03,01 say " ENDERECO DO CLIENTE "
   @ 05,01 say " LIMITE DE COMPRA"
   @ 06,01 say " R$"

   @ 02,02 get cNomeCliente       picture "@!"              valid !Empty(cNomeCliente)
   @ 02,25 get dNascimentoCliente                           valid dNascimentoCliente <= Date()
   @ 04,02 get cEnderecoCliente   picture "@!"              valid !Empty(cEnderecoCliente)
   @ 06,05 get nLimiteCompra      picture "@E 9,999,999.99" valid nLimiteCompra > 0
   read

   nLimiteDisponivel := nLimiteCompra

   @ 08,01 say "GRAVANDO DADOS"
   nColunaTmp := 15
   do while  nColunaTmp != 18
      inKey(0.3)
      @ 08,nColunaTmp say "."
      nColunaTmp++
   enddo
   inKey(0.5)

//=============================================================================
   clear

   @ 00,00 to 10,50
   @ 01,01 say " PRODUTO         | PRECO    | QTD | TOTAL        "
   @ 02,01 to 02,49
   @ 03,01 say "                 | R$       |     | R$           "
   @ 04,01 say "                 | R$       |     | R$           "
   @ 05,01 say "                 | R$       |     |              "
   @ 06,01 to 06,49
   @ 07,01 say " LIMITE DISPONIVEL: R$"
   @ 08,01 say " TOTAL DA COMPRA..: R$"
   @ 09,01 say " PEDIDO PARA ENTREGA? "
//=============================================================================
   @ nLinhaProdutoA,nColunaProduto get cNomeProdutoA  picture "@!"        valid !Empty(cNomeProdutoA)
   @ nLinhaProdutoA,nColunaPreco   get nPrecoProdutoA picture "@E 999.99" valid nPrecoProdutoA > 0
   @ nLinhaProdutoA,nColunaQtd     get nQtdProdutoA   picture "999"       valid nQtdProdutoA > 0
   read

   nTotalProdutoA    := nQtdProdutoA * nPrecoProdutoA
   nLimiteDisponivel -= nTotalProdutoA
   nTotalCompra      += nTotalProdutoA

   if nTotalCompra > nLimiteCompra
      lLimiteUltrapassado := .t.
      cCorTotalCompra     := "R/N"
   endif

   @ nLinhaProdutoA,nColunaTotal          say nTotalProdutoA    picture "@E 999,999.99"
   @ nLinhaLimite, nColunaLimite          say nLimiteDisponivel picture "@E 9,999,999.99"
   @ nLinhaTotalCompra,nColunaTotalCompra say nTotalCompra      picture "@E 9,999,999.99" color cCorTotalCompra
//=============================================================================
   @ nLinhaProdutoB,nColunaProduto get cNomeProdutoB  picture "@!"        valid !Empty(cNomeProdutoB)
   @ nLinhaProdutoB,nColunaPreco   get nPrecoProdutoB picture "@E 999.99" valid nPrecoProdutoB > 0
   @ nLinhaProdutoB,nColunaQtd     get nQtdProdutoB   picture "999"       valid nQtdProdutoB > 0
   read

   nTotalProdutoB := nQtdProdutoB * nPrecoProdutoB
   nLimiteDisponivel -= nTotalProdutoB
   nTotalCompra   += nTotalProdutoB

   if nTotalCompra > nLimiteCompra
      lLimiteUltrapassado := .t.
      cCorTotalCompra     := "R/N"
   endif

   @ nLinhaProdutoB,nColunaTotal          say nTotalProdutoB    picture "@E 999,999.99"
   @ nLinhaLimite, nColunaLimite          say nLimiteDisponivel picture "@E 9,999,999.99"
   @ nLinhaTotalCompra,nColunaTotalCompra say nTotalCompra      picture "@E 9,999,999.99" color cCorTotalCompra
//=============================================================================
   @ nLinhaProdutoC,nColunaProduto get cNomeProdutoC  picture "@!"        valid !Empty(cNomeProdutoC)
   @ nLinhaProdutoC,nColunaPreco   get nPrecoProdutoC picture "@E 999.99" valid nPrecoProdutoC > 0
   @ nLinhaProdutoC,nColunaQtd     get nQtdProdutoC   picture "999"       valid nQtdProdutoC > 0
   read

   nTotalProdutoC    := nQtdProdutoC * nPrecoProdutoC
   nLimiteDisponivel -= nTotalProdutoC
   nTotalCompra      += nTotalProdutoC

   if nTotalCompra > nLimiteCompra
      lLimiteUltrapassado := .t.
      cCorTotalCompra     := "R/N"
   endif

   @ nLinhaProdutoC,nColunaTotal          say nTotalProdutoC    picture "@E 999,999.99"
   @ nLinhaLimite, nColunaLimite          say nLimiteDisponivel picture "@E 9,999,999.99"
   @ nLinhaTotalCompra,nColunaTotalCompra say nTotalCompra      picture "@E 9,999,999.99" color cCorTotalCompra
//=============================================================================
if lLimiteUltrapassado
   @ 11,00 to 14,50
   @ 12,02 say "LIMITE ULTRAPASSADO"
   @ 13,02 say "NAO FOI POSSIVEL FINALIZAR A VENDA..."
else

   @ 09,23 get cEntrega picture "@!" valid (Empty(cEntrega) .or. cEntrega == "S") .or. cEntrega == "N"
   read

   if cEntrega == "N"
      lEntrega := .f.
   endif

   @ 11,01 say "GERANDO CUPOM FISCAL"
   nColunaTmp := 21
   do while  nColunaTmp != 24
      inKey(0.5)
      @ 11,nColunaTmp say "."
      nColunaTmp++
   enddo
   inKey(0.5)

//=============================================================================
   clear

   @ 00,00 to 19,63 double

   @ 01,01 say " CLIENTE............: " + cNomeCliente
   @ 02,01 say " DATA DE NASCIMENTO.:"
   @ 02,23 say dNascimentoCliente
   @ 03,01 say " DATA DA VENDA......:"
   @ 03,23 say Date()

   @ 04,01 to 04,62

   @ 05,01 say " PRODUTO         | PRECO    | QTD | TOTAL        "
   @ 06,01 to 06,62
   @ 07,01 say "                 | R$       |     | R$           "
   @ 08,01 say "                 | R$       |     | R$           "
   @ 09,01 say "                 | R$       |     | R$           "

   @ 07,nColunaProduto say cNomeProdutoA
   @ 07,nColunaPreco   say nPrecoProdutoA picture "@E 999.99"
   @ 07,nColunaQtd     say nQtdProdutoA
   @ 07,nColunaTotal   say nTotalProdutoA picture "@E 999,999.99"

   @ 08,nColunaProduto say cNomeProdutoB
   @ 08,nColunaPreco   say nPrecoProdutoB picture "@E 999.99"
   @ 08,nColunaQtd     say nQtdProdutoB
   @ 08,nColunaTotal   say nTotalProdutoB picture "@E 999,999.99"

   @ 09,nColunaProduto say cNomeProdutoC
   @ 09,nColunaPreco   say nPrecoProdutoC picture "@E 999.99"
   @ 09,nColunaQtd     say nQtdProdutoC
   @ 09,nColunaTotal   say nTotalProdutoC picture "@E 999,999.99"

   @ 10,01 to 10,62

   if lEntrega
      nTaxaEntrega *= nTotalCompra
      nTotalVenda  := nTotalCompra + nTaxaEntrega

      @ 11,01 say " ENDERECO ENTREGA...: " + cEnderecoCliente
      @ 12,01 say " DATA PARA ENTREGA..:"
      @ 12,23 say dDataEntrega
      @ 13,01 say " TAXA ENTREGA.......: R$" + Transform(nTaxaEntrega, "@E 999,999.99 ")
      @ 14,01 say " TOTAL DA VENDA.....: R$" + Transform(nTotalVenda, "@E 9,999,999.99")
   else
      nTotalVenda := nTotalCompra

      @ 13,01 say " TOTAL DA VENDA.....: R$" + Transform(nTotalVenda, "@E 9,999,999.99")
   endif

   @ 16,10 to 16,52

   @ 17,20 say "AGRADECEMOS A PREFERENCIA"
   @ 18,25 say "VOLTE SEMPRE :)"

endif

   @ 20,01 say ""
