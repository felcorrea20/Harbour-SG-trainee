setMode(25,80)
set scoreBoard off
set date brit 
set epoch to 1940

nCodigo := 0
nUltimoCodigo := 0  

do while .t.
    clear

    nEscolha         := 0

    @ 00,00 to 05,18
    @ 00,02 say ' MENU - SENHAS '
    @ 01,01 say '1 - CADASTRAR'
    @ 02,01 say '2 - CONSULTAR'
    @ 03,01 say '3 - SAIR'
    @ 04,01 say 'ESCOLHA: '

    @ 04,10 get nEscolha picture '99' valid nEscolha > 0 .and. nEscolha < 4
    read

    if LastKey() == 27
        nOpcao := Alert('Deseja sair? ' , {'Sim', 'Nao'})

        if nOpcao == 1
            exit
        endif
        loop
    endif

    if nEscolha == 1
        do while .t.
            clear

            cSenha        := Space(20)
            nTamanhoSenha := 0
            nContador     := 1  
            cParteSenha   := ''
            dCadastro     := Date()
            cMensagemErro := ''

            lTemTamanhoMinimo    := .f.
            lTemCaracterNumerico := .f.
            lTemMaiusculo        := .f.
            lTemMinusculo        := .f.
            lTemEspecial         := .f.   

            @ 00,00 to 03,78
            @ 01,01 say "Codigo........: " + AllTrim(Transform(nCodigo, '999'))
            @ 01,50 say 'Data do cadastro: ' + DToC(dCadastro)
            @ 02,01 say "Digite a senha: "

            @ 01,68 get dCadastro 
            @ 02,17 get cSenha valid !Empty(cSenha)
            read

            if LastKey() == 27
                nOpcao := Alert('Escolha uma opcao', {'Sair', 'Continuar'})

                if nOpcao == 1
                    exit
                endif
                loop
            endif

            nTamanhoSenha :=  Len(AllTrim(cSenha))   

            if nTamanhoSenha < 8
                cMensagemErro += '- No minimo 8 caracteres' + Chr(10)
            endif

            do while nContador <= nTamanhoSenha
                cParteSenha := SubStr(cSenha, nContador++, 1)

                if cParteSenha $ '1234567890'
                    lTemCaracterNumerico := .t.
                endif

                if cParteSenha $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                    lTemMaiusculo := .t.
                endif

                if cParteSenha $ 'abcdefghijklmnopqrstuvwxyz'
                    lTemMinusculo := .t.
                endif

                if cParteSenha $ '!@#$%¨&*()_-+='
                    lTemEspecial := .t.
                endif
            enddo    

            if !lTemCaracterNumerico
                cMensagemErro += '- Um caractere NUMERICO ' + Chr(10)
            endif

            if !lTemMaiusculo
                cMensagemErro += '- Uma letra MAIUSCULA   ' + Chr(10)
            endif

            if !lTemMinusculo
                cMensagemErro += '- Uma letra MINUSCULA   ' + Chr(10)
            endif

            if !lTemEspecial
                cMensagemErro += '- Um caracter ESPECIAL  ' + Chr(10)
            endif

            inKey(0.5)

            if !Empty(cMensagemErro)
                Alert('A senha deve conter: ' + Chr(10) + cMensagemErro)
                loop
            else
                cSenhaCadastrada := cSenha
                Alert('Senha cadastrada com sucesso!')
                nUltimoCodigo := nCodigo
                nCodigo++ 
                exit
            endif
        enddo
    elseif nEscolha == 2
        clear

        @ 00,00 to 16,79 
        @ 01,01 say 'Codigo da senha.: ' + AllTrim(Transform(nUltimoCodigo, '999'))
        @ 02,01 say 'Senha cadastrada: ' + cSenhaCadastrada
        @ 03,01 say 'Data do cadastro: ' + DToC(dCadastro)

        //            2   6   10  14  18  22  26
        @ 05,01 say ' D   S   T   Q   Q   S   S'

        nLinha          := 6
        nColuna         := 0
        cCorDia         := 'w/n'
        nDiaCalendario  := 1
        nAno            := Year(dCadastro)
        nMes            := Month(dCadastro)

        cPrimeiroDia    := '01/' + AllTrim(Str(nMes)) + '/' + AllTrim(Str(nAno))
        dPrimeiroDia    := CToD(cPrimeiroDia)
        nDowPrimeiroDia := DoW(dPrimeiroDia) 

        nAnoDoProximoMes := nAno
        nProximoMes      := nMes + 1
        if nProximoMes > 12
            nProximoMes := 1
            nAnoDoProximoMes++
        endif

        cPrimeiroDiaProximoMes := '01/' + AllTrim(Str(nProximoMes)) + "/" + AllTrim(Str(nAnoDoProximoMes))
        dPrimeiroDiaProximoMes := CToD(cPrimeiroDiaProximoMes) 
        dUltimoDia             := dPrimeiroDiaProximoMes - 1
        nUltimoDia             := Day(dUltimoDia) 

        nColuna := (nDowPrimeiroDia * 3) + (nDowPrimeiroDia - 2)

        do while nDiaCalendario <= nUltimoDia
            if nDiaCalendario == Day(dCadastro)
                cCorDia := 'w/r'
            else
                cCordia := 'w/n'
            endif

            @ nLinha,nColuna say AllTrim(Str(nDiaCalendario++)) color cCorDia

            if nColuna == 26
                nColuna := 2
                nLinha++
            else
                nColuna += 4
            endif
        enddo

        inKey(0)
    else
        nOpcao := Alert('Deseja realmente sair? ', {'Sim', 'Nao'})

        if nOpcao == 1
            exit
        endif
        loop
    endif
enddo