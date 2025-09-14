   clear

   nNumero   := 0
   nContador := 1

   @ 00,00 to 02,16
   @ 01,01 say"TABUADA DO: "

   @ 01,13 get nNumero picture "99"
   read

   @ 04,00 to 15,20

   do while nContador != 11
      nMultiplicado := nNumero * nContador

      @ (nContador+4),02 say nNumero
      @ (nContador+4),05 say "*"
      @ (nContador+4),07 say nContador
      @ (nContador+4),09 say "="
      @ (nContador+4),11 say Transform(nMultiplicado "@E 9,999.99")
      nContador++
   enddo
