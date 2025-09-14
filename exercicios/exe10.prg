  clear

   nIdade := 0

   @ 00,00 to 04,30
   @ 01,01 say "DIGITE UMA IDADE:"

   @ 02,01 to 02,29

   @ 01,19 get nIdade picture "@E 999" valid nIdade >= 0
   read

   if nIdade > 21
      @ 03,01 say "VOCE TEM MAIS QUE 21 ANOS"
   elseif nIdade < 21
      @ 03,01 say "VOCE TEM MENOS QUE 21 ANOS..."
   else
      @ 03,01 say "VOCE TEM 21 ANOS"
   endif

   @ 06,01 say ""
