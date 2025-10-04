// prova realizada por FELIPE CORREA - n° 17

setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off

cTodosIds           := ''
cProdutosEstoque    := ''
nQtdProdutosEstoque := 0

do while .t.
    clear

    nEscolhaMenu := 0
    nPosicaoId   := 0 
    nPosicaoTmp  := 0  
    cId := Space(8)

    //menu principal
    @ 01,01 say 'Sistema de Controle de Estoque'
    @ 02,01 say 'Menu Principal'
    @ 03,01 say '1 - Cadastrar Produto'
    @ 04,01 say '2 - Consultar Produto'
    @ 05,01 say '3 - Deletar Produto'
    @ 06,01 say '4 - Entrada de Produto'
    @ 07,01 say '5 - Saida de Produto'
    @ 08,01 say '6 - Sair do Programa'
    @ 09,01 say 'Escolha: '

    @ 09,10 get nEscolhaMenu picture '9' valid nEscolhaMenu > 0 .and. nEscolhaMenu < 7
    read 

    if LastKey() == 27
        nEscolha := Alert('Deseja Sair? ', {'Sim', 'Nao'})

        if nEscolha == 1
            exit
        endif
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

            lTemEspecial       := .f.
            lTemEspacoBranco   := .f.
            nQtdLetras         := 0
            nQtdNumeros        := 0
            nContador          := 0
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

            if cId $ cTodosIds
                Alert('Produto ja cadastrado!')
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

            if nQtdLetras < 2
                cMensagemErro += '- Deve conter pelo menos 2 letras     ' + Chr(10)
            endif

            if nQtdNumeros < 4
                cMensagemErro += '- Deve conter pelo menos 4 numeros    ' + Chr(10)
            endif

            if lTemEspecial
                cMensagemErro += '- Nao pode conter caracteres especiais' + Chr(10)
            endif

            if lTemEspacoBranco 
                cMensagemErro += '- Nao pode conter espacos em branco   '
            endif

            if !Empty(cMensagemErro)
                Alert('O ID do produto: ' + Chr(10) + cMensagemErro)
                loop
            endif 
            cTodosIds += '|' + cId

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
            nQtdProdutosEstoque++
            Alert('Produto cadastrado com sucesso!')
            exit

        enddo
    endif

    //consultar
    if nEscolhaMenu == 2
        do while .t.
            clear

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

            if !(cId $ cTodosIds)
                Alert('Produto nao cadastrado!')
                loop
            endif

            //encontrar posicao do id de consulta
            cTmp        := ''
            do while .t.
                cTmp := SubStr(cTodosIds, nPosicaoTmp, 1)

                if cTmp == '|'
                    cIdTmp := SubStr(cTodosIds, nPosicaoTmp + 1, 8)
                endif

                if cIdTmp == cId
                    nPosicaoIdConsulta := nPosicaoTmp + 1   
                    exit
                endif
                nPosicaoTmp++
            enddo

            cDescricaoConsulta    := SubStr(cProdutosEstoque, nPosicaoIdConsulta + 8, 30)
            cQuantidadeConsulta   := SubStr(cProdutosEstoque, nPosicaoIdConsulta + 38, 4)
            cDataCadastroConsulta := SubStr(cProdutosEstoque, nPosicaoIdConsulta + 42, 8)

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

            if !(cId $ cTodosIds)
                Alert('Produto nao cadastrado!')
                loop
            endif

            do while .t.
                cTmp := SubStr(cTodosIds, nPosicaoTmp, 1)

                if cTmp == '|'
                    cIdTmp := SubStr(cTodosIds, nPosicaoTmp + 1, 8)
                endif

                if cIdTmp == cId
                    nPosicaoId := nPosicaoTmp - 8
                    exit
                endif
                nPosicaoTmp++
            enddo

            cProdutosTmp     := SubStr(cProdutosEstoque, nPosicaoAtual, (nPosicaoIdDeletar - 1))
            cProdutosTmp     += SubStr(cProdutosEstoque, (nPosicaoIdDeletar + 50), Len(cProdutosEstoque))
            cProdutosEstoque := cProdutosTmp
            Alert('Produto deletado com sucesso!')
            exit
        enddo
    endif

    //entrada do produto
    if nEscolhaMenu == 4
        clear

        do while .t.
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

            if !(cId $ cTodosIds)
                Alert('Produto nao cadastrado!')
                loop
            endif
            
            do while .t.
                cTmp := SubStr(cTodosIds, nPosicaoTmp, 1)

                if cTmp == '|'
                    cIdTmp := SubStr(cTodosIds, nPosicaoTmp + 1, 8)
                endif

                if cIdTmp == cId
                    nPosicaoId := nPosicaoTmp - 8
                    exit
                endif
                nPosicaoTmp++
            enddo

            @ 03,01 say 'Quantidade de entrada'

            cQuantidadeEntrada := SubStr(cProdutosEstoque, nPosicaoId + 38, 4)
            nQuantidadeAtual   := Val(cQuantidadeEntrada)

        enddo
    endif
enddo