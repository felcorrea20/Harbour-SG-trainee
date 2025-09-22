clear

cPalavra          := Space(20)
cPalavraInvertida := ""
nTamanhoPalavra   := 0

@ 01,01 say "Digite uma palavra: "

@ 01,21 get cPalavra picture "@!" valid !Empty(cPalavra)
read

nTamanhoPalavra := Len(AllTrim(cPalavra))

do while nTamanhoPalavra > 0
    cPalavraInvertida += SubStr(cPalavra, nTamanhoPalavra--, 1)
enddo

@ 02,01 say 'Palavra invertida.: ' + AllTrim(cPalavraInvertida)