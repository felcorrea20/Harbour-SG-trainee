setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off
set message to 23 center
set wrap on

    cTodosUsuarios := ''

do while .t.   //programa do zero
    clear

    do while .t.  //tela inicial
        clear

        cUsuario := Space(20)
        cSenha   := Space(10)

        @ 01,01 say '===== TELA INICIAL ====='
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
        endif

        if nEscolhaMenu == 2  // cadastrar
            clear
            do while .t.

                cUsuario       := Space(20)
                cSenha         := Space(10)
                cConfirmaSenha := Space(10)

                @ 01,01 say '===== CADASTRO ====='
                @ 02,01 say 'Usuario.........: '
                @ 03,01 say 'Senha...........: '
                @ 04,01 say 'Confirme a senha: '

                @ 02,18 get cUsuario valid !Empty(cUsuario)
                @ 03,18 get cSenha   valid !Empty(cSenha)
                @ 04,18 get cConfirmaSenha   valid !Empty(cConfirmaSenha)
                read

                if LastKey() == 27 
                    nEscolha := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                    if nEscolha == 1
                        exit
                    endif
                    loop
                endif

                nPosicaoCaracter := 1
                lJaExisteUsuario := .f.
                do while nPosicaoCaracter <= Len(cTodosUsuarios)
                    cParteUsuario := SubStr(cTodosUsuarios, nPosicaoCaracter, 20)

                    if cUsuario == cParteUsuario 
                        lJaExisteUsuario := .t.
                        exit
                    endif 
                    nPosicaoCaracter += 30
                enddo
                if lJaExisteUsuario
                    Alert('Usuario ja cadastrado!')
                    exit
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

    // resto do codigo

enddo