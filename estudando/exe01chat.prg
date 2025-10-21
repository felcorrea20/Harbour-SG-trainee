/*
* Programador(a): Felipe Correa
* Criado em.....: 21/10/2025
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

procedure main()

   local cNome       := Space(30)
   local nPreco      := 0
   local nQuantidade := 0
   local dValidade   := CToD('')

   set date brit 
   set epoch to 1940
   clear

   @ 01,01 say 'Nome......: '
   @ 02,01 say 'Preco.....: '
   @ 03,01 say 'Quantidade: '
   @ 04,01 say 'Validade..: '

   @ 01,13 get cNome       picture '@!'         valid !Empty( cNome )
   @ 02,13 get nPreco      picture '@E 9999.99' valid nPreco > 0
   @ 03,13 get nQuantidade picture '999'        valid nQuantidade > 0
   @ 04,13 get dValidade                        valid !Empty( dValidade )
   read

   aProdutos := {cNome, nPreco, nQuantidade, dValidade}

   Listar(aProdutos)

return 

/*******************************************************************************/
procedure Listar( aProdutos )

   local nLinha := 6
   local nTmp   := 1
   
   do while nTmp <= Len( aProdutos )

      @ nLinha++, 01 say aProdutos[ nTmp++ ]

   enddo

return
