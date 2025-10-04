// PROVA REALIZADA POR FELIPE CORREA, N 17

setMode(25,80)
set scoreBoard off
set wrap on

cPalavaraConfigurada := ''

do while .t.  // menu principal

    clear

    @ 00,29 to 06,47
    @ 01,30 say ' MENU PRINCIPAL '
    @ 02,30 to 02,46
    @ 03,33 prompt 'Jogar     ' 
    @ 04,33 prompt 'Configurar'
    @ 05,33 prompt 'Sair      '
    menu to nOpcao

    if Empty(nOpcao)
        nOpcao := 3
        loop
    endif

    if nOpcao == 1
        clear

        if Empty(cPalavaraConfigurada)
            Alert('Termo ainda nao definido. Utilize a opcao Configurar!')
            loop
        endif

        nTamanhoPalavraConfigurada := Len(AllTrim(cPalavaraConfigurada))
        nTentativasUser            := 1
        nLinha                     := 3
        nColuna                    := 20

        do while nTentativasUser <= 5  // tentativas

            cPalavraUser := Space(nTamanhoPalavraConfigurada) 
            cPalavraAux  := cPalavaraConfigurada    // para auxiliar nas validacoes de letras da palavra digitada pelo usuario 

            @ 01,45 say 'Tentativas restantes: ' + (Str((5 - nTentativasUser + 1), 1))
            @ 01,20 say 'Termo: '
            
            @ 01,28 get cPalavraUser picture '@!' valid !Empty(cPalavraUser) .and. Len(cPalavraUser) == nTamanhoPalavraConfigurada
            read

            if LastKey() == 27
                nEscolha := Alert('Escolha uma opcao:', {'Continuar', 'Abandonar'})
                if nEscolha == 2
                    Alert('Voce abandonou o jogo.')
                    exit
                endif
                loop
            endif

            if ' ' $ cPalavraUser 
                Alert('A palavra nao pode conter espacos!')
                loop
            endif

            nContador := 1
            do while nContador <= nTamanhoPalavraConfigurada
                if SubStr(cPalavraUser, nContador, 1) == SubStr(cPalavaraConfigurada, nContador, 1)
                    if nContador == 1
                        cPalavraAux := ' ' + SubStr(cPalavraAux, nContador + 1)
                    elseif nContador == 5
                        cPalavraAux := SubStr(cPalavraAux, 1, nContador - 1) + ' '
                    else
                        cPalavraAux := SubStr(cPalavraAux, 1, nContador - 1) + ' ' + SubStr(cPalavraAux, nContador + 1)
                    endif
                endif
                nContador++
            enddo

            nPosicaoCaracter := 1
            do while nPosicaoCaracter <= nTamanhoPalavraConfigurada

                cCorLetra         := 'w/n'
                cLetraUser        := SubStr(cPalavraUser, nPosicaoCaracter, 1)  
                cLetraConfigurada := SubStr(cPalavaraConfigurada, nPosicaoCaracter++, 1)

                if cLetraUser $ cPalavraAux
                    cCorLetra := 'b/n'
                endif
                
                if cLetraUser == cLetraConfigurada
                    cCorLetra := 'g/n'
                endif

                @ nLinha,nColuna say cLetraUser + '  ' color cCorLetra

                nColuna += 4
                if nColuna >= (4 * nTamanhoPalavraConfigurada) + 20
                    nColuna := 20
                endif
                inKey(0.3)
            enddo  

            if cPalavraUser == cPalavaraConfigurada
                Alert('Parabens! Voce venceu o jogo com ' + AllTrim(Str(nTentativasUser)) + ' tentativa(s).')
                exit
            endif 

            nLinha++
            nTentativasUser++
        enddo  // tentativas

        if nTentativasUser > 5
            Alert('Game Over! A palavra era: ' + cPalavaraConfigurada + ".")
        endif

    elseif nOpcao == 2
        clear

        cPalavraDigitada := Space(15)

        @ 01,01 say 'Digite a palavra secreta: '
        @ 01,28 get cPalavraDigitada picture '@!' valid !Empty(cPalavraDigitada) color 'w/w'
        read

        if LastKey() == 27
            nEscolha := Alert('Deseja sair? ', {'Sim', 'Nao'})
            if nEscolha == 1
                loop
            endif   
        endif

        cPalavaraConfigurada := AllTrim(cPalavraDigitada)

        Alert('Palavra configurada com sucesso!')
        loop

    else
        nEscolha := Alert('Deseja realmente sair? ', {'Sim', 'Nao'})
        if nEscolha == 1
            exit
        endif
        loop
    endif


enddo  // menu principal