setMode(25,80)
set date brit
set epoch to 1940
set scoreBoard off

clear

cNomeVendedor := Space(30)
dCotacao      := Date()
nAnoAtual     := Year(Date())

//dados pessoais
cNomeCliente    := Space(30)
nIdadeCliente   := 0
cSexoCliente    := Space(1)
nAnoPrimeiraCnh := 0
nAnosHabilitado := 0

//dados do veiculo
cMarcaVeiculo  := Space(20)
nAnoFabricacao := 0
cTipoVeiculo   := Space(1)
nMotorVeiculo  := 0
nValorFipe     := 0
cUsoVeiculo    := Space(1)

//seguradora 01
nBaseSeguro1        := 0
nPorcentagemSeguro1 := 0
nAnualSeguro1       := 0
nTrimestralSeguro1  := 0 
nMensalSeguro1      := 0
cCorSeguro1         := "w/g"
 
//seguradora 02
nBaseSeguro2        := 0
nPorcentagemSeguro2 := 0
nAnualSeguro2       := 0
nTrimestralSeguro2  := 0 
nMensalSeguro2      := 0
cCorSeguro2         := "w/g"

@ 00,00 to 02,79
@ 00,30 say " COTACAO DE SEGURO "
@ 01,01 say "Vendedor: "
@ 01,53 say "Data da cotacao: "
@ 01,70 say dCotacao

@ 01,11 get cNomeVendedor picture "@!" valid !Empty(cNomeVendedor)
@ 01,70 get dCotacao                   valid dCotacao <= Date()
read

@ 03,00 to 08,79
@ 03,30 say " DADOS PESSOAIS "
@ 05,01 say "Nome...............: "
@ 05,61 say "Idade: "
@ 06,01 say "Sexo...............:   [M]asculino [F]eminino"
@ 07,01 say "Ano da primeira CNH: "

@ 05,22 get cNomeCliente    picture "@!"   valid !Empty(cNomeCliente)
@ 05,68 get nIdadeCliente   picture "999"  valid nIdadeCliente >=  18
@ 06,22 get cSexoCliente    picture "@!"   valid cSexoCliente == "M" .or. cSexoCliente == "F"
@ 07,22 get nAnoPrimeiraCnh picture "9999" valid nAnoPrimeiraCnh <= nAnoAtual
read

@ 09,00 to 16,79
@ 09,30 say " DADOS DO VEICULO "
@ 10,01 say "Marca..............: "
@ 11,01 say "Ano de fabricacao: "
@ 12,01 say "Tipo...............:   [P]asseio [E]sportivo [L]uxo"
@ 13,01 say "Motor..............: "
@ 14,01 say "Valor (fipe).......: "
@ 15,01 say "Uso................:   [P]articular [O]profissional"

@ 10,22 get cMarcaVeiculo  picture "@!"            valid !Empty(cMarcaVeiculo)
@ 11,22 get nAnoFabricacao picture "9999"          valid nAnoFabricacao <= nAnoAtual
@ 12,22 get cTipoVeiculo   picture "@!"            valid cTipoVeiculo == "P" .or. (cTipoVeiculo == "E" .or. cTipoVeiculo == "L")
@ 13,22 get nMotorVeiculo  picture "9.9"           valid nMotorVeiculo > 0
@ 14,22 get nValorFipe     picture "@E 999,999.99" valid nValorFipe > 0
@ 15,22 get cUsoVeiculo    picture "@!"            valid cUsoVeiculo == "P" .or. cUsoVeiculo == "O"
read

nAnosHabilitado      := nAnoAtual - nAnoPrimeiraCnh
nAnosDesdeFabricacao := nAnoAtual - nAnoFabricacao

//seguro 01
nBaseSeguro1 := nValorFipe * 0.06

if nIdadeCliente < 25 .or. nIdadeCliente > 65
    nPorcentagemSeguro1 += 0.1
endif

if cSexoCliente == "M"
    nPorcentagemSeguro1 += 0.1
else
    nPorcentagemSeguro1 -= 0.05
endif

if nAnosHabilitado <= 3
    nPorcentagemSeguro1 += 0.15
elseif nAnosHabilitado > 8
    nPorcentagemSeguro1 -= 0.1
endif

if cTipoVeiculo == "E"
    nPorcentagemSeguro1 += 0.1
elseif cTipoVeiculo == "L"
    nPorcentagemSeguro1 += 0.2
endif

if nMotorVeiculo > 2
    nPorcentagemSeguro1 += 0.15
endif

if nAnosDesdeFabricacao >= 20
    nPorcentagemSeguro1 += 0.1
else
    nPorcentagemSeguro1 += (nAnosDesdeFabricacao * 0.005)
endif

if cTipoVeiculo == "O"
    nPorcentagemSeguro1 += 0.1
endif

if Month(dCotacao) == 3
    nPorcentagemSeguro1 -= 0.1
endif

nAnualSeguro1      := nBaseSeguro1 + (nBaseSeguro1 * nPorcentagemSeguro1)
nTrimestralSeguro1 := nAnualSeguro1 / 3
nMensalSeguro1     := nAnualSeguro1 / 12

// seguro 02 ==============================================

nBaseSeguro2 := nValorFipe * 0.07

if nIdadeCliente < 23 .or. nIdadeCliente > 60
    nPorcentagemSeguro2 += 0.15
elseif nIdadeCliente >= 30 .and. nIdadeCliente <= 50
    nPorcentagemSeguro2 -= 0.08
endif

if cSexoCliente == "M"
    nPorcentagemSeguro2 -= 0.06
else
    nPorcentagemSeguro2 += 0.12
endif

if nAnosHabilitado <= 2
    nPorcentagemSeguro2 += 0.2
elseif nAnosHabilitado > 5
    nPorcentagemSeguro2 -= 0.08
endif

if cTipoVeiculo == "E"
    nPorcentagemSeguro2 += 0.15
elseif  cTipoVeiculo == "L"
    nPorcentagemSeguro2 += 0.18
endif

if nMotorVeiculo >= 1.5
    nPorcentagemSeguro2 += 0.1
endif

if nAnosDesdeFabricacao >= 10
    nPorcentagemSeguro2 += 0.08
else
    nPorcentagemSeguro2 += (0.008 * nAnosDesdeFabricacao)
endif

if cUsoVeiculo == "O"
    nPorcentagemSeguro2 += 0.12
endif

if Month(dCotacao) == 9
    nPorcentagemSeguro2 -= 0.08
endif

nAnualSeguro2      := nBaseSeguro2 + (nBaseSeguro2 * nPorcentagemSeguro2)
nTrimestralSeguro2 := nAnualSeguro2 / 3
nMensalSeguro2     := nAnualSeguro2 / 12
//=============================================================

if nMensalSeguro1 < nMensalSeguro2
    cCorSeguro2 := "w/r"
else
    cCorSeguro1 := "w/r"
endif

set color to w/r    
@ 17,00 to 23,39
@ 18,01 say "SEGURADORA 01"
@ 19,01 to 19,38
@ 20,01 say "Mensal....: " + Transform(nMensalSeguro1, "@E 999,999.99")
@ 21,01 say "Trimestral: " + Transform(nTrimestralSeguro1, "@E 999,999.99")
@ 22,01 say "Anual.....: " + Transform(nAnualSeguro1, "@E 999,999.99")

set color to cCorSeguro2
@ 17,40 to 23,79
@ 18,41 say "SEGURADORA 02"
@ 19,41 to 19,78
@ 20,41 say "Mensal....: " + Transform(nMensalSeguro2, "@E 999,999.99")
@ 21,41 say "Trimestral: " + Transform(nTrimestralSeguro2, "@E 999,999.99")
@ 22,41 say "Anual.....: " + Transform(nAnualSeguro2, "@E 9999,999.99")

inkey(0)

@ 24,00 say ""