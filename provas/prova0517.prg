// prova realizada por FELIPE CORREA - n° 17

setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center
set wrap on

cTodosUsuarios := ''
nPedido        := 1
 
//      codigo = 4 | descricao = 11 | preco = 5 | descont = 2 | estoque = 6      total = 28
cProdutos := '5500AMORA PRETA07,5014210,00' + '7744UVA RUBI   18,0017198,50' + '4445PEPINO     23,9912345,00' + '6565MORANGO    05,4904210,00'


do while .t. // programa principal

    nEscolha := 0

    do while .t.  //tela inicial
        clear

        lUsuarioLogado := .f.

        @ 01,01 say '===== FRUTARIA FELIPE`S ====='
        @ 02,01 prompt 'Login    ' message 'Realizar login'
        @ 03,01 prompt 'Cadastrar' message 'Cadastrar usuario'
        @ 04,01 prompt 'Sair     ' message 'Sair do programa'
        menu to nEscolhaMenu

        if nEscolhaMenu == 0
            nEscolhaMenu := 3
            loop
        endif

        if nEscolhaMenu == 1  // login
            do while .t.
                clear
                cUsuario := Space(20)
                cSenha   := Space(10)

                if Empty(cTodosUsuarios)
                    Alert('Nenhum usuario cadastrado!')
                    exit
                endif

                @ 01,01 say '===== LOGIN ====='
                @ 02,01 say 'Usuario.: '
                @ 03,01 say 'Senha...: '

                @ 02,11 get cUsuario valid !Empty(cUsuario)
                @ 03,11 get cSenha   valid !Empty(cSenha)
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif

                nPosicaoCaracter := 1
                do while nPosicaoCaracter <= Len(cTodosUsuarios)
                    cParteUsuario := SubStr(cTodosUsuarios, nPosicaoCaracter, 20)
                    cParteSenha   := SubStr(cTodosUsuarios, nPosicaoCaracter + 20, 10)

                    if cUsuario == cParteUsuario .and. cSenha == cParteSenha
                        Alert('Login efetuado com sucesso!')
                        lUsuarioLogado := .t.
                        exit
                    endif 
                    nPosicaoCaracter += 30
                enddo

                if nPosicaoCaracter > Len(cTodosUsuarios)
                    Alert('Usuario nao encontrado e/ou senha incorreta!')
                    loop
                endif    

                exit
            enddo
            if lUsuarioLogado
                exit
            endif
        endif

        if nEscolhaMenu == 2  // cadastrar
            clear
            do while .t.

                cUsuario       := Space(20)
                cSenha         := Space(10)
                cConfirmaSenha := Space(10)

                @ 01,01 say '===== CADASTRO ====='
                @ 02,01 say 'Usuario.........: '

                @ 02,18 get cUsuario valid !Empty(cUsuario)
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif

                nPosicaoCaracter := 1
                do while nPosicaoCaracter <= Len(cTodosUsuarios)
                    cParteUsuario := SubStr(cTodosUsuarios, nPosicaoCaracter, 20)

                    if cUsuario == cParteUsuario 
                        exit
                    endif 
                    nPosicaoCaracter += 30
                enddo
                if nPosicaoCaracter < Len(cTodosUsuarios)
                    Alert('Esse usuario ja existe!')
                    loop
                endif

                @ 03,01 say 'Senha...........: '
                @ 04,01 say 'Confirme a senha: '

                @ 03,18 get cSenha           valid !Empty(cSenha)
                @ 04,18 get cConfirmaSenha   valid !Empty(cConfirmaSenha)
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif

                if !(cSenha == cConfirmaSenha)
                    Alert('As senhas precisam ser iguais!')
                    loop
                endif

                cTodosUsuarios += cUsuario + cSenha
                Alert('Usuario cadastrado com sucesso!')
                exit
            enddo
        endif

        if nEscolhaMenu == 3  // sair
            nEscolha := Alert('Deseja realmente sair? ', {'Sim', 'Nao'})

            if nEscolha == 1
                exit
            endif
            loop
        endif
    enddo
    if nEscolha == 1
        exit  
    endif
    //==================================================================================
    do while .t.  // pedido

        clear
        if nEscolha == 1
            nEscolha := 0
            cProdutos := '5500AMORA PRETA07,5014210,00' + '7744UVA RUBI   18,0017198,50' + '4445PEPINO     23,9912345,00' + '6565MORANGO    05,4904210,00'
        endif
        
        @ 01,01 say '===== MENU PRINCIPAL ====='
        @ 02,01 prompt 'Pedidos' message 'Efetuar pedidos'
        @ 03,01 prompt 'Sair   ' message 'Sair do programa'
        menu to nEscolhaMenu

        if nEscolhaMenu == 0
            nEscolhaMenu := 2
            loop
        endif

        if nEscolhaMenu == 1  // efetuar pedidos
            nTotalVenda := 0

            do while .t.  // dados do cliente
                clear

                cNome          := Space(30)
                nLimiteCredito := 0
                dPedido        := Date() 
                cUserAdmin     := 'ADMIN'
                cSenhaAdmin    := 'ADMIN123'
                cUserDigitado  := Space(10)
                cSenhaDigitada := Space(10)  

                @ 00,00 to 05,79
                @ 00,20 say ' DADOS DA VENDA  - FRUTARIA FELIPE`S '
                @ 01,01 say 'Numero do pedido.: ' + Str(nPedido)
                @ 02,01 say 'Nome do cliente..: '
                @ 03,01 say 'Limite de credito: R$'
                @ 04,01 say 'Data do pedido...: '

                @ 02,23 get cNome          picture '@!'            valid !Empty(cNome)
                @ 03,23 get nLimiteCredito picture '@E 999,999.99' valid nLimiteCredito > 0
                @ 04,23 get dPedido                                valid dPedido <= Date()   
                read

                if LastKey() == 27 
                    nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif
                exit
            enddo
            if nEscolha == 1
                loop
            endif

            @ 06,00 to 24,79
            @ 06,30 say ' PRODUTOS '
            @ 07,01 say ' CODIGO | DESCRICAO          |  QTD  |  DESC % | COMISSAO  | VALOR TOTAL       '
            @ 22,01 to 22,78 
            @ 23,01 say 'TOTAL DA VENDA: R$ '

            nLinha := 8
            do while .t. // parte dos produtos

                //produtos
                nCodigo       := 0
                cDescricao    := ''
                nPreco        := 0
                nMaxDesconto  := 0
                nEstoqueAtual := 0

                nQuantidade        := 0
                nDescontaAplicado  := 0
                nComissaoAplicada  := 0
                nTotalComissao     := 0
                nValorTotalProduto := 0

                @ nLinha,02 get nCodigo picture '9999' valid nCodigo > 0
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao ', {'Cancelar', 'Retornar', 'Processar'})

                    if nEscolha == 2
                        loop
                    endif
                    exit
                endif

                // achar id do produto    
                nPosicaoCaracter := 1
                do while nPosicaoCaracter <= Len(cProdutos)
                    if SubStr(cProdutos, nPosicaoCaracter, 4) == AllTrim(Str(nCodigo))
                        exit
                    endif
                    nPosicaoCaracter += 28
                enddo

                if nPosicaoCaracter > Len(cProdutos)
                    Alert('Produto nao cadastrado!')
                    loop
                endif

                cDescricao      := SubStr(cProdutos, nPosicaoCaracter + 4, 11)
                nPrecoInteiro   := Val(SubStr(cProdutos, nPosicaoCaracter + 15, 2))
                nPrecoDecimal   := Val(SubStr(cProdutos, nPosicaoCaracter + 18, 2))
                nMaxDesconto    := Val(SubStr(cProdutos, nPosicaoCaracter + 20, 2)) // me retorna um numero sem estar em porcentagem para auxiliar nas validacoes
                nEstoqueInteiro := Val(SubStr(cProdutos, nPosicaoCaracter + 22, 3)) 
                nEstoqueDecimal := Val(SubStr(cProdutos, nPosicaoCaracter + 26, 2)) 

                nPreco        := nPrecoInteiro + (nPrecoDecimal / 100)  
                nEstoqueAtual := nEstoqueInteiro + (nEstoqueDecimal / 100)

                @ nLinha,11 say cDescricao
                
                @ nLinha,32 get nQuantidade       picture '@E 999.99' valid nQuantidade > 0
                @ nLinha,41 get nDescontaAplicado picture '@E 999.9'  valid nDescontaAplicado >= 0      
                @ nLinha,53 get nComissaoAplicada picture '@E 999.9'  valid nComissaoAplicada >= 0
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao ', {'Cancelar', 'Retornar', 'Processar'})

                    if nEscolha == 2
                        loop
                    endif
                    exit
                endif

                if nQuantidade > nEstoqueAtual
                    Alert('Quantidade maior que o estoque atual!')
                    loop
                endif

                if nDescontaAplicado > nMaxDesconto
                    Alert("Desconto aplicado nao pode ser maior que " + Str(nMaxDesconto) + ' %')
                    loop
                endif

                nValorTotalProduto := (nQuantidade * nPreco) 
                nValorTotalProduto -= (nValorTotalProduto * (nDescontaAplicado / 100))  

                do while nValorTotalProduto > nLimiteCredito
                    Alert('Limite de credito ultrapassado')
                    @ 23,01 clear to 23,78
                    @ 23,01 say 'Usuario: '
                    @ 23,40 say 'Senha: '

                    @ 23,11 get cUserDigitado  picture '@!' valid !Empty(cUserDigitado)
                    @ 23,48 get cSenhaDigitada picture '@!' valid !Empty(cSenhaDigitada)
                    read

                    if LastKey() == 27
                        nEscolha := Alert('Deseja sair? (O ultimo produto sera desconsiderado!)', {'Sim', 'Nao'})

                        if nEscolha == 1
                            exit
                        endif
                        loop
                    endif

                    if AllTrim(cUserDigitado) == cUserAdmin .and. AllTrim(cSenhaDigitada) == cSenhaAdmin
                        exit
                    endif
                enddo
                if nEscolha == 1
                    loop
                endif

                nTotalVenda    += nValorTotalProduto
                nLimiteCredito -= nValorTotalProduto
                nTotalComissao += (nValorTotalProduto * (nComissaoAplicada / 100))

                @ 03,24     say Transform(nLimiteCredito, '@E 999,999.99')
                @ nLinha,61 say 'R$ ' + Transform(nValorTotalProduto, '@E 9,999.99') 
                @ 23,20     say AllTrim(Transform(nTotalVenda, '@E 9,999,999.99'))

                nLinha++
                if nLinha > 21
                    nLinha := 8
                    @ 08,01 clear to 21,78
                endif

                nEstoqueAtual  -= nQuantidade
                cProdutos      := SubStr(cProdutos, 1, nPosicaoCaracter + 21) + Str(nEstoqueAtual, 6, 2) + SubStr(cProdutos, nPosicaoCaracter + 28)

            enddo

            if nEscolha == 1
                loop
            endif

            do while nEscolha == 3
                cFormasPagamento    := ''
                nTotalAPagar        := nTotalVenda
                cPagamento1         := Space(1)
                nValorPago1         := 0
                cPagamento2         := Space(1)
                nValorPago2         := 0
                cPagamento3         := Space(1)
                nValorPago3         := 0

                @ 00,01 clear to 24,79
                @ 00,00 to 10,79 
                @ 01,20 say ' DADOS DO PEDIDO - FRUTARIA FELIPE`S'
                @ 03,01 say 'Nome do cliente...: ' + cNome
                @ 03,50 say 'Data do pedido: ' + DToC(dPedido)
                @ 04,01 say 'Numero do pedido..: ' + Str(nPedido)
                @ 04,01 say 'Limite disponivel : R$ ' + AllTrim(Transform(nLimiteCredito, '@E 9,999,999.99'))
                @ 05,01 say 'Total do pedido...: R$ ' + AllTrim(Transform(nTotalVenda, '@E 9,999,999.99'))
                @ 06,01 to 06,78

                @ 06,30 say ' FORMA DE PAGAMENTO '
                @ 07,01 say 'Forma de pagamento 01:   [D]inheiro [C]artao c[H]eque'
                @ 08,01 say 'Valor pago...........: '

                @ 07,24 get cPagamento1 picture '@!' valid cPagamento1 $ 'DCH'
                @ 08,24 get nValorPago1 picture '999,999.99' valid nValorPago1 > 0
                read

                if LastKey() == 27
                    nEscolha := Alert('Deseja realmente sair? (Pedido será cancelado!)', {'Sim', 'Nao'})
                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif 

                if cPagamento1 == 'D' .and. nValorPago1 > nTotalAPagar
                    @ 09,01 say 'Troco: ' + Str(nValorPago1 - nTotalAPagar)
                    exit
                endif

                cFormasPagamento += cPagamento1
                nTotalAPagar     -= nValorPago1

                if nTotalAPagar > 0
                    @ 09,01 say 'Forma de pagamento 02:  [D]inheiro [C]artao c[H]eque'
                    @ 10,01 say 'Valor pago...........: '

                    @ 09,24 get cPagamento2 picture '@!' valid cPagamento2 $ 'DCH' .and. cPagamento2 != cPagamento1
                    @ 10,24 get nValorPago2 picture '999,999.99' valid nValorPago2 > 0
                    read

                    if LastKey() == 27
                        nEscolha := Alert('Deseja realmente sair? (Pedido será cancelado!)', {'Sim', 'Nao'})
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
                        @ 11,01 say 'Forma de pagamento 03: [D]inheiro [C]artao c[H]eque'
                        @ 12,01 say 'Valor pago...........: ' + Str(nTotalAPagar)

                        @ 11,24 get cPagamento3 picture '@!' valid cPagamento3 $ 'DCH' .and. cPagamento3 != cPagamento2 .and. cPagamento3 != cPagamento1
                        read

                        if LastKey() == 27
                            nEscolha := Alert('Deseja realmente sair? (Pedido será cancelado!)', {'Sim', 'Nao'})
                            if nEscolha == 1
                                exit
                            endif
                            loop
                        endif 

                        if cPagamento3 == 'D' .and. nValorPago3 > nTotalAPagar
                            @ 13,01 say 'Troco: ' + Str(nValorPago3 - nTotalAPagar)
                            exit
                        endif  
                        
                        cFormasPagamento += cPagamento3
                        nTotalAPagar     := 0
                    endif  
                endif

                if 'H' $ cFormasPagamento 
                    nBanco        := 0
                    nAgencia      := 0
                    nCodConta     := 0
                    nNumeroCheque := 0

                    @ 15,01 to 15,78
                    @ 15,01 say 'DADOS DO CHEQUE'
                    @ 16,01 say 'Numero do banco..: '
                    @ 17,01 say 'Numero da agencia: '
                    @ 18,01 say 'Codigo da conta..: '
                    @ 19,01 say 'Numero do cheque.: '

                    @ 16,23 get nBanco        picture '999'        valid nBanco > 0
                    @ 17,23 get nAgencia      picture '9999'       valid nAgencia > 0
                    @ 18,23 get nCodConta     picture '9999999999' valid nCodConta > 0
                    @ 19,23 get nNumeroCheque picture '999999'     valid nNumeroCheque > 0
                    read
                    
                    if LastKey() == 27 
                        nEscolha := Alert('Deseja cancelar o pedido? ', {'Sim', 'Nao'})
                        if nEscolha == 1
                            exit
                        endif
                        loop                        
                    endif


                endif
            enddo
            /*if nEscolha == 1
                loop
            endif*/

            nPedido++
        endif

        if nEscolhaMenu == 2
            nEscolha := Alert('Deseja realmente sair? ', {'Sim', 'Nao'})

            if nEscolha == 1
                exit
            endif
        endif
    enddo
   /*if nEscolha == 1
        loop
    endif*/
enddo