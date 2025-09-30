setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center
set wrap on

cUltimosJogadores := ''
nEscolha          := 0  

do while .t.  // principal
    clear

    cNome         := Space(30)
    nDificuldade  := 0
    cPalavraChave := Space(20)
    cPrimeiraDica := Space(20)
    cSegundaDica  := Space(20)
    cTerceiraDica := Space(20)

    @ 00,00 to 13,79 
    @ 00,30 say ' JOGO DA FORCA '
    @ 01,02 say 'Nome do jogador: '

    @ 01,20 get cNome picture '@!' valid !Empty(cNome)
    read

    if LastKey() == 27
        nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

        if nEscolha == 1
            exit
        endif
        loop
    endif

    @ 02,01 to 07,21
    @ 03,02 say 'Dificuldade do jogo'
    @ 04,02 prompt 'Facil  '
    @ 05,02 prompt 'Medio  '
    @ 06,02 prompt 'Dificil'
    menu to nDificuldade

    @ 08,02 say 'Digite a Palavra - Chave: '

    @ 08,29 get cPalavraChave picture '@!' valid !Empty(cPalavraChave)
    read

    if LastKey() == 27
        nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

        if nEscolha == 1
            exit
        endif
        loop
    endif

    if nDificuldade == 1

        @ 10,02 say 'Primeira dica: '
        @ 11,02 say 'Segunda dica.: '
        @ 12,02 say 'Terceira dica: '

        @ 10,17 get cPrimeiraDica picture '@!' valid !Empty(cPrimeiraDica)
        @ 11,17 get cSegundaDica  picture '@!' valid !Empty(cSegundaDica)
        @ 12,17 get cTerceiraDica picture '@!' valid !Empty(cTerceiraDica)
        read

        if LastKey() == 27
            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

            if nEscolha == 1
                exit
            endif
            loop
        endif
    endif

    clear
    @ 00,00 to 11,78  

    cLetrasCorretas := ''
    cLetrasErradas  := ''
    cCorLetra       := ''
    nTentativas     := 0
    do while .t.  // para digitar as letras 
        @ 00,30 say ' JOGO DA FORCA ' 

        nTamanhoPalavra    := Len(AllTrim(cPalavraChave))
        nTamanhoErradas    := Len(AllTrim(cLetrasErradas))
        cLetra             := Space(1)
        lPalavraIncompleta := .f.

        nLinhaBoneco    := 8
        nColunaCabeca   := 10
        nColunaCorpo    := 10    
        nColunaBraco1   := 9
        nColunaBraco2   := 11
        nColunaPerna1   := 9
        nColunaPerna2   := 11
        nColunaPe1      := 8
        nColunaPe2      := 12 

        @ 02,03 say 'Letras erradas: ' + cLetrasErradas
        @ 04,03 say '-------'
        @ 05,03 say '|      |'
        @ 06,03 say '|'
        @ 07,03 say '|'
        @ 08,03 say '|'
        @ 09,03 say '|'
        @ 10,03 say '|'
        @ 10,12 say AllTrim(cPalavraChave) color 'w/w'

        @ 12,03 say 'Digite uma letra: ' color cCorLetra

        @ 12,22 get cLetra picture '@!' valid !Empty(cLetra) 
        read

        if LastKey() == 27 
            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})

            if nEscolha == 1
                exit
            endif
            loop
        endif

        nPosicaoCaracter := 1
        do while nPosicaoCaracter <= nTamanhoPalavra
            if !(SubStr(cPalavraChave, nPosicaoCaracter, 1) == cLetrasCorretas)
                lPalavraIncompleta := .t.
                exit
            endif
            nPosicaoCaracter++
        enddo
        if !lPalavraIncompleta
            Alert('Parabens, voce acertou a palavra com ' + AllTrim(Transform(nTentativas, '9')) + ' tentativas')
            exit
        endif   

        if cLetra $ cLetrasCorretas .or. cLetra $ cLetrasErradas
            Alert('Letra ja digitada')
            cCorLetra := 'w/r'
            loop
        else
            cCorLetra := 'w/n'
        endif

        if cLetra $ cPalavraChave
            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= nTamanhoPalavra
                if SubStr(cPalavraChave, nPosicaoCaracter, 1) == cLetra
                    @ 10,(11 + nPosicaoCaracter) say cLetra
                endif
                nPosicaoCaracter++
            enddo
            cLetrasCorretas += cLetra
        else 
            cLetrasErradas += cLetra
        endif

        if nDificuldade == 1 
            if nTamanhoErradas == 1
                @ nLinhaBoneco,nColunaCabeca say 'O'
                nLinhaBoneco++
            endif

            if nTamanhoErradas == 2
                @ nLinhaBoneco,nColunaCorpo say '|'
                nLinhaBoneco++
            endif

            if nTamanhoErradas == 3 .or. nTamanhoErradas == 4
                @ nLinhaBoneco,nColunaBraco1 say '/'
                @ nLinhaBoneco,nColunaBraco2 say '\'
                nLinhaBoneco++
            endif

            if nTamanhoErradas == 5
                @ nLinhaBoneco,nColunaPe1 say '_'
                @ nLinhaBoneco,nColunaPe2 say '_'
            endif

            if nTamanhoErradas == 6
                Alert('Game Over!' + Chr(10) + 'A palavra era: ' + cPalavraChave)
            endif
        endif
        nTentativas++
    enddo
    if nEscolha == 1
        loop
    endif
    
enddo