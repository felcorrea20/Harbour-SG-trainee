   set date british
   set epoch to 1940
   setMode(25,80)

   clear

   //vendedor
   cNomeVendedor := Space(30)
   dDataCotacao  := Date()
   nAnoAtual     := Year(Date())


   //cliente
   cNomeCliente     := Space(30)
   nIdadeCliente    := 0        // 999
   cSexoCliente     := Space(1) // m ou f
   nAnoPrimeiraCnh  := 0        // 9999
   nAnosHabilitado  := 0

   //veiculo
   cMarcaVeiculo         := Space(20)
   nAnoFabricacao        := 0         // 9999
   cTipoVeiculo          := Space(1)  // P (passeio) / E (esportivo) / L (luxo)
   nMotorVeiculo         := 0         // "9.9"
   nValorFipe            := 0         // "@E 999,999.99"
   cUsoVeiculo           := Space(1)  // P (particular) / O (profissional)
   nAnosDesdeAFabricacao := nAnoAtual - nAnoFabricacao

   //seguro 1
   nValorSeguradora1 := 0
   nDescontoMarco    := 0.1

   //seguro 2
   nValorSeguradora2 := 0
   nDecontoSetembro  := 0.8

   cCorSeguradoraMaisBarata := "w/g"


   @ 00,00 to 24,79
   @ 01,01 say "NOME DO VENDEDOR:"
   @ 02,01 say "DATA DA COTACAO:"
   @ 03,01 to 03,78
   @ 04,01 say "DADOS DO CLIENTE"
   @ 05,01 say "NOME:"
   @ 06,01 say "IDADE:"
   @ 07,01 say "SEXO (M/F):"
   @ 08,01 say "ANO DA PRIMEIRA CNH:"
   @ 09,01 to 09,23
   @ 10,01 say "DADOS DO VEICULO"
   @ 11,01 say "MARCA: "
   @ 12,01 say "ANO DE FABRICACAO: "
   @ 13,01 say "TIPO DO VEICULO (P - PASSEIO / E - ESPORTIVO / L - LUXO): "
   @ 14,01 say "MOTOR: "
   @ 15,01 say "VALOR (TABELA FIPE): R$ "
   @ 16,01 say "USO DO VEICULO (P - PARTICULAR / O - PROFISSIONAL): "

   @ 01,19 get cNomeVendedor   picture "@!"            valid !Empty(cNomeVendedor)
   @ 05,07 get cNomeCliente    picture "@!"            valid !Empty(cNomeCliente)
   @ 06,08 get nIdadeCliente   picture "999"           valid nIdadeCliente >= 18 .and. nIdadeCliente <= 140
   @ 07,13 get cSexoCliente    picture "@!"            valid !Empty(cSexoCliente) .and. (cSexoCliente == "M" .or. cSexoCliente == "F")
   @ 08,22 get nAnoPrimeiraCnh picture "9999"          valid nAnoPrimeiraCnh >= 1893 .and. nAnoPrimeiraCnh <= 2025
   @ 11,09 get cMarcaVeiculo   picture "@!"            valid !Empty(cMarcaVeiculo)
   @ 12,21 get nAnoFabricacao  picture "9999"          valid nAnoFabricacao <= nAnoAtual
   @ 13,60 get cTipoVeiculo    picture "@!"            valid (cTipoVeiculo == "P" .or. cTipoVeiculo == "E") .or. cTipoVeiculo == "L" 
   @ 14,09 get nMotorVeiculo   picture "9.9"           valid nMotorVeiculo >= 1
   @ 15,26 get nValorFipe      picture "@E 999,999.99" valid nValorFipe > 0
   @ 16,54 get cUsoVeiculo     picture "@!"            valid cUsoVeiculo == "P" .or. cUsoVeiculo == "O" 
   read

   nAnosHabilitado := nAnoAtual - nAnoPrimeiraCnh

//=seguradora 01===============================================================
   nValorSeguradora1 += nValorFipe * 0.06 //(6% do valor da fipe)

   if nIdadeCliente < 25 .or. nIdadeCliente > 65 
      nValorSeguradora1 += nValorSeguradora1 * 0.1
   endif

   if cSexoCliente == "M"
      nValorSeguradora1 += nValorSeguradora1 * 0.1
   else
      nValorSeguradora1 -= nValorSeguradora1 * 0.05
   endif

   if  nAnosHabilitado <= 3
      nValorSeguradora1 += nValorSeguradora1 * 0.15
   elseif nAnosHabilitado >= 8
      nValorSeguradora1 -= nValorSeguradora1 * 0.1
   endif

   if cTipoVeiculo == "E"
      nValorSeguradora1 += nValorSeguradora1 * 0.1   
   elseif cTipoVeiculo == "L"
      nValorSeguradora1 += nValorSeguradora1 * 0.2
   endif

   if nMotorVeiculo > 2
      nValorSeguradora1 += nValorSeguradora1 * 0.15
   endif

   if nAnosDesdeAFabricacao > 20
      nValorSeguradora1 += nValorSeguradora1 * 0.1
   else 
      nValorSeguradora1 += nValorSeguradora1 * (nAnosDesdeAFabricacao * 0.005)
   endif
   
   if cUsoVeiculo == "O"
      nValorSeguradora1 += nValorSeguradora1 * 0.1
   endif

   if Month(Date) == 3
      nValorSeguradora1 -= nValorSeguradora1 * 0.1
   endif