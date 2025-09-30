setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center
set wrap on

// admin    
cUsuarioAdmin := 'ADMIN'
cSenhaAdmin   := '123mudar'

// supervisor
cSenhaSupervisor := '123LIBERA'

do while .t.  // programa principal
    clear

    cUsuario := Space(15)
    cSenha   := Space(15)

    @ 01,01 say ' TELA DE LOGIN '
    @ 02,01 say 'Usuario: '
    @ 03,01 say 'Senha..: '

    @ 02,11 get cUsuario picture '@!' valid !Empty(cUsuario)
    @ 03,11 get cSenha                valid !Empty(cSenha) 
    read

    if LastKey() == 27 
        nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

        if nEscolha == 1
            exit
        endif
        loop
    endif 

    if !(AllTrim(cUsuario) == cUsuarioAdmin .and. AllTrim(cSenha) == cSenhaAdmin) 
        Alert('Usuario ou senha incorretas!')
        loop
    endif

    do while .t.  // ordem de servico
        clear

        // ordem de servico
        nOrdemServico         := 1 
        cNomeCliente          := Space(40)
        dOrdemServico         := Date()
        cNomeTecnico          := Space(30)  
        cDescricaoEquipamento := Space(40)
        dCompra               := CToD('')
        nLimiteCredito        := 0
        cTipoServico          := Space(1)  // produto ou servico  
        nValorTotalOrdem      := 0

        // entrega
        cEntrega     := Space(1)
        cEndereco    := Space(40)
        cBairro      := Space(40)
        cReferencia  := Space(40)
        nTaxaEntrega   := 0.3

        // para validar telefone
        cTelefone      := ''
        nDDD           := 0
        nPrimeiraParte := 0
        nSegundaParte  := 0    

        // SUPERVISOR
        cUsuario := Space(15)
        cSenha   := Space(15)

        @ 00,00 to 24,79
        @ 00,30 say ' DADOS DA ORDEM DE SERVICO '
        @ 01,01 say 'Numero da Ordem de Servico.: ' + Transform(nOrdemServico, '99999999')
        @ 02,01 say 'Nome do cliente............: '
        @ 03,01 say 'Data da Ordem de Servico...: ' + DToC(dOrdemServico)
        @ 04,01 say 'Nome do tecnico............: '
        @ 05,01 say 'Descricao do equipamento...: '
        @ 06,01 say 'Entrega a domicilio........:   [S]im [N]ao'
        @ 07,01 say 'Limite de credito - cliente: ' 

        @ 02,30 get cNomeCliente          picture '@!'              valid !Empty(cNomeCliente)
        @ 03,30 get dOrdemServico             
        @ 04,30 get cNomeTecnico          picture '@!'              valid !Empty(cNomeTecnico)
        @ 05,30 get cDescricaoEquipamento picture '@!'              valid !Empty(cDescricaoEquipamento)
        @ 06,30 get cEntrega              picture '@!'              valid cEntrega $ 'SN'
        @ 07,30 get nLimiteCredito        picture '@E 9,999,999.99' valid nLimiteCredito > 0
        read 

        if LastKey() == 27 
            nEscolha := Alert('Deseja cancelar ordem de servico? ', {'Sim', 'Nao'})
            if nEscolha == 1
                exit
            endif
            loop
        endif

        if cEntrega == 'S'
            @ 08,01 to 08,78
            @ 08,30 say ' DADOS PARA ENTREGA '
            @ 09,01 say 'Endereco...: '
            @ 10,01 say 'Bairro.....: '
            @ 11,01 say 'Referencia.: '
            @ 12,01 say 'Telefone...: (  ) 9      -     '

            @ 09,15 get cEndereco      picture '@!'   valid !Empty(cEndereco) 
            @ 10,15 get cBairro        picture '@!'   valid !Empty(cBairro)
            @ 11,15 get cReferencia    picture '@!'   valid !Empty(cReferencia)
            @ 12,15 get nDDD           picture '99'   valid !Empty(nDDD)
            @ 12,21 get nPrimeiraParte picture '9999' valid !Empty(nPrimeiraParte)
            @ 12,27 get nSegundaParte  picture '9999' valid !Empty(nSegundaParte) 
            read

            if LastKey() == 27 
                nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                if nEscolha == 1
                    exit
                endif
                loop
            endif

            cTelefone := AllTrim(Str(nDDD)) + ' 9' + AllTrim(Str(nPrimeiraParte)) + '-' + AllTrim(Str(nSegundaParte))
        endif

        @ 08,01 clear to 24,78

        @ 09,01 to 09,78 
        @ 09,30 say ' PRODUTOS '
        @ 10,01 say 'DESCRICAO                   | QUANTIDADE | PRECO UNIT | DESC % | VALOR TOTAL'

        @ 16,01 to 16,78
        @ 16,30 say ' SERVICOS '
        @ 17,01 say 'DESCRICAO                   | DESCONTO % | COMISSAO TECNICO %  | PRECO TOTAL'

        // controle de linhas
        nLinhaProd := 10
        nLinhaServ := 17

        do while .t.  // produtos / servicos
            cEscolhaPS := Space(1)

            // produto
            cDescricaoProd  := Space(30)
            nQtdProd        := 0
            nPrecoUnitario  := 0
            nDescontoProd   := 0
            nValorTotalProd := 0

            // servico
            cDescricaoServ   := Space(25)
            nDescontoServ    := 0 
            nComissaoTecnico := 0
            nPrecoTotalServ  := 0
            
            cSenhaDigitada := Spcae(10)

            @ 08,01 say 'Escolha:   [P]roduto [S]ervico'

            @ 08,09 get cEscolhaPS picture '@!' valid cEscolhaPS $ 'PS'
            read

            if LastKey() == 27
                nEscolha := Alert('O que deseja fazer? ', {'Cancelar', 'Retornar', 'Processar'})

                if nEscolha == 2
                    loop
                endif
                exit
            endif

            if cEscolhaPS == 'P'
                @ nLinhaProd,01 get cDescricaoProd picture '@!'                valid !Empty(cDescricaoProd)
                @ nLinhaProd,35 get nQtdProd       picture '9999'              valid nQtdProd > 0
                @ nLinhaProd,46 get nPrecoUnitario picture '@E 999,999,999.99' valid nPrecoUnitario > 0
                @ nLinhaProd,57 get nDescontoProd  picture '@E 999.99'         valid nDescontoProd >= 0 .and. nDescontoProd <= 100
            
                nValorTotalProd  := (nQtdProd * nPrecoUnitario)
                nValorTotalProd  -= (nQtdProd * nPrecoUnitario)  * (nDescontoProd / 100)

                if nLimiteCredito < nValorTotalProd
                    Alert('Limite ultrapassado! Digite a senha para liberar produto')

                    @ 23,01 say 'Digite a senha: '
                    @ 23,18 get cSenhaDigitada valid !Empty(cSenhaDigitada)
                    read

                    if LastKey() == 27
                        nEscolha := Alert('Deseja cancelar esse produto? ', {'Sim', 'Nao'})
                        if nEscolha == 1
                            loop
                        endif
                    endif

                    if AllTrim(cSenhaDigitada) == cSenhaSupervisor
                        Alert('Produto liberado!')
                    else
                        Alert('Senha incorreta!')
                        loop
                    endif

                endif

                nValorTotalOrdem += nValorTotalProd
                nLimiteCredito   -= nValorTotalProd

                @ nLinhaProd,66 say Transform(nValorTotalProd, '@E 999,999,999.99')
                nLinhaProd++

                if nLinhaProd > 15
                    @ 10,01 clear to 15,78
                    nLinhaProd := 10
                endif
            else
        
            endif


        enddo  // produtos / servicos

    enddo  // ordem de servico

enddo // programa principal