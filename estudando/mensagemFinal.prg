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

@ 01,25 say "Cotacao valida ate "
@ 01,44 say dUltimoDia

inkey(0)
@ 03,00 say ""