/*
* Programador(a): Felipe Correa
* Criado em.....: 08/02/2026
* Funcao........: Funcao
*
* +------------------------------------------------------------------+
* |                    Dados da ultima alteracao                     |
* +------------------------------------------------------------------+
* | $Date::                                                        $ |
* | $Revision::                                                    $ |
* | $Author::                                                      $ |
* +------------------------------------------------------------------+
*/

/*******************************************************************************/
procedure TermoTchiulepera()

   local cTermo

   SetColor( m->cor21 )

   do while DefineTermo( @cTermo )
      JogoTermo( cTermo )
   enddo

return

/*******************************************************************************/
static function DefineTermo( cTermo )

   local GetList := {}
   local oSGScreen := SGScreenConfigurationManager():new():grava()

   Caixa( 11, 30, 14, 60, 'Configuracao Termo', m->cor21, '[ESC] Sair' )

   cTermo := Space( 13 )

   @ 12, 31 say 'Digite o termo: '
   @ 12, 47 get cTermo picture '@!' valid !Empty( cTermo ) .and. !( ' ' $ AllTrim( cTermo ) ) color m->cor21
   read

   if LastKey() == 27
      oSGScreen:restaura()
      return .f.
   endif

   cTermo := AllTrim( cTermo )

   oSGScreen:restaura()

return YesNo( 'Deseja iniciar o jogo?' )

/*******************************************************************************/
static procedure JogoTermo( cTermo )

   local oSGScreen := SGScreenConfigurationManager():new():grava()
   local GetList   := {}
   local nTamanhoTermo,  cPalavraUser, nTentativas, lAcertou, nLinhaGet, cCopiaTermo
   local cLetraUser, cLetraTermo, nPosicao, cCor, nPosicao2

   nTamanhoTermo := Len( cTermo )
   Caixa( 08, 30, 16, 50, 'Termo - ' + StrAt( nTamanhoTermo ) + ' caracteres', m->cor21 )
   Caixa( 08, 55, 10, 78, 'Tentativas restantes:' )

   lAcertou      := .f.
   nTentativas   := 1
   nLinhaGet     := 8

   do while nTentativas <= 5 .and. !lAcertou

      @ 09, 60 say 6 - nTentativas++

      cPalavraUser  := Space( nTamanhoTermo )

      @ ++nLinhaGet, 31 get cPalavraUser picture '@!' valid ValidaPalavraDigitada( @cPalavraUser )
      read

      if LastKey() == 27
         if YesNo( 'Deseja realmente sair?' )
            oSGScreen:restaura()
            return
         endif
         loop
      endif

      cCopiaTermo := cTermo
      nPosicao    := 0

      // letras na posicao certa
      do while ++nPosicao <= nTamanhoTermo

         cLetraUser  := SubStr( cPalavraUser, nPosicao, 1 )
         cLetraTermo := SubStr( cTermo, nPosicao, 1 )

         if !( cLetraUser == cLetraTermo )
            loop
         endif

         if nPosicao == 1
            cCopiaTermo := ' ' + SubStr( cCopiaTermo, nPosicao + 1 )
         elseif nPosicao == nTamanhoTermo
            cCopiaTermo := SubStr( cCopiaTermo, 1, nPosicao - 1 ) + ' '
         else
            cCopiaTermo := SubStr( cCopiaTermo, 1, nPosicao - 1 ) + ' ' + SubStr( cCopiaTermo, nPosicao + 1 )
         endif

      enddo

      // imprime letras
      nPosicao := 0
      do while ++nPosicao <= nTamanhoTermo

         cLetraUser  := SubStr( cPalavraUser, nPosicao, 1 )
         cLetraTermo := SubStr( cTermo, nPosicao, 1 )

         cCor := 'w/n'
         if cLetraUser == cLetraTermo
            cCor := 'g/n'
         elseif cLetraUser $ cCopiaTermo
            cCor := 'r/n'

            nPosicao2 := 0
            do while ++nPosicao2 <= Len( AllTrim( cCopiaTermo ) )

               if SubStr( cCopiaTermo, nPosicao2, 1) != cLetraUser
                  loop
               endif

               if nPosicao2 == 1
                  cCopiaTermo := ' ' + SubStr( cCopiaTermo, nPosicao2 + 1 )
               elseif nPosicao2 == nTamanhoTermo
                  cCopiaTermo := SubStr( cCopiaTermo, 1, nPosicao2 - 1 ) + ' '
               else
                  cCopiaTermo := SubStr( cCopiaTermo, 1, nPosicao2 - 1 ) + ' ' + SubStr( cCopiaTermo, nPosicao2 + 1 )
               endif
               exit
            enddo

         endif

         @ nLinhaGet, 30 + nPosicao say cLetraUser color cCor
         Inkey( 0.4 )

      enddo

      if cPalavraUser == cTermo
         lAcertou := .t.
      endif

   enddo

   if lAcertou
      Msg( 'Parabens!!!' )
   else
      Msg( 'Mais sorte da proxima vez...' )
   endif

   oSGScreen:restaura()

return

/*******************************************************************************/
static function ValidaPalavraDigitada( cPalavraUser )

   if Empty( cPalavraUser )
      Msg( 'Digite algo!' )
      return .f.
   endif

   if ' ' $ cPalavraUser
      Msg( 'A palavra nao deve conter espacos!' )
      return .f.
   endif

   cPalavraUser := AllTrim( cPalavraUser )

return .t.
