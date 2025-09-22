clear
@ 01,01 say "D  S  T  Q  Q  S  S"

nMes := Month(Date())
nAno := Year(Date())

// FORMA CORRETA - use StrZero()
cPrimeiroDiaMes := "01/" + StrZero(nMes, 2) + "/" + StrZero(nAno, 4)
dPrimeiroDiaMes := CToD(cPrimeiroDiaMes)
nDoWPrimeiroDiaMes := DoW(dPrimeiroDiaMes)  

// Debug para verificar
@ 04,01 say "Data: " + cPrimeiroDiaMes
@ 05,01 say "DOW: " + Str(nDoWPrimeiroDiaMes)
@ 06,01 say "Dia Semana: " + CDow(dPrimeiroDiaMes)
@ 07,01 say "Data Real: " + DToC(dPrimeiroDiaMes)