// prova realizada por FELIPE CORREA - n° 17

setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center
set wrap on

cProdutosEstoque    := ''

do while .t.
    clear

    cId := Space(8)

    //menu principal
    @ 01,01 say 'Menu Principal'
    @ 02,01 prompt 'Cadastrar' message 'Cadastrar produto'
    @ 03,01 prompt 'Consultar' message 'Consultar produto'
    @ 04,01 prompt 'Deletar  ' message 'Deletar produto'
    @ 05,01 prompt 'Entrada  ' message 'Entrada de produto'
    @ 06,01 prompt 'Saida    ' message 'Saida de produto'
    @ 07,01 prompt 'Finalizar' message 'Finalizar programa'
    menu to nEscolhaMenu

    if Empty(nEscolhaMenu)
        nEscolhaMenu := 6
        loop
    endif 

    //cadastrar
    if nEscolhaMenu == 1 

        do while .t.
            clear
        
            cId         := Space(8)
            cDescricao  := Space(30)
            nQuantidade := 0
            dCadastro   := Date()

            lProdutoJaExite    := .f. 
            lTemEspecial       := .f.
            lTemEspacoBranco   := .f.
            nQtdLetras         := 0
            nQtdNumeros        := 0
            nContador          := 1
            cCaracterId        := ''
            cMensagemErro      := ''

            @ 01,01 say 'CADASTRO DE PRODUTOS'
            @ 02,01 say 'ID...........: '

            @ 02,16 get cId picture '@!' valid !Empty(cId)
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= Len(cProdutosEstoque)
                if SubStr(cProdutosEstoque, nPosicaoCaracter, 8) == cId
                    Alert('Produto ja cadastrado!')
                    lProdutoJaExite := .t.
                    exit
                endif 
                nPosicaoCaracter += 50
            enddo
            if lProdutoJaExite
                loop
            endif

            do while nContador <= 8
                cCaracterId := SubStr(cId, nContador++, 1)

                if cCaracterId $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                    nQtdLetras++
                endif

                if cCaracterId $ '0123456789'
                    nQtdNumeros++
                endif

                if cCaracterId $ '!@#$%¨&*()_-+='
                    lTemEspecial := .t.
                endif

                if cCaracterId == ' '
                    lTemEspacoBranco := .t.
                endif
            enddo

            if Len(AllTrim(cId)) < 8
                cMensagemErro += '- Deve ter um tamanho fixo de 8 caracteres' + Chr(10)
            endif

            if nQtdLetras < 2
                cMensagemErro += '- Deve conter pelo menos 2 letras         ' + Chr(10)
            endif

            if nQtdNumeros < 4
                cMensagemErro += '- Deve conter pelo menos 4 numeros        ' + Chr(10)
            endif

            if lTemEspecial
                cMensagemErro += '- Nao pode conter caracteres especiais    ' + Chr(10)
            endif

            if lTemEspacoBranco 
                cMensagemErro += '- Nao pode conter espacos em branco       '
            endif

            if !Empty(cMensagemErro)
                Alert('O ID do produto: ' + Chr(10) + cMensagemErro)
                loop
            endif 

            @ 03,01 say 'Descricao....: '
            @ 04,01 say 'Quantidade...: '
            @ 05,01 say 'Data Cadastro: ' + DToC(dCadastro)

            @ 03,16 get cDescricao  picture '@!'   valid !Empty(cDescricao)
            @ 04,16 get nQuantidade picture '9999' valid nQuantidade > 0
            @ 05,16 get dCadastro                  valid dCadastro <= Date()
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            cProdutosEstoque += cId + cDescricao + Str(nQuantidade) + DToC(dCadastro)
            Alert(cProdutosEstoque)
            Alert('Produto cadastrado com sucesso!')
            exit

        enddo
    endif

    //consultar
    if nEscolhaMenu == 2
        do while .t.
            clear

            if Empty(cProdutosEstoque)
                Alert('Nenhum produto cadastrado...')
            endif

            cDescricaoConsulta    := ''
            cQuantidadeConsulta   := ''
            cDataCadastroConsulta := ''

            @ 01,01 say 'CONSULTA DE PRODUTOS'
            @ 02,01 say 'Digite o ID para consulta: '

            @ 02,28 get cId picture '@!' valid !Empty(cId)
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            // buscar o indice do produto
            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= Len(cProdutosEstoque)
                if SubStr(cProdutosEstoque, nPosicaoCaracter, 8) == cId
                    exit
                endif 
                nPosicaoCaracter += 50
            enddo

            if nPosicaoCaracter > Len(cProdutosEstoque)
                Alert('Produto nao cadastrado!')
                loop
            endif

            cDescricaoConsulta    := SubStr(cProdutosEstoque, nPosicaoCaracter + 8, 30)
            cQuantidadeConsulta   := SubStr(cProdutosEstoque, nPosicaoCaracter + 38, 4)
            cDataCadastroConsulta := SubStr(cProdutosEstoque, nPosicaoCaracter + 42, 8)

            @ 03,01 say 'Descricao do produto.: ' + cDescricaoConsulta
            @ 04,01 say 'Quantidade no estoque: ' + cQuantidadeConsulta
            @ 05,01 say 'Data de cadastro.....: ' + cDataCadastroConsulta

            @ 07,01 say 'Digite qualquer tecla para sair...'
            inKey(0)
            exit
        enddo
    endif

    //deletar
    if nEscolhaMenu == 3
        clear
        if Empty(cProdutosEstoque)
            Alert('Nenhum produto cadastrado...')
        endif

        do while .t.
            @ 01,01 say 'EXCLUSAO DE PRODUTOS'
            @ 02,01 say 'Digite o ID do produto: '

            @ 02,25 get cId picture '@!' valid !Empty(cId)
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            nEscolha := Alert('Tem certeza que deseja excluir? ' , {'Sim', 'Nao'})
            if nEscolha == 2
                loop
            endif

            // buscar o indice do produto
            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= Len(cProdutosEstoque)
                if SubStr(cProdutosEstoque, nPosicaoCaracter, 8) == cId
                    exit
                endif 
                nPosicaoCaracter += 50
            enddo

            if nPosicaoCaracter > Len(cProdutosEstoque)
                Alert('Produto nao cadastrado!')
                exit
            endif

            cProdutosEstoque := SubStr(cProdutosEstoque, 1, nPosicaoCaracter - 1) + SubStr(cProdutosEstoque, nPosicaoCaracter + 50)
            
            Alert('Produto deletado com sucesso!')
            exit
        enddo
    endif

    //entrada do produto
    if nEscolhaMenu == 4
        clear

        if Empty(cProdutosEstoque)
            Alert('Nenhum produto cadastrado...')
        endif

        do while .t.
            nQtdEntrada := 0
            dEntrada    := CToD('')

            @ 01,01 say 'ENTRADA DE PRODUTO'
            @ 02,01 say 'Digite o ID do produto: '

            @ 02,25 get cId picture '@!' valid !Empty(cId)
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif
            
            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= Len(cProdutosEstoque)
                if SubStr(cProdutosEstoque, nPosicaoCaracter, 8) == cId
                    exit
                endif 
                nPosicaoCaracter += 50
            enddo

            if nPosicaoCaracter > Len(cProdutosEstoque)
                Alert('Produto nao cadastrado!')
                exit
            endif

            nQtdAtual      := Val(SubStr(cProdutosEstoque, nPosicaoCaracter + 38, 4))
            dCadastroAtual := CToD(SubStr(cProdutosEstoque, nPosicaoCaracter + 42, 8))  

            @ 03,01 say 'Quantidade atual.......: ' + AllTrim(Str(nQtdAtual))
            @ 05,01 say 'Quantidade de entrada..: '
            @ 06,01 say 'Data de entrada........: '
            
            @ 05,25 get nQtdEntrada picture '9999' valid (nQtdEntrada + nQtdAtual) <= 9999 .and. nQtdEntrada > 0
            @ 06,25 get dEntrada                   valid dEntrada >= dCadastroAtual
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            cQtdFinal        := Str(nQtdEntrada + nQtdAtual)
            cProdutosEstoque := SubStr(cProdutosEstoque, 1, nPosicaoCaracter + 37) + cQtdFinal + SubStr(cProdutosEstoque, nPosicaoCaracter + 42)
            
            Alert('Entrada realizada com sucesso!' + Chr(10) + 'Estoque atualizado para: '+ AllTrim(cQtdFinal))
            exit
        enddo
    endif

    // saida de produto
    if nEscolhaMenu == 5
        do while .t.
            clear
            
            if Empty(cProdutosEstoque)
                Alert('Nenhum produto cadastrado...')
            endif

            nQtdSaida := 0
            dSaida    := CToD('')

            @ 01,01 say 'SAIDA DE PRODUTO'
            @ 02,01 say 'Digite o ID do produto: '

            @ 02,25 get cId picture '@!' valid !Empty(cId)
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif
            
            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= Len(cProdutosEstoque)
                if SubStr(cProdutosEstoque, nPosicaoCaracter, 8) == cId
                    exit
                endif 
                nPosicaoCaracter += 50
            enddo

            if nPosicaoCaracter > Len(cProdutosEstoque)
                Alert('Produto nao cadastrado!')
                exit
            endif

            nQtdAtual      := Val(SubStr(cProdutosEstoque, nPosicaoCaracter + 38, 4))
            dCadastroAtual := CToD(SubStr(cProdutosEstoque, nPosicaoCaracter + 42, 8))  

            @ 03,01 say 'Quantidade atual.......: ' + AllTrim(Str(nQtdAtual))

            @ 05,01 say 'Quantidade de saida....: '
            @ 06,01 say 'Data de saida..........: '
            
            @ 05,25 get nQtdSaida picture '9999' valid (nQtdAtual - nQtdSaida) >= 0 .and. nQtdSaida > 0
            @ 06,25 get dSaida                   valid dSaida > dCadastroAtual
            read

            if LastKey() == 27 
                nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nEscolha == 1
                    exit
                endif
                loop
            endif

            cQtdFinal        := Str(nQtdAtual - nQtdSaida)
            cProdutosEstoque := SubStr(cProdutosEstoque, 1, nPosicaoCaracter + 37) + cQtdFinal + SubStr(cProdutosEstoque, nPosicaoCaracter + 42)
            
            Alert('Saida realizada com sucesso!' + Chr(10) + 'Estoque atualizado para: ' + AllTrim(cQtdFinal))
            exit
        enddo
    endif

    if nEscolhaMenu == 6
        nEscolha := Alert('Deseja realmente sair?', {'Sim', 'Nao'})

        if nEscolha == 1
            exit
        endif
        loop
    endif
enddo