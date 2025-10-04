// PROVA REALIZADA POR FELIPE CORREA, N 17

setMode(25,80)
set scoreBoard off
set message to 23 center
set wrap on

//mesa 1
cCorMesa1             := 'g/n' 
lMesaOcupada1         := .f.
nQtdAtendimentos1     := 0
nQtdCancelamentos1    := 0
nValorTotalMesa1      := 0
nValorUltraGeralMesa1 := 0
nValorCanceladosMesa1 := 0
nValorMedioMesa1      := 0

//mesa 2
cCorMesa2             := 'g/n' 
lMesaOcupada2         := .f.
nQtdAtendimentos2     := 0
nQtdCancelamentos2    := 0
nValorTotalMesa2      := 0
nValorUltraGeralMesa2 := 0
nValorCanceladosMesa2 := 0
nValorMedioMesa2      := 0

//atendentes
nAntendente1      := 1
nTotalAtendente1  := 0
nAntendente2      := 2
nTotalAtendente2  := 0
nTotalAtendentes  := 0

nTaxaServico   := 0.1
nTotalDuasMesa := 0

do while .t. // menu principal

    clear

    @ 00,30 say ' RESTAURANTE SG '
    @ 02,30 say 'Menu Principal'
    @ 03,32 prompt 'Mesas    ' message 'Modulo da mesa'
    @ 04,32 prompt 'Relatorio' message 'Apresentar relatorio'
    @ 05,32 prompt 'Sair     ' message 'Sair do programa'
    menu to nOpcao

    if Empty(nOpcao)
        nOpcao := 3
        loop
    endif

    if nOpcao == 1  // mesas


        do while .t.  // dados atendimento

            clear

            nNumeroMesa      := 0
            nCodigoAtendente := 0
            nSair            := 0   

            @ 01,01 say 'Mesas: '
            @ 01,09 say '| Mesa 01 |' color cCorMesa1
            @ 01,23 say '| Mesa 02 |' color cCorMesa2 
            @ 03,01 say 'Dados do Atendimento'
            @ 04,01 say 'Numero da mesa.....: '
            
            @ 04,22 get nNumeroMesa picture '9' valid nNumeroMesa == 1 .or. nNumeroMesa == 2
            read

            if LastKey() == 27
                nEscolha := Alert('Deseja voltar ao menu principal? ', {'Sim', 'Nao'})
                if nEscolha == 1
                    exit
                    nSair := 1
                endif
                loop
            endif

            if nNumeroMesa == 1 .and. lMesaOcupada1
                
                Alert('Mesa ocupada!')
                @ 07,01 say 'Escolha uma opcao: '
                @ 08,01 prompt 'Digitar outra mesa  '
                @ 09,01 prompt 'Faturar atendimento '
                @ 10,01 prompt 'Cancelar atendimento'
                menu to nOpcao

                if nOpcao == 1
                    loop  // volta para dados do atendimento
                elseif nOpcao == 2
                    exit  // vai para dados do pagamento
                else
                    loop  // volta para dados do atendimento
                    nQtdCancelamentos1++
                    nValorCanceladosMesa1 += nValorTotalMesa1
                    nValorTotalMesa1 := 0     
                    lMesaOcupada1    := .f.
                    cCorMesa1        := 'g/n'   
                endif
            
            elseif nNumeroMesa == 2 .and. lMesaOcupada2
            
                Alert('Mesa ocupada!')
                @ 07,01 say 'Escolha uma opcao: '
                @ 08,01 prompt 'Digitar outra mesa  '
                @ 09,01 prompt 'Faturar atendimento '
                @ 10,01 prompt 'Cancelar atendimento'
                menu to nOpcao

                if nOpcao == 1
                    loop  // volta para dados do atendimento
                elseif nOpcao == 2
                    exit  // vai para dados do pagamento
                else
                    loop  // volta para dados do atendimento
                    nQtdCancelamentos2++
                    nValorCanceladosMesa2 += nValorTotalMesa2
                    nValorTotalMesa2 := 0     
                    lMesaOcupada2    := .f.
                    cCorMesa2        := 'g/n'
                endif
    
            endif

            @ 05,01 say 'Numero do atendente: '
            
            @ 05,22 get nCodigoAtendente picture '9' valid nCodigoAtendente == 1 .or. nCodigoAtendente == 2
            read

            if nNumeroMesa == 1

                @ 07,00 to 23,79
                @ 07,30 say 'Dados do pedido'
                @ 08,01 say 'Descricao do produto                   |  Qtd  | Preco unitario | Valor Total '

                nLinha := 9
                do while .t.  // produtos

                    cDescricao     := Space(30)
                    nQuantidade    := 0
                    nPrecoUnitario := 0
                    nSubtotal      := 0

                    @ nLinha,01 get cDescricao     picture '@!'         valid !Empty(cDescricao)
                    @ nLinha,43 get nQuantidade    picture '99'         valid nQuantidade > 0
                    @ nLinha,53 get nPrecoUnitario picture '@E 9999.99' valid nPrecoUnitario > 0
                    read 

                    // lembrar de voltar para dados do atendimento
                    if LastKey() == 27 
                        nEscolha := Alert('Escolha: ', {'Enviar pedido para producao', 'Continuar digitando', 'Abandonar digitacao'})
                        if nEscolha == 1
                            if nSubtotal == 0 .and. nLinha == 9
                                Alert('Nenhum produto foi informado!')
                                loop
                            endif
                                                    
                            Alert('Pedido enviado para producao')
                            lMesaOcupada1 := .t.
                            cCorMesa1     := 'r/n' 
                            exit
                        elseif nEscolha == 2
                            loop
                        else
                            exit
                        endif
                    endif

                    nSubtotal        := nQuantidade * nPrecoUnitario 
                    nValorTotalMesa1 += nSubtotal

                    @ nLinha,68 say Transform(nSubtotal, '@E 999999.99')

                    nLinha++
                    if nLinha > 22
                        nLinha := 9
                    endif

                enddo  // produtos

            endif

            if nNumeroMesa == 2

                @ 07,00 to 23,79
                @ 07,30 say 'Dados do pedido'
                @ 08,01 say 'Descricao do produto                   |  Qtd  | Preco unitario | Valor Total '

                nLinha := 9
                do while .t.  // produtos

                    cDescricao     := Space(30)
                    nQuantidade    := 0
                    nPrecoUnitario := 0
                    nSubtotal      := 0

                    @ nLinha,01 get cDescricao     picture '@!'         valid !Empty(cDescricao)
                    @ nLinha,43 get nQuantidade    picture '99'         valid nQuantidade > 0
                    @ nLinha,53 get nPrecoUnitario picture '@E 9999.99' valid nPrecoUnitario > 0
                    read 

                    // lembrar de voltar para dados do atendimento
                    if LastKey() == 27 
                        nEscolha := Alert('Escolha: ', {'Enviar pedido para producao', 'Continuar digitando', 'Abandonar digitacao'})
                        if nEscolha == 1 
                            if nSubtotal == 0 .and. nLinha == 9
                                Alert('Nenhum produto foi informado!')
                                loop
                            endif

                            Alert('Pedido enviado para producao')
                            lMesaOcupada2 := .t.
                            cCorMesa2     := 'r/n' 
                            exit
                        elseif nEscolha == 2
                            loop
                        else
                            exit
                        endif
                    endif

                    nSubtotal        := nQuantidade * nPrecoUnitario 
                    nValorTotalMesa2 += nSubtotal

                    @ nLinha,68 say Transform(nSubtotal, '@E 999999.99')

                    nLinha++
                    if nLinha > 22
                        nLinha := 9
                    endif

                enddo  // produtos

            endif

        enddo  // dados atendimento
        if !Empty(nSair)  
            loop
        endif

        do while .t.  // dados do pagamento

            clear

            cTaxaServico      := Space(1)
            cFormaPagamento   := Space(1)
            nTotalAPagar      := 0
            nValorRecebido    := 0
            nValorAntendente1 := 0
            nValorAntendente2 := 0

            @ 00,00 to 07,79 
            @ 00,30 say ' DADOS DO PAGAMENTO '
            @ 01,01 say 'Deseja incluir a taxa de servico (10 %)?   [S]im [Nao]'
            @ 02,01 say 'Digite a forma de pagamento............:   [D]inheiro [C]artao che[Q]ue'

            @ 01,42 get cTaxaServico    picture '@!' valid cTaxaServico $ 'SN'
            @ 02,42 get cFormaPagamento picture '@!' valid cFormaPagamento $ 'DCQ'
            read

            if LastKey() == 27
                nEscolha := Alert('Escolha: ', {'Cancelar pagamento', 'Recomecar pagamento'})
                if nEscolha == 1
                    exit
                endif
                loop
            endif

            if nNumeroMesa == 1
                nTotalAPagar := nValorTotalMesa1
            else
                nTotalAPagar := nValorTotalMesa2
            endif

            if cTaxaServico == 'S'
                if nCodigoAtendente == 1
                    nValorAntendente1 := nTotalAPagar * nTaxaServico
                else
                    nValorAntendente2 := nTotalAPagar * nTaxaServico
                endif

                nTotalAPagar += nTotalAPagar * nTaxaServico
            endif


            @ 03,01 say 'Total a pagar..........................: R$ ' + AllTrim(TransForm(nTotalAPagar, '@E 9999999999.99'))
            @ 04,01 say 'Valor recebido.........................: R$ '

            @ 04,45 get nValorRecebido picture '@E 999999.99' valid nValorRecebido >= nTotalAPagar
            read

            if LastKey() == 27
                nEscolha := Alert('Escolha: ', {'Cancelar pagamento', 'Recomecar pagamento'})
                if nEscolha == 1
                    exit
                endif
                loop
            endif

            if nNumeroMesa == 1
                nValorUltraGeralMesa1 += nValorTotalMesa1
                nQtdAtendimentos1++
                lMesaOcupada1    := .f.
                cCorMesa1        := 'g/n' 
                nValorTotalMesa1 := 0
            else
                nValorUltraGeralMesa2 += nValorTotalMesa2
                nQtdAtendimentos2++
                lMesaOcupada2    := .f.
                cCorMesa2        := 'g/n' 
                nValorTotalMesa2 := 0
            endif

            if nCodigoAtendente == 1
                nTotalAtendente1 += nValorAntendente1
            else
                nTotalAtendente2 += nValorAntendente2
            endif

            
            if nValorRecebido > nTotalAPagar
                @ 05,01 say 'Troco..................................: R$ ' + TransForm(nValorRecebido - nTotalAPagar, '@E 999999.99')
            endif
            
            @ 20,01 say 'Digite qualque tecla para continuar...'
            inKey(0)
            exit
        enddo

    elseif nOpcao == 2  // relatorio
        
        clear

        nValorMedioMesa1 := nValorUltraGeralMesa1 / nQtdAtendimentos1
        nValorMedioMesa2 := nValorUltraGeralMesa2 / nQtdAtendimentos2
        nTotalDuasMesa   := nValorUltraGeralMesa1 + nValorUltraGeralMesa2
        nTotalAtendentes := nTotalAtendente1 + nTotalAtendente2

        @ 00,00 to 24,79
        @ 00,30 say ' RELATORIO '
        @ 01,01 say '=== MESA 01 ==='
        @ 02,01 say 'Quantidade de atendimentos.............: ' + AllTrim(Str(nQtdAtendimentos1))
        @ 03,01 say 'Quantidade de cancelamentos............: ' + AllTrim(Str(nQtdCancelamentos1))
        @ 04,01 say 'Valor total dos atendimentos...........: R$ ' + AllTrim(TransForm(nValorUltraGeralMesa1, '@E 999999999999.99'))
        @ 05,01 say 'Valor total dos atendimentos cancelados: R$ ' + AllTrim(TransForm(nValorCanceladosMesa1, '@E 999999999999.99'))
        @ 06,01 say 'Valor medio dos atendimentos por mesa..: R$ ' + AllTrim(TransForm(nValorMedioMesa1, '@E 999999999999.99'))
        @ 07,01 to 07,78 
        @ 08,01 say '=== MESA 02 ==='
        @ 09,01 say 'Quantidade de atendimentos.............: ' + AllTrim(Str(nQtdAtendimentos2))
        @ 10,01 say 'Quantidade de cancelamentos............: ' + AllTrim(Str(nQtdCancelamentos2))
        @ 11,01 say 'Valor total dos atendimentos...........: R$ ' + AllTrim(TransForm(nValorUltraGeralMesa2, '@E 999999999999.99'))
        @ 12,01 say 'Valor total dos atendimentos cancelados: R$ ' + AllTrim(TransForm(nValorCanceladosMesa2, '@E 999999999999.99'))
        @ 13,01 say 'Valor medio dos atendimentos por mesa..: R$ ' + AllTrim(TransForm(nValorMedioMesa2, '@E 999999999999.99'))
        @ 14,01 to 14,78
        @ 15,01 say 'Valor total das duas mesas.............: R$ ' + AllTrim(TransForm(nTotalDuasMesa, '@E 9999999999999.99'))
        @ 16,01 to 16,78
        @ 17,01 say '=== ATENDENTE 01 ==='
        @ 18,01 say 'Valor a receber........................: R$ ' + AllTrim(TransForm(nValorAntendente1, '@E 999999999999.99'))
        @ 19,01 to 19,78 
        @ 20,01 say '=== ATENDENTE 02 ==='
        @ 21,01 say 'Valor a receber........................: R$ ' + AllTrim(TransForm(nValorAntendente2, '@E 999999999999.99'))
        @ 22,01 to 22,78
        @ 23,01 say 'Total a receber dos atendentes.........: R$ ' + AllTrim(TransForm(nTotalAtendentes, '@E 999999999999.99'))

        inKey(0)
    else  // sair
        nEscolha := Alert('Deseja realmente sair? ', {'Sim', 'Nao'})
        if nEscolha == 1
            exit
        endif
        loop
    endif


enddo // menu principal