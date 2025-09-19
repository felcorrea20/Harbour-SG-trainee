setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off

do while .t.
    clear

    nEmpregados := 0
    nIteracoes  := 0

    nPercentualAposentados := 0  // percentual de homens e mulheres aposentados
    nTotalRemuneracao      := 0  // valor total da remuneracao
    nQtdMulheres85         := 0  // qtd de mulheres com idade superior a 85 anos
    nQtdHomensAntes2006    := 0  // qtd de homens admitidos antes do ano de 2006 
    nQtdHomensAdicional    := 0  // qtd de homens que receberam algum tipo de adicional
    nQtdMulheresReducao    := 0  // qtd de mulheres que receberam algum tipo de reducao

    @ 00,00 to 02,79 
    @ 00,30 say " CONTROLE INSS "
    @ 01,01 say 'Digite o numero de empregados a serem analisados: '

    @ 01,53 get nEmpregados picture "99" valid nEmpregados > 0

    do while nIteracoes < nEmpregados
        cNome                 := Space(30)
        dNascimento           := CToD('')
        cSexo                 := Space(1)
        dAdmissao             := CToD('')
        dDemissao             := CToD('')
        nBaseSalario          := 0
        nAdicionalNoturno     := 0
        nAdicionalSalubridade := 0
        nTempoTrabalhado      := 0

        @ 03,00 to 12,79
        @ 03,30 say " DADOS DO COLABORADOR "
        @ 04,01 say "Nome..................: "
        @ 05,01 say "Data de nascimento....: "
        @ 06,01 say "Sexo..................:   [M]asculino [F]eminino"
        @ 07,01 say "Data de admissao......: "
        @ 08,01 say "Data de demissao......: "
        @ 09,01 say "Valor do salario base.: "
        @ 10,01 say "Add. noturno..........:    %"
        @ 11,01 say "Add. de insalubridade.:    %" 

        @ 04,31 get cNome                 picture "@!"            valid !Empty(cNome)
        @ 05,31 get dNascimento                                   valid (Date() - dNascimento) >= 18
        @ 06,31 get cSexo                 picture "@!"            valid cSexo $ "FM"
        @ 07,31 get dAdmissao                                     valid dAdmissao < Date()
        @ 08,31 get dDemissao                                     valid dDemissao >= dAdmissao
        @ 09,31 get nBaseSalario          picture "@E 999,999.99" valid nBaseSalario >= 0
        @ 10,31 get nAdicionalNoturno     picture "999"           valid nAdicionalNoturno >= 0
        @ 11,31 get nAdicionalSalubridade picture "999"           valid nAdicionalSalubridade >= 0
        read

        if LastKey() == 27
            exit
        endif

        nAdicionalNoturno     := nAdicionalNoturno / 100
        nAdicionalSalubridade := nAdicionalSalubridade / 100

        
    enddo
enddo