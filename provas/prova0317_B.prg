//FELIPE CORREA - N° 17

set date brit
set epoch to 1940
setMode(25,80)
set scoreBoard off

do while .t.
    clear

    nEmpregados := 0
    nIteracoes  := 0
    nEscolha    := 0

    nHomensAposentados      := 0
    nMulheresAposentadas    := 0 
    nTotalAposentados       := 0
    nTotalRemuneracaoHom    := 0
    nTotalRemuneracaoFem    := 0
    nQtdHomens80            := 0
    nQtdMulheresAntes2003   := 0
    nQtdHomensDemitidos2015 := 0
    nHomensNaoAposentados   := 0
    nMulheresNaoAposentadas := 0 

    @ 00,00 to 02,79 
    @ 00,30 say " CONTROLE INSS "
    @ 01,01 say "Digite o numero de empregados a serem analisados: "

    @ 01,53 get nEmpregados picture "999" valid nEmpregados > 0
    read

    if LastKey() == 27
        nEscolha := Alert("Deseja sair?", {"Sim", "Nao"})
        if nEscolha == 1
            exit
        endif
        loop
    endif

    do while nIteracoes < nEmpregados

        //dados colaborador
        cNome               := Space(30)
        cSexo               := Space(1)
        dNascimento         := CToD('')
        nIdade              := 0
        dAdmissao           := CToD('')
        nAnoAdmissao        := 0
        dDemissao           := CToD('')
        nAnoDemissao        := 0
        nSalarioBase        := 0
        nAddNoturno         := 0
        nAddInsalubridade   := 0

        //variaveis para salario final
        nPorcentagemAumento := 0
        nSalarioFinal       := 0
        lAposentado         := .f.

        @ 03,00 to 12,79 
        @ 03,27 say " DADOS DO COLABORADOR "
        @ 04,01 say "Nome.................: "
        @ 05,01 say "Sexo.................:   [M]asculino [F]eminino"
        @ 06,01 say "Data de nascimento...: "
        @ 07,01 say "Data de admissao.....: "
        @ 08,01 say "Data de demissao.....: "
        @ 09,01 say "Valor do salario base:"
        @ 10,01 say "Add. noturno.........:       %"
        @ 11,01 say "Add. de insalubridade:       %"

        @ 04,24 get cNome             picture "@!"            valid !Empty(cNome)
        @ 05,24 get cSexo             picture "@!"            valid cSexo $ "MF"
        @ 06,24 get dNascimento                               valid Year(dNascimento) <= ( Year(Date()) - 18) .and. !Empty(dNascimento) // a partir dos 18 anos
        @ 07,24 get dAdmissao                                 valid Year(dAdmissao) >= Year(dNascimento) + 18 // a partir dos 18
        @ 08,24 get dDemissao                                 valid dDemissao > dAdmissao
        @ 09,24 get nSalarioBase      picture "@E 999,999.99" valid nSalarioBase > 0
        @ 10,24 get nAddNoturno       picture "@E 999.9"      valid nAddNoturno >= 0
        @ 11,24 get nAddInsalubridade picture "@E 999.9"      valid nAddInsalubridade >= 0
        read 

        if LastKey() == 27
            nEscolha := Alert("O que deseja fazer?", {"Cancelar", "Retornar", "Processar"})
            if nEscolha == 1 .or. nEscolha == 3
                exit
            endif
            loop
        endif

        //calculos para auxiliar o codigo
        nAddNoturno           := nAddNoturno / 100
        nAddInsalubridade     := nAddInsalubridade / 100
        nAnoAdmissao          := Year(dAdmissao)
        nAnoDemissao          := Year(dDemissao)

        nTempoTrabalhado      := Year(dDemissao) - Year(dAdmissao)
        if Month(dAdmissao) > Month(dDemissao)
            nTempoTrabalhado--
        elseif Month(dAdmissao) == Month(dDemissao) .and. Day(dAdmissao) > Day(dDemissao)
            nTempoTrabalhado--
        endif

        nIdade := Year(Date()) - Year(dNascimento)
        if Month(dNascimento) > Month(Date())
            nIdade--
        elseif Month(dNascimento) == Month(Date()) .and. Day(dNascimento) > Day(Date())
            nIdade--
        endif
          
//===========================================================================
        if nAnoAdmissao <= 2005 .and. nAnoDemissao >= 2009
            nPorcentagemAumento += 0.08
        endif

        if nAnoAdmissao <= 2012 .and. nAnoDemissao >= 2013
            nPorcentagemAumento -= 0.03
        endif

        nPorcentagemAumento  += nAddInsalubridade + nAddNoturno
        nSalarioFinal        := nSalarioBase + (nSalarioBase * nPorcentagemAumento)

        if cSexo == "M"
            if nIdade >= 65 .and. nTempoTrabalhado >= 30
                nTotalRemuneracaoHom += nSalarioFinal
                nHomensAposentados++
                lAposentado := .t.
            endif

            if nIdade > 80 
                nQtdHomens80++
            endif

            if nAnoDemissao == 2015
                nQtdHomensDemitidos2015++
            endif
        endif

        if cSexo == "F"
            if nIdade >= 60 .and. nTempoTrabalhado >= 25
                nTotalRemuneracaoFem += nSalarioFinal
                nMulheresAposentadas++
                lAposentado := .t.
            endif

            if nAnoAdmissao < 2003
                nQtdMulheresAntes2003++
            endif
        endif

        if lAposentado
            @ 11,40 say "Salario final: R$ " + AllTrim(Transform(nSalarioFinal, "@E 999,999.99"))
        endif       
        
        nIteracoes++
        inKey(1)
        @ 11,40 clear to 11,78 // limpa o texto 'Salario final: ...' 
    enddo 

    if nEscolha == 1
        loop
    endif

    nTotalAposentados                  := nHomensAposentados + nMulheresAposentadas
    nPorcentagemHomensAposentados      := (nHomensAposentados * 100 ) / nIteracoes
    nPorcentagemMulheresAposentadas    := (nMulheresAposentadas * 100) / nIteracoes
    nPorcentagemHomensNaoAposentados   := (nHomensNaoAposentados * 100) / nIteracoes
    nPorcentagemMulheresNaoAposentadas := (nMulheresNaoAposentadas * 100) / nIteracoes

    @ 13,00 to 21,79
    @ 13,30 say " ESTATISTICAS "
    @ 14,01 say "Homens aposentados....: " + Transform(nPorcentagemHomensAposentados, "@E 999.9") + " %"
    @ 14,33 say " | Total remuneracao - Homens..: R$ " + AllTrim(Transform(nTotalRemuneracaoHom, "@E 999,999.99")) 
    @ 15,01 say "Mulheres aposentadas..: " + Transform(nPorcentagemMulheresAposentadas, "@E 999.9") + " %"
    @ 15,33 say " | Total remuneracao - Mulheres: R$ " + AllTrim(Transform(nTotalRemuneracaoFem, "@E 999,999.99"))
   // @ 16,01 say "Homens nao aposentados: " +
    @ 16,01 to 16,78
    @ 17,01 say "Quantidade de homens com idade superior a 80 anos....: " + AllTrim(Str(nQtdHomens80))
    @ 18,01 say "Quantidade de mulheres admitidas antes do ano de 2003: " + AllTrim(Str(nQtdMulheresAntes2003))
    @ 19,01 say "Quantidade de homens demitidos no ano de 2015........: " + AllTrim(Str(nQtdHomensDemitidos2015))
    @ 20,01 say "Total de pessoas analisadas..........................: " + AllTrim(Str(nIteracoes))

    inKey(0)
    @ 22,01 say ""
    
    if LastKey() == 27
        nEscolha := Alert("Deseja sair?", {"Sim", "Nao"})
        if nEscolha == 1
            exit
        endif
        loop
    endif
enddo