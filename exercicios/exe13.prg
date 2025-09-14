   setMode(25,80)

   clear

   nContador := 0

   do while nContador != 3

      nCodigoProduto := 0
      cClassificacao := ""

      @ 00,00 to (03+nContador),48
      @ 01,01             say " COD PRODUTO | CLASSIFICACAO"
      @ (02+nContador),01 clear to (02+nContador),47
      @ (02+nContador),14 say "|"

      @ (02+nContador),07 get nCodigoProduto picture "99" valid nCodigoProduto > 0 .and. nCodigoProduto < 16
      read

      if nCodigoProduto == 1
         cClassificacao := Upper("Alimento nao-perecivel")
         cColor         := "W/R"
      elseif (nCodigoProduto >= 2) .and. (nCodigoProduto <= 4)
         cClassificacao := Upper("Alimento perecivel")
         cColor         := "N/W"
      elseif (nCodigoProduto == 5) .or. (nCodigoProduto == 6)
         cClassificacao := Upper("Vestuario")
         cColor         := "B/N"
      elseif (nCodigoProduto == 7)
         cClassificacao := Upper("Higiene pessoal")
         cColor         := "R/N"
      else
         cClassificacao := Upper("Limpeza e utensilios domesticos")
         cColor         := "G/W"
      endif

      @ (02+nContador),07 say nCodigoProduto
      @ (02+nContador),16 say cClassificacao color cColor

      nContador++
   enddo

   @ 05,01 say ""
