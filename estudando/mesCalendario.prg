set date brit
set epoch to 1940

clear

@ 00,00 to 07,28

// dias da semana
// colunas -> 2   6   10  14  18  22  26
@ 01,01 say " D   S   T   Q   Q   S   S"  

//variaveis auxiliares
nLinha            := 2   // linha que comeca o primeiro DoW
nColuna           := 0   
nDiasCalendario   := 1   //dias que serao apresentados ao user em formato de calendario
nMes              := Month(Date())
nAno              := Year(Date())
cCorDiaHoje       := "w/n"

//primeiro dia do mes
cPrimeiroDiaMes    := "01/" + AllTrim(Str(nMes)) + "/" + AllTrim(Str(nAno)) 
dPrimeiroDiaMes    := CToD(cPrimeiroDiaMes) //pego o mes atual e coloco no primeiro dia do mes
nDoWPrimeiroDiaMes := DoW(dPrimeiroDiaMes)  // me retorna o dia da semana do primeiro dia dos mes

//ultimo dia do mes
nProximoMes := nMes + 1

if nProximoMes > 12
     nProximoMes := 1
     nAno++
endif

cPrimeiroDiaProximoMes :=  "01/" + AllTrim(Str(nProximoMes)) + "/" + AllTrim(Str(nAno))
dUltimoDiaMes          := CToD(cPrimeiroDiaProximoMes) - 1 
nColuna                := (nDoWPrimeiroDiaMes * 3 ) + (nDoWPrimeiroDiaMes - 2) // formula para alinhar os dias com as determinadas colunas 

//calendario
do while nDiasCalendario <= Day(dUltimoDiaMes)  // vai de 0 a 30(por exemplo) 
   if nDiasCalendario == Day(Date())
        cCorDiaHoje := "w/r"
   else
        cCorDiaHoje := "w/n"
   endif

   @ nLinha,nColuna say AllTrim(Str(nDiasCalendario++)) picture "99" color cCorDiaHoje

   if nColuna == 26
      nLinha++
      nColuna := 2
   else
      nColuna += 4
   endif
enddo

@ 23,01 say ""