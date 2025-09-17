   set date british
   set epoch to 1940
   setMode(25,80)

   clear

   cNomeVendedor := Space(30)
   dDataCotacao  := Date()

   //cliente
   cNomeCliente     := Space(30)
   nIdadeCliente    := 0          // 999
   cSexoCliente     := Space(1)   // M / F
   nAnoPrimeiraCnh  := 0          // 9999
   nTempoHabilitado := 0

   //veiculo
   cMarcaVeiculo  := Space(20)
   nAnoFabricacao := 0
   cTipoVeiculo   := Space(1)
   nMotorVeiculo  := 0        //9.9
   nValorFipe     := 0
   cUsoVeiculo    := Space(1) //P / O

   //seguro 01
   nValorSeguro1  := 0
   nDescontoMarco := 0.1

   //seguro 2
   nValorSeguro2     := 0
   nDescontoSetembro := 0.8

   cCorSeguroMaisBarato := "w/g"

   @ 00,00 to 24,79
   @ 01,01 say "NOME DO VENDEDOR:"
   @ 02,01 say "DATA DA COTACAO" + DToC(dDataCotacao)
   @ 03,01 to 03,78
   @ 04,01 say "DADOS DO CLIENTE:"
   @ 05,01 say "NOME:"
   @ 06,01 say "IDADE:"
   @ 07,01 say "SEXO (M/F):"
   @ 08,01 say "ANO DA PRIMEIRA CNH:"

   @ 01,19 get cNomeVendedor picture "@!" valid !Empty(cNomeVendedor)
   @ 05,07 get cNomeCliente picture "@!" valid !Empty(cNomeCliente)
   @ 06,08 get nIdadeCliente picture "999" valid nIdadeCliente >= 18 .and. nIdadeCliente <= 150
   @ 07,13 get cSexoCliente picture "@!" valid cSexoCliente == "M" .or. cSexoCliente == "F"
   @ 08,22 get nAnoPrimeiraCnh picture "9999" valid nAnoPrimeiraCnh <= Year(Date()) .and. nAnoPrimeiraCnh >= 1893
   read


