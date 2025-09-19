setMode(25,80)
set date british
set epoch to 1940
set scoreBoard off

do while .t.
    clear

    cNomeVendedor := Space(30)
    dCotacao      := Date()
    dAnoAtual     := Year(Date())

    cNome    := Space(30)
    nIdade   := 0
    cSexo    := Space(1)
    nPeso    := 0
    nAltura  := 0
    cFumante := Space(1)

    cPlano       := Space(1)
    cAbrangencia := Space(1)

    // saude total
    nValorBaseSaude   := 300
    nPorcentagemSaude := 0
    nMensalSaude      := 0
    nTrimestralSaude  := 0
    nAnualSaude       := 0
    cCorSaude         := "w/g"  

    //vida pura
    nValorBaseVida   := 320
    nPorcentagemVida := 0
    nMensalVida      := 0
    nTrimestralVida  := 0 
    nAnualVida       := 0
    cCorVida         := "w/g"

    @ 00,00 to 02,79
    @ 00,30 say " COTACAO DE PLANO DE SAUDE "
    @ 01,01 say "Vendedor: "
    @ 01,53 say "Data da cotacao: "
    @ 01,70 say dCotacao

    @ 01,11 get cNomeVendedor picture "@!" valid !Empty(cNomeVendedor)
    @ 01,70 get dCotacao                   
    read

    if LastKey() == 27
        exit
    endif

    @ 03,00 to 09,79
    @ 03,30 say " DADOS PESSOAIS "
    @ 04,01 say "Nome......: "
    @ 04,61 say "Idade: "
    @ 05,01 say "Sexo......:   [M]asculino [F]eminino"
    @ 06,01 say "Peso (kg).: "
    @ 07,01 say "Altura (m): "
    @ 08,01 say "Fumante?..:   [S]im [N]ao"

    @ 04,13 get cNome    picture "@!"        valid !Empty(cNome)
    @ 04,69 get nIdade   picture "999"       valid nIdade >= 0
    @ 05,13 get cSexo    picture "@!"        valid cSexo $ "MF"
    @ 06,13 get nPeso    picture "@E 999.99" valid nPeso > 0
    @ 07,13 get nAltura  picture "@E 9.99"   valid nAltura > 0 
    @ 08,13 get cFumante picture "@!"        valid cFumante $ "SN" 
    read

    if LastKey() == 27
        loop
    endif

    @ 10,00 to 13,79 
    @ 10,30 say " DADOS DO PLANO "
    @ 11,01 say "Tipo do plano..:   [E]nfermaria [A]partamento [V]ip"
    @ 12,01 say "Abrangencia....:   [R]egional [N]acional"

    @ 11,18 get cPlano       picture "@!" valid cPlano $ "EAV"
    @ 12,18 get cAbrangencia picture "@!" valid cAbrangencia $ "RN"
    read

    if LastKey() == 27
        loop
    endif

    nImc := nPeso / (nAltura * nAltura)

    //============================= saude total

    if nIdade < 30 
        nPorcentagemSaude -= 0.1
    elseif nIdade > 60
        nPorcentagemSaude += 0.2
    endif

    if cSexo == "M"
        nPorcentagemSaude += 0.05
    else
        nPorcentagemSaude -= 0.05
    endif

    if nImc > 30 
        nPorcentagemSaude += 0.3
    endif

    if cFumante == "S"
        nPorcentagemSaude += 0.3
    endif

    if cPlano == "A"
        nPorcentagemSaude += 0.3
    elseif cPlano == "V"
        nPorcentagemSaude += 0.5
    endif

    if cAbrangencia == "N"
        nPorcentagemSaude += 0.15
    endif

    if Month(dCotacao) == 5
        nPorcentagemSaude -= 0.1
    endif

    nMensalSaude     := nValorBaseSaude + (nValorBaseSaude * nPorcentagemSaude)
    nTrimestralSaude := nMensalSaude * 3
    nAnualSaude      := nMensalSaude * 12
    //========================= vida pura

    if nIdade < 25
        nPorcentagemVida -= 0.15
    elseif nIdade > 65 
        nPorcentagemVida += 0.25
    endif

    if cSexo == "M"
        nPorcentagemVida -= 0.05
    else
        nPorcentagemVida += 0.1
    endif

    if nImc > 25
        nPorcentagemVida += 0.1
    endif

    if cFumante == "S"
        nPorcentagemSaude += 0.25
    endif

    if cPlano == "A"
        nPorcentagemVida += 0.25
    elseif cPlano == "V"
        nPorcentagemVida += 0.45
    endif

    if cAbrangencia == "N"
        nPorcentagemVida += 0.1
    endif

    if Month(dCotacao) == 10
        nPorcentagemVida -= 0.15
    endif

    nMensalVida     := nValorBaseVida + (nValorBaseVida * nPorcentagemVida)
    nTrimestralVida := nMensalVida * 3
    nAnualVida      := nMensalVida * 12

    //===========================================

    if nMensalSaude > nMensalVida
        cCorSaude := "w/r"
    else
        cCorVida := "w/r"
    endif

    @ 14,00 to 20,39
    @ 15,01 say " SAUDE TOTAL " color cCorSaude
    @ 16,01 to 16,38
    @ 17,01 say "Mensal....: " + Transform(nMensalSaude, "@E 9,999.99")
    @ 18,01 say "Trimestral: " + Transform(nTrimestralSaude, "@E 9,999.99")
    @ 19,01 say "Anual.....: " + Transform(nAnualSaude, "@E 9,999.99")

    @ 14,40 to 20,79
    @ 15,41 say " VIDA PURA " color cCorVida
    @ 16,41 to 16,78
    @ 17,41 say "Mensal....: " + Transform(nMensalVida, "@E 9,999.99")
    @ 18,41 say "Trimestral: " + Transform(nTrimestralVida, "@E 9,999.99")
    @ 19,41 say "Anual.....: " + Transform(nAnualVida, "@E 9,999.99")

    //variaveis para mensagem final 
    nMes := Month(dCotacao) + 1
    nAno := Year(dCotacao)

    if nMes > 12
        nMes := 1
        nAno++
    endif

    cMesQueVem := "01/" + Str(nMes) + "/" + Str(nAno)
    dMesQueVem := CToD(cMesQueVem)

    dUltimoDia := dMesQueVem - 1

    @ 22,25 say "Cotacao valida ate " + AllTrim(DToC(dUltimoDia))

    inKey(0)
enddo