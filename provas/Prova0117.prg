   //PROVA REALIZADA POR FELIPE CORREA
   set scoreBoard off
   setMode(25,80)
   set epoch to 1940
   set date british

   clear

   //variaveis aluno
   cNomeAluno       := Space(30)
   dNascimentoAluno := CToD("")
   cCurso           := Space(30)
   nSerie           := 0
   nMensalidade     := 0
   nNovaMensalidade := 0

   //variaveis aux
   nMediaParaPassar       := 0
   nMaximoFaltas          := 0
   nReprovacoes           := 0
   cSituacaoFinal         := "APROVADO" // (APROVADO/REPROVADO/APROVADO COM DP)
   cCorSituacaoFinal      := "W/G"
   nAumentoMensalidade    := 0.2        // 20%
   cDisciplinasReprovadas := ""

   //disciplinas
   cDisciplina1 := Space(20)
   cDisciplina2 := Space(20)
   cDisciplina3 := Space(20)

   //disciplina 1
   nNotaDisciplina1Bimestre1   := 0
   nNotaDisciplina1Bimestre2   := 0
   nNotaDisciplina1Bimestre3   := 0
   nNotaDisciplina1Bimestre4   := 0

   nFaltasDisciplina1Bimestre1 := 0
   nFaltasDisciplina1Bimestre2 := 0
   nFaltasDisciplina1Bimestre3 := 0
   nFaltasDisciplina1Bimestre4 := 0

   nMediaDisciplina1       := 0
   nSomaFaltasDisciplina1  := 0
   cSituacaoDisciplina1    := "AP"  // (AP/RP)
   cCorSituacaoDisciplina1 := "W/G"


   //disciplina 2
   nNotaDisciplina2Bimestre1   := 0
   nNotaDisciplina2Bimestre2   := 0
   nNotaDisciplina2Bimestre3   := 0
   nNotaDisciplina2Bimestre4   := 0

   nFaltasDisciplina2Bimestre1 := 0
   nFaltasDisciplina2Bimestre2 := 0
   nFaltasDisciplina2Bimestre3 := 0
   nFaltasDisciplina2Bimestre4 := 0

   nMediaDisciplina2       := 0
   nSomaFaltasDisciplina2  := 0
   cSituacaoDisciplina2    := "AP"
   cCorSituacaoDisciplina2 := "W/G"

   //disciplina 3
   nNotaDisciplina3Bimestre1   := 0
   nNotaDisciplina3Bimestre2   := 0
   nNotaDisciplina3Bimestre3   := 0
   nNotaDisciplina3Bimestre4   := 0

   nFaltasDisciplina3Bimestre1 := 0
   nFaltasDisciplina3Bimestre2 := 0
   nFaltasDisciplina3Bimestre3 := 0
   nFaltasDisciplina3Bimestre4 := 0

   nMediaDisciplina3       := 0
   nSomaFaltasDisciplina3  := 0
   cSituacaoDisciplina3    := "AP"
   cCorSituacaoDisciplina3 := "W/G"

//=============================================================================

   @ 00,00 to 09,79
   @ 01,01 say "                   COLEGIO NOSSA SENHORA DO BOM CONSELHO"
   @ 02,01 say "ENDERECO: RUA FERNANDO DE NORONHA, 4859 , JARDIM - ORIENTAL"
   @ 03,01 say "TELEFONE: (44) 3398-2073"
   @ 04,01 to 04,78
   @ 05,01 say "DADOS DO ALUNO"
   @ 06,01 say "NOME.:"
   @ 06,39 say "DATA DE NASCIMENTO:"
   @ 07,01 SAY "CURSO:"
   @ 07,39 SAY "SERIE:"
   @ 08,01 SAY "VALOR DA MENSALIDADE: R$ "

   @ 06,08 get cNomeAluno       picture "@!"          valid !Empty(cNomeAluno)
   @ 06,59 get dNascimentoAluno                       valid dNascimentoAluno <= Date()
   @ 07,08 get cCurso           picture "@!"          valid !Empty(cCurso)
   @ 07,47 get nSerie           picture "9"           valid nSerie >= 1 .and. nSerie <=8
   @ 08,27 get nMensalidade     picture "@E 9,999.99" valid nMensalidade > 0
   read

   if nSerie <= 4
      nMediaParaPassar := 60
   else
      nMediaParaPassar := 70
   endif

   if nSerie <= 3
      nMaximoFaltas := 4 * 6 //permitido ate 6 faltas por bimestre(4)
   else
      nMaximoFaltas := 4 * 8 //permitido ate 8 faltas por bimestre(4)
   endif

   @ 12,01 say ""
   inKey(0)

//=============================================================================

   @ 10,00 to 17,79
   @ 11,01 say "BOLETIM ESCOLAR"
   @ 12,01 say "                    |  1 BIM  |  2 BIM  |  3 BIM  |  4 BIM  |   MEDIA   |SITUA"
   @ 13,01 say "DISCIPLINA          |  N | F  |  N | F  |  N | F  |  N | F  |  N  |  F  | CAO "

   //disciplina 1
   @ 14,01 get cDisciplina1                picture "@!"  valid  !Empty(cDisciplina1)
   @ 14,23 get nNotaDisciplina1Bimestre1   picture "999" valid  nNotaDisciplina1Bimestre1 >= 0 .and. nNotaDisciplina1Bimestre1 <= 100
   @ 14,28 get nFaltasDisciplina1Bimestre1 picture "99"  valid  nFaltasDisciplina1Bimestre1 >= 0
   @ 14,33 get nNotaDisciplina1Bimestre2   picture "999" valid  nNotaDisciplina1Bimestre2 >= 0 .and. nNotaDisciplina1Bimestre2 <= 100
   @ 14,38 get nFaltasDisciplina1Bimestre2 picture "99"  valid  nFaltasDisciplina1Bimestre2 >= 0
   @ 14,43 get nNotaDisciplina1Bimestre3   picture "999" valid  nNotaDisciplina1Bimestre3 >= 0 .and. nNotaDisciplina1Bimestre3 <= 100
   @ 14,48 get nFaltasDisciplina1Bimestre3 picture "99"  valid  nFaltasDisciplina1Bimestre3 >= 0
   @ 14,53 get nNotaDisciplina1Bimestre4   picture "999" valid  nNotaDisciplina1Bimestre4 >= 0 .and. nNotaDisciplina1Bimestre4 <= 100
   @ 14,58 get nFaltasDisciplina1Bimestre4 picture "99"  valid  nFaltasDisciplina1Bimestre4 >= 0
   read

   nMediaDisciplina1      := (nNotaDisciplina1Bimestre1 + nNotaDisciplina1Bimestre2 + nNotaDisciplina1Bimestre3 + nNotaDisciplina1Bimestre4) / 4
   nSomaFaltasDisciplina1 := nFaltasDisciplina1Bimestre1 + nFaltasDisciplina1Bimestre2 + nFaltasDisciplina1Bimestre3 + nFaltasDisciplina1Bimestre4

   if nMediaDisciplina1 < nMediaParaPassar .or. nSomaFaltasDisciplina1 > nMaximoFaltas
      cSituacaoDisciplina1    := "RP"
      cCorSituacaoDisciplina1 := "W/R"
      nReprovacoes++
      cDisciplinasReprovadas  += "|" + AllTrim(cDisciplina1)
   endif

   @ 14,62 say nMediaDisciplina1      picture "@E 999.9"
   @ 14,69 say nSomaFaltasDisciplina1 picture "999"
   @ 14,75 say cSituacaoDisciplina1   color cCorSituacaoDisciplina1
//=============================================================================
   //disciplina 2
   @ 15,01 get cDisciplina2                picture "@!"  valid  !Empty(cDisciplina2)
   @ 15,23 get nNotaDisciplina2Bimestre1   picture "999" valid  nNotaDisciplina2Bimestre1 >= 0 .and. nNotaDisciplina2Bimestre1 <= 100
   @ 15,28 get nFaltasDisciplina2Bimestre1 picture "99"  valid  nFaltasDisciplina2Bimestre1 >= 0
   @ 15,33 get nNotaDisciplina2Bimestre2   picture "999" valid  nNotaDisciplina2Bimestre2 >= 0 .and. nNotaDisciplina2Bimestre2 <= 100
   @ 15,38 get nFaltasDisciplina2Bimestre2 picture "99"  valid  nFaltasDisciplina2Bimestre2 >= 0
   @ 15,43 get nNotaDisciplina2Bimestre3   picture "999" valid  nNotaDisciplina2Bimestre3 >= 0 .and. nNotaDisciplina2Bimestre3 <= 100
   @ 15,48 get nFaltasDisciplina2Bimestre3 picture "99"  valid  nFaltasDisciplina2Bimestre3 >= 0
   @ 15,53 get nNotaDisciplina2Bimestre4   picture "999" valid  nNotaDisciplina2Bimestre4 >= 0 .and. nNotaDisciplina2Bimestre4 <= 100
   @ 15,58 get nFaltasDisciplina2Bimestre4 picture "99"  valid  nFaltasDisciplina2Bimestre4 >= 0
   read

   nMediaDisciplina2      := (nNotaDisciplina2Bimestre1 + nNotaDisciplina2Bimestre2 + nNotaDisciplina2Bimestre3 + nNotaDisciplina2Bimestre4) / 4
   nSomaFaltasDisciplina2 := nFaltasDisciplina2Bimestre1 + nFaltasDisciplina2Bimestre2 + nFaltasDisciplina2Bimestre3 + nFaltasDisciplina2Bimestre4

   if nMediaDisciplina2 < nMediaParaPassar .or. nSomaFaltasDisciplina2 > nMaximoFaltas
      cSituacaoDisciplina2    := "RP"
      cCorSituacaoDisciplina2 := "W/R"
      nReprovacoes++
      cDisciplinasReprovadas  += "|" + AllTrim(cDisciplina2)
   endif

   @ 15,62 say nMediaDisciplina2      picture "@E 999.9"
   @ 15,69 say nSomaFaltasDisciplina2 picture "999"
   @ 15,75 say cSituacaoDisciplina2   color cCorSituacaoDisciplina2
//=============================================================================
   //disciplina 3
   @ 16,01 get cDisciplina3                picture "@!"  valid  !Empty(cDisciplina3)
   @ 16,23 get nNotaDisciplina3Bimestre1   picture "999" valid  nNotaDisciplina3Bimestre1 >= 0 .and. nNotaDisciplina3Bimestre1 <= 100
   @ 16,28 get nFaltasDisciplina3Bimestre1 picture "99"  valid  nFaltasDisciplina3Bimestre1 >= 0
   @ 16,33 get nNotaDisciplina3Bimestre2   picture "999" valid  nNotaDisciplina3Bimestre2 >= 0 .and. nNotaDisciplina3Bimestre2 <= 100
   @ 16,38 get nFaltasDisciplina3Bimestre2 picture "99"  valid  nFaltasDisciplina3Bimestre2 >= 0
   @ 16,43 get nNotaDisciplina3Bimestre3   picture "999" valid  nNotaDisciplina3Bimestre3 >= 0 .and. nNotaDisciplina3Bimestre3 <= 100
   @ 16,48 get nFaltasDisciplina3Bimestre3 picture "99"  valid  nFaltasDisciplina3Bimestre3 >= 0
   @ 16,53 get nNotaDisciplina3Bimestre4   picture "999" valid  nNotaDisciplina3Bimestre4 >= 0 .and. nNotaDisciplina3Bimestre4 <= 100
   @ 16,58 get nFaltasDisciplina3Bimestre4 picture "99"  valid  nFaltasDisciplina3Bimestre4 >= 0
   read

   nMediaDisciplina3      := (nNotaDisciplina3Bimestre1 + nNotaDisciplina3Bimestre2 + nNotaDisciplina3Bimestre3 + nNotaDisciplina3Bimestre4) / 4
   nSomaFaltasDisciplina3 := nFaltasDisciplina3Bimestre1 + nFaltasDisciplina3Bimestre2 + nFaltasDisciplina3Bimestre3 + nFaltasDisciplina3Bimestre4

   if nMediaDisciplina3 < nMediaParaPassar .or. nSomaFaltasDisciplina3 > nMaximoFaltas
      cSituacaoDisciplina3    := "RP"
      cCorSituacaoDisciplina3 := "W/R"
      nReprovacoes++         //crucial
      cDisciplinasReprovadas  += "|" + AllTrim(cDisciplina3)
   endif

   @ 16,62 say nMediaDisciplina3      picture "@E 999.9"
   @ 16,69 say nSomaFaltasDisciplina3 picture "999"
   @ 16,75 say cSituacaoDisciplina3   color cCorSituacaoDisciplina3

   inKey(0)
//============================================================================
   if nReprovacoes >= 3
      cSituacaoFinal    := "REPROVADO"
      cCorSituacaoFinal := "W/R"
   elseif nReprovacoes > 0
      cSituacaoFinal      := "APROVADO COM DP"
      cCorSituacaoFinal   := "W/B"  
      nNovaMensalidade := nMensalidade + (nAumentoMensalidade * nReprovacoes * nMensalidade)
   endif

   @ 18,00  to 23,79
   @ 19,01 say "SITUACAO FINAL: "
   @ 19,17 say cSituacaoFinal color cCorSituacaoFinal

   if Empty(nReprovacoes)
      @ 21,01 say "PARABENS!!!"
      @ 22,01 say "VOCE PASSOU DE ANO"
   elseif nReprovacoes > 2
      @ 21,01 say "ESTUDE MAIS..."
   else
      @ 21,01 say "DISCIPLINA(S) COM DP: " + AllTrim(cDisciplinasReprovadas)
      @ 22,01 say "NOVO VALOR DA MENSALIDADE: R$ " + AllTrim(Transform(nNovaMensalidade, "@E 9,999.99"))
   endif

   @ 24,01 say ""