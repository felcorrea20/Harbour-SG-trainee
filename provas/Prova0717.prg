// PROVA REALIZADA POR FELIPE CORREA - N° 17

setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center

cUsuarioJose     := 'JOSE'
cSenhaJose       := '432mudar123'
cSenhaSupervisor := 'AUTORIZA99'
nOrdemServico    := 1
nSubtotalProduto := 0
nSubtotalServico := 0

do while .t.  // principal

    clear

    cUsuario := Space(15)
    cSenha   := Space(15)

    @ 01,01 say 'TELA DE LOGIN'
    @ 02,01 say 'Usuario: '
    @ 03,01 say 'Senha..: '

    @ 02,10 get cUsuario picture '@!' valid !Empty(cUsuario)
    @ 03,10 get cSenha                valid !Empty(cSenha) 
    read

    if LastKey() == 27
        nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
        if nEscolha == 1
            exit
        endif
        loop
    endif

    if AllTrim(cUsuario) == cUsuarioJose .and. AllTrim(cSenha) == cSenhaJose
        Alert('Login efetuado com sucesso!')
    else
        Alert('Usuario ou senha incorretos!')
        loop
    endif

    do while .t.  // efetuar pedidos

        clear

        @ 01,01 say 'MENU PRINCIPAL'
        @ 02,01 prompt 'PEDIDOS' message 'Efetuar pedidos'
        @ 03,01 prompt 'SAIR   ' message 'Sair do programa'
        menu to nEscolhaMenu

        if nEscolhaMenu == 0
            nEscolhaMenu := 2
            loop
        endif

        do while nEscolhaMenu == 1  // ordem de servico

            clear 

            lCancelar             := .f.
            cNomeCliente          := Space(40)
            dOrdemServico         := Date()
            cNomeTecnico          := Space(30)
            cDescricaoEquipamento := Space(40)
            dDataCompra           := CToD('')
            nLimiteInicial        := 0  
            nLimiteCredito        := 0
            nTotalProduto         := 0
            nTotalServico         := 0    
            nTotalOrdemServico    := 0  
            nTotalComissao        := 0  

            // entrega
            cEntregaDomicilio     := Space(1)
            cEnderecoEntrega      := Space(40) 
            cBairroEntrega        := Space(40)
            cReferenciaEntrega    := Space(40)
            nTelefone             := 0  
            nTaxaEntrega          := 0.2 

            @ 00,00 to 24,79 
            @ 00,30 say ' DADOS DA ORDEM DE SERVICO '
            @ 01,01 say 'Ordem de servico...........: ' + Transform(nOrdemServico, '99999999')
            @ 02,01 say 'Nome do cliente............: '
            @ 03,01 say 'Data Ordem de Servico......: ' + DToC(dOrdemServico)
            @ 04,01 say 'Nome do tecnico............: '
            @ 05,01 say 'Descricao do equipamento...: '
            @ 06,01 say 'Data da compra.............: '
            @ 07,01 say 'Limite de credito - cliente: '
            @ 08,01 say 'Entrega a domicilio........?   [S]im [N]ao'

            @ 02,30 get cNomeCliente          picture '@!'                 valid !Empty(cNomeCliente)
            @ 03,30 get dOrdemServico              
            @ 04,30 get cNomeTecnico          picture '@!'                 valid !Empty(cNomeTecnico)
            @ 05,30 get cDescricaoEquipamento picture '@!'                 valid !Empty(cDescricaoEquipamento)
            @ 06,30 get dDataCompra                                        valid dDataCompra <= dOrdemServico .and. !Empty(dDataCompra)    
            @ 07,30 get nLimiteCredito        picture '@E 9999999999.99'   valid !Empty(nLimiteCredito)   
            @ 08,30 get cEntregaDomicilio     picture '@!'                 valid cEntregaDomicilio $ 'SN'
            read

            if LastKey() == 27
                nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                if nEscolha == 1
                    exit
                endif
                loop
            endif

            // calculo tempo do equipamento
            nTempoEquipamento := Year(dDataCompra) - Year(dOrdemServico)
            if Month(dDataCompra) > Month(dOrdemServico)
                nTempoEquipamento--
            elseif Month(dDataCompra) == Month(dOrdemServico) .and. Day(dDataCompra) > Day(dOrdemServico)
                nTempoEquipamento--
            endif

            nLimiteInicial := nLimiteCredito

            if cEntregaDomicilio == 'S'
                @ 09,01 say 'Endereco...............: '
                @ 10,01 say 'Bairro.................: '
                @ 11,01 say 'Referencia.............: '
                @ 12,01 say 'Telefone...............: (  ) 9      -     '

                @ 09,30 get cEnderecoEntrega   picture '@!'            valid !Empty(cEnderecoEntrega)
                @ 10,30 get cBairroEntrega     picture '@!'            valid !Empty(cBairroEntrega)
                @ 11,30 get cReferenciaEntrega picture '@!'            valid !Empty(cReferenciaEntrega)
                @ 12,30 get nTelefone          picture '99999999999'   valid !Empty(nTelefone)
                read

                if LastKey() == 27
                    nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif
            endif

            cProdutoOuServico := Space(1)
            do while .t.  // produtos / servicos

                @ 16,01 clear to 21,78

                nLinha   := 17
                cUsuario := Space(15)
                cSenha   := Space(11)

                @ 13,01 to 13,78
                @ 13,30 say ' PRODUTOS / SERVICOS '
                @ 14,01 say 'Escolha:   [P]roduto [S]ervico'
                @ 15,01 to 15,78

                @ 14,10 get cProdutoOuServico picture '@!' valid cProdutoOuServico $ 'PS'
                read

                if LastKey() == 27
                    nEscolha := Alert('Escolha uma opcao: ', {'Cancelar', 'Retornar', 'Processar'})
                    if nEscolha == 1
                        exit
                        lCancelar := .t.
                    elseif nEscolha == 2
                        loop
                    endif
                    exit
                endif

                if cProdutoOuServico == 'P'

                    nSubtotalProduto  := 0  // 999999999,99  

                    @ 16,01 say 'Descricao                      | QTD  | Preco Unit.  | Desc (%) | Valor Total'

                    do while .t.  // produto

                        cDescricaoProduto := Space(30)
                        nQtdProduto       := 0  // 9999
                        nPrecoUnitario    := 0  // 999999999,99
                        nDescontoProduto  := 0  // 999,99

                        @ nLinha,01 get cDescricaoProduto     picture '@!'              valid !Empty(cDescricaoProduto)
                        @ nLinha,32 get nQtdProduto           picture '9999'            valid !Empty(nQtdProduto)
                        @ nLinha,39 get nPrecoUnitario        picture '@E 999999999.99' valid !Empty(nPrecoUnitario) 
                        @ nLinha,56 get nDescontoProduto      picture '@E 999.99'       valid nDescontoProduto >= 0 .and. nDescontoProduto <= 100
                        read
                        
                        if LastKey() == 27 
                            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                            if nEscolha == 1
                                exit
                            endif
                            loop
                        endif

                        nSubtotalProduto := nQtdProduto * nPrecoUnitario
                        nSubtotalProduto -= nSubtotalProduto * (nDescontoProduto / 100)

                        if nLimiteCredito < nSubtotalProduto
                            Alert('Limite de credito atingido!' + Chr(10) + 'Para continuar digite o usuario e senha')

                            @ 23,01 say 'Usuario: '
                            @ 23,30 say 'Senha: '

                            @ 23,10 get cUsuario picture '@!' valid !Empty(cUsuario)
                            @ 23,38 get cSenha                valid !Empty(cSenha)
                            read

                            if LastKey() == 27 
                                nEscolha := Alert('Cancelar ultimo produto? ', {'Sim', 'Nao'})
                                if nEscolha == 1
                                    exit
                                endif
                            endif

                            if AllTrim(cSenha) == cSenhaSupervisor
                                Alert('Produto liberado!')
                            else
                                Alert('Senha incorreta! O ultimo produto sera desconsiderado')
                                loop 
                            endif
                            
                            @ 23,01 clear to 23,78  // supervisor e senha
                        endif
                    
                        nLimiteCredito     -= nSubtotalProduto
                        nTotalProduto      += nSubtotalProduto  
                        nTotalOrdemServico += nSubtotalProduto

                        @ nLinha,66 say Transform(nSubtotalProduto, '@E 999999999.99')
                        @ 23,01 say 'Subtotal da Ordem de Servico: R$ ' + Transform(nTotalOrdemServico, '@E 9999999999.99')

                        nLinha++
                        if nLinha > 21
                            nLinha := 17
                            @ 17,01 clear to 21,78
                        endif 

                    enddo  // produto
                endif

                if cProdutoOuServico == 'S'

                    @ 16,01 say 'Descricao                     |  Desc (%) | Comissao Tec. (%) | Preco Total '

                    do while .t.  // servico

                        cDescricaoServico := Space(25)
                        nDescontServico   := 0  // 999,99
                        nComissaoTecnico  := 0  // 999,99

                        @ nLinha,01 get cDescricaoServico picture '@!'               valid !Empty(cDescricaoServico)
                        @ nLinha,34 get nDescontServico   picture '@E 999.99'        valid nDescontServico >= 0 .and. nDescontServico <= 100
                        @ nLinha,50 get nComissaoTecnico  picture '@E 999.99'        valid nComissaoTecnico >= 0 .and. nComissaoTecnico <= 100
                        @ nLinha,64 get nSubtotalServico  picture '@E 9999999999.99' valid !Empty(nSubtotalServico)
                        read

                        if LastKey() == 27 
                            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                            if nEscolha == 1
                                exit
                            endif
                            loop
                        endif

                        nSubtotalServico -= nSubtotalServico * (nDescontServico / 100)
                        nTotalComissao   += nSubtotalServico * (nComissaoTecnico / 100)

                        if nLimiteCredito < nSubtotalServico
                            Alert('Limite de credito atingido!' + Chr(10) + 'Para continuar digite o usuario e senha')

                            @ 23,01 say 'Usuario: '
                            @ 23,30 say 'Senha: '

                            @ 23,10 get cUsuario picture '@!' valid !Empty(cUsuario)
                            @ 23,38 get cSenha                valid !Empty(cSenha)
                            read

                            if LastKey() == 27 
                                nEscolha := Alert('Cancelar ultimo servico? ', {'Sim', 'Nao'})
                                if nEscolha == 1
                                    exit
                                endif
                            endif

                            if AllTrim(cSenha) == cSenhaSupervisor
                                Alert('Servico liberado!')
                            else
                                Alert('Senha incorreta! O ultimo servco sera desconsiderado')
                                loop 
                            endif
                            
                            @ 23,01 clear to 23,78  // supervisor e senha
                        endif

                        nLimiteCredito     -= nSubtotalServico
                        nTotalServico      += nSubtotalServico 
                        nTotalOrdemServico += nSubtotalServico

                        @ nLinha,64 say Transform(nSubtotalServico, '@E 9999999999.99')
                        @ 23,01 say 'Subtotal da Ordem de Servico: R$ ' + Transform(nTotalOrdemServico, '@E 9999999999.99')

                        nLinha++
                        if nLinha > 21
                            nLinha := 17
                            @ 17,01 clear to 21,78
                        endif
                    
                    enddo // servico
                endif  // servico

            enddo  // produtos / servicos
            if lCancelar
                exit
            endif

            do while .t.  // processar
                clear

                nValorAPagar       := 0 
                nValorAntes        := nTotalOrdemServico 
                cMensagemGarantia  := ''
                cFormasPagamento   := ''
                cPagamento1        := Space(1)
                cPagamento2        := Space(1)
                cPagamento3        := Space(1)     
                nValorPago1        := 0      
                nValorPago2        := 0     
                nValorPago3        := 0

                if cEntregaDomicilio == 'S'
                    nTotalOrdemServico += nTotalOrdemServico * nTaxaEntrega
                endif

                @ 00,00 to 24,79 
                @ 00,30 say ' FECHAMENTO - ORDEM DE SERVICO '
                @ 01,01 say 'Ordem de Servico...............: ' + Str(nOrdemServico)
                @ 01,55 say 'Data: ' + DToC(dOrdemServico)
                @ 02,01 say 'Nome do cliente................: ' + cNomeCliente
                @ 03,01 say 'Limite disponivel..............: R$ ' + Transform((nLimiteInicial - nLimiteCredito), '@E 999999999.99')
                @ 04,01 say 'Valor total da Ordem de Servico: R$ ' + Transform(nTotalOrdemServico, '@E 999999999999.99')
                @ 05,01 say 'Valor a pagar..................: R$ ' + Transform()

                if nTempoEquipamento <= 1
                    nTotalOrdemServico -= nSubtotalServico
                    cMensagemGarantia  += Chr(10) + 'O(s) servico(s)'
                    Alert(Str(nSubtotalServico))
                elseif nTempoEquipamento <= 2
                    nTotalOrdemServico -= nSubtotalProduto
                    cMensagemGarantia += Chr(10) + 'O(s) produto(s)'
                endif

                if !Empty(cMensagemGarantia)
                    Alert('A garantia ira cobrir: ' + cMensagemGarantia)
                    Alert('Valor antes: ' + Transform(nValorAntes, '@E 999999999999.99') + Chr(10) + 'Valor agora: ' + Transform(nTotalOrdemServico, '@E 999999999999.99'))

                    @ 04,01 say 'Valor total da Ordem de Servico: R$ ' + Transform(nTotalOrdemServico, '@E 999999999999.99')
                endif

                if Empty(nTotalOrdemServico)
                
                    nCnpjEmpresa := 0 // 99999999999999
                    nNumeroNota  := 0 // 9999999999
                    dNota        := CToD('')

                    @ 05,01 to 05,78
                    @ 05,30 say ' NOTA FISCAL '
                    @ 06,01 say 'CNPJ da empresa: '
                    @ 07,01 say 'Numero da Nota.: '
                    @ 08,01 say 'Data da Nota...: '

                    @ 06,19 get nCnpjEmpresa picture '9999999999999' valid !Empty(nCnpjEmpresa)       
                    @ 07,19 get nNumeroNota  picture '9999999999'    valid !Empty(nNumeroNota)
                    @ 08,19 get dNota                                valid dNota <= Date() .and. !Empty(dNota)
                    read

                    if LastKey() == 27
                        nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                        if nEscolha == 1
                            exit
                        endif
                        loop
                    endif   
                    exit
                else
                    @ 05,01 to 05,78
                    @ 05,30 say ' FORMA DE PAGAMENTO '

                    do while .t.  // formas de pagamento

                        nTotalAPagar := nTotalOrdemServico

                        @ 06,01 say 'Forma de pagamento 01:   [D]inheiro [C]artao c[H]eque'
                        @ 07,01 say 'Valor pago...........: '

                        @ 06,24 get cPagamento1 picture '@!'         valid cPagamento1 $ 'DCH'
                        @ 07,24 get nValorPago1 picture '@E  999,999.99' valid nValorPago1 > 0
                        read

                        if LastKey() == 27
                            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                            if nEscolha == 1
                                exit
                            endif
                            loop
                        endif 

                        if cPagamento1 == 'D' .and. nValorPago1 > nTotalAPagar
                            @ 08,01 say 'Troco: ' + Str(nValorPago1 - nTotalAPagar)
                            exit
                        endif

                        cFormasPagamento += cPagamento1
                        nTotalAPagar     -= nValorPago1

                        if nTotalAPagar > 0
                            @ 09,01 say 'Forma de pagamento 02:  [D]inheiro [C]artao c[H]eque'
                            @ 10,01 say 'Valor pago...........: '

                            @ 09,24 get cPagamento2 picture '@!' valid cPagamento2 $ 'DCH' .and. !(cPagamento2 $ cFormasPagamento) 
                            @ 10,24 get nValorPago2 picture '@E 999,999.99' valid nValorPago2 > 0
                            read

                            if LastKey() == 27
                                nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                                if nEscolha == 1
                                    exit
                                endif
                                loop
                            endif 

                            if cPagamento2 == 'D' .and. nValorPago2 > nTotalAPagar
                                @ 11,01 say 'Troco: ' + Str(nValorPago2 - nTotalAPagar)
                                exit
                            endif

                            cFormasPagamento += cPagamento2
                            nTotalAPagar     -= nValorPago2

                            if nTotalAPagar > 0
                                @ 12,01 say 'Forma de pagamento 03: [D]inheiro [C]artao c[H]eque'
                                @ 13,01 say 'Valor pago...........: ' + Transform(nTotalAPagar, '@E 999999999999.99')

                                @ 12,24 get cPagamento3 picture '@!' valid cPagamento3 $ 'DCH' .and. !(cPagamento3 $ cFormasPagamento)
                                read

                                if LastKey() == 27
                                    nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
                                    if nEscolha == 1
                                        exit
                                    endif
                                endif 

                                if cPagamento3 == 'D' .and. nValorPago3 > nTotalAPagar
                                    @ 13,01 say 'Troco: ' + Str(nValorPago3 - nTotalAPagar)
                                    exit
                                endif  
                                
                                cFormasPagamento += cPagamento3
                                nTotalAPagar     := 0
                            endif  
                            exit
                        endif
                    enddo  // formas de pagamento
                endif

                @ 14,01 to 14,78 
                @ 15,20 say 'Ordem de Servico finalizada'
                @ 16,01 say 'Valor total da comissao do tecnico: R$ ' + Transform(nTotalComissao, '@E 999999999.99')
                @ 20,01 say 'Digita qualquer tecla para continuar...'
                inkey(0)
                exit

            enddo  // processar

            if !Empty(cFormasPagamento) .and. !Empty(cMensagemGarantia)
                nOrdemServico++
                exit
            endif

        enddo  // ordem de servico

        if nEscolhaMenu == 2
            exit
        endif
     
    enddo  // efetuar pedidos

enddo  // principal