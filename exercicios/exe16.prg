   setMode(25,80)

   clear

   nRepeticao := 0
   nContador  := 0
   cNome      := Space(20)

   @ 01,01 say "SEU NOME............:"
   @ 02,01 say "NUMERO DE REPETICOES:"

   @ 01,23 get cNome      picture "@!" valid !Empty(cNome)
   @ 02,23 get nRepeticao picture "99" valid nRepeticao > 0
   read

   inKey(1)

   do while nContador != nRepeticao
      @ (nContador + 4),nContador say cNome
      nContador++
      inKey(0.2)
   enddo
