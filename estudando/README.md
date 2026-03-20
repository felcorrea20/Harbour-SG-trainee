# Documentacao dos Modulos de Correcao de Notas/Produtos

Data da analise: 18/03/2026

## Escopo

Este documento descreve o funcionamento dos modulos:

- Correcao de Notas / Produtos (legado)
- Nova Correcao de Notas / Produtos

Base tecnica utilizada:

- Fluxo legado: `new/cep617.prg` + regras de gravacao em `new/CorrecaoDeNotasEProdutos.prg`
- Fluxo novo: `new/NovaCorrecaoDeNotasEProdutosHrb.prg` + regras de negocio/gravacao em `new/NovaCorrecaoDeNotasEProdutos.prg`

---

## 1) Correcao de Notas / Produtos (legado)

### 1.1 Fluxo geral

1. Usuario informa:
- Tipo: Outras Notas, Notas de Troca, Imobilizado
- Filial
- E/S (Entrada/Saida)
- Chave (ou consulta por periodo/numero)

2. Sistema carrega:
- Cabecalho da nota (REGENT/REGSAI)
- Itens de movimentacao (MOVPRO/MOVTRO)
- Bases e totais fiscais

3. Durante a manutencao permite:
- Inserir, alterar e excluir itens
- Alterar tipo de movimentacao
- Alterar dados de transporte/frete
- Ajustar desconto de item
- Ajustes complementares (ex.: ICMS ST retido anteriormente, indicador IE)

4. Ao sair, valida consistencias e grava alteracoes.

### 1.2 Regras de bloqueio por status (legado)

#### Nota de saida
Nao permite correcao quando a nota estiver:

- CANCELADA
- PENDENTE

#### Nota de entrada
No fluxo legado, nao ha bloqueio explicito por status de cancelada/pendente em entrada dentro de `ValidaChave()`.
A entrada e localizada por chave e segue para edicao, respeitando as demais regras de seguranca.

#### Fechamento da escrita fiscal (entrada e saida)
Nao permite alteracao quando a data da nota for menor ou igual a data de fechamento fiscal da filial:

- `dNota <= cadfil->datfech99`

(Validacao em `new/cep617.prg`.)

### 1.3 Campos/areas editaveis (legado)

#### Cabecalho da nota
- Tipo de movimentacao/transacao da nota
- Dados de transportadora/frete
- Indicador de IE (tipo de contribuinte)

#### Itens da nota (produto/troca)
- Codigo do produto (na inclusao)
- Quantidade
- Unidade
- Embalagem (quando aplicavel)
- Preco
- ICMS (aliquota, reducao, base, CST/CSOSN conforme contexto)
- ICMS ST e FCP ST (quando aplicavel)
- IPI (valor, CST IPI, enquadramento)
- CFOP
- PIS/COFINS e natureza da receita
- Campos de FCP (aliquotas relacionadas)
- Tipo de movimentacao do item
- Ordem do item
- Desconto do item

Observacao:
A disponibilidade pratica depende de regras fiscais (CST/CSOSN/tributacao), validacoes de tela e tipo da nota.

### 1.4 Impacto em estoque e custo (legado)

#### Estoque
Existe controle por parametro interno (`lAtualizaEstoque`).
Quando ativo, a rotina chama atualizacao de estoque do cadastro do produto (`AtualizaEstoqueCadpro`).
Quando desativado e houver mudanca de quantidade/embalagem, a tela avisa que o estoque nao sera alterado e pede confirmacao.

#### Custo
Em cenarios de entrada com transacao especifica (`CBG`) e custo vazio, o custo do item pode ser preenchido com base no preco da nota (`movpro->custo05 := movpro->preconot05`).
Tambem ha ajustes de preco/custo vinculados a alteracao de quantidade/preco conforme regras do fluxo.

### 1.5 Persistencia e integracao (legado)

Ao confirmar alteracoes, a rotina grava em tabelas de negocio/fiscal (MOVPRO/MOVTRO/REGENT/REGSAI e relacionadas) e gera pacote de alteracao para nota de entrada ou saida (chamada `Gera_Pacote(...)` em `VerificaSePodeSair()`).

---

## 2) Nova Correcao de Notas / Produtos

### 2.1 Fluxo geral

1. Usuario informa:
- Tipo (movimentacao ou bem/imobilizado)
- Filial
- E/S
- Chave (com opcoes de busca)

2. Sistema carrega estrutura da nota em objeto (`SGCorrecaoNota`) e itens em objetos de detalhe tributario/fiscal.

3. Edicao por telas especializadas:
- Porduto/Servicos
- ICMS e ST
- IPI
- PIS/COFINS
- IBS/CBS

4. Opcoes adicionais (atalhos):
- F4 Movimentacao
- F5 Transporte
- F6 Status da nota
- F7 Tipo de contribuinte
- F8 Receituario
- F9 Guia de transito

5. Fechamento grava as alteracoes em MOVPRO/MOVTRO/MOVAUX (ou MOVBEM para bens), e atualiza totais no REGENT/REGSAI.

### 2.2 Regras de bloqueio por status (nova)

#### 2.2.1 Cancelada/Pendente
No processo de validacao da chave:

- Saida cancelada: bloqueia
- Saida pendente: bloqueia

Em bens/imobilizado de saida tambem bloqueia cancelada/pendente.

#### 2.2.2 Fechamento fiscal
Tambem bloqueia quando data da nota for menor ou igual ao fechamento da escrita fiscal da filial:

- `dNota <= cadfil->datfech99`

#### 2.2.3 Status eletronico que torna a nota nao editavel
A nova rotina aplica regra adicional de editabilidade por status de documento eletronico (`lPodeEditarNota`).

Para nota de SAIDA, modelo NFe (55), a edicao da nota fica bloqueada quando status estiver em:

- ENVIADA_E_AUTORIZADA_NA_RECEITA (9)
- CANCELAMENTO_INUTILIZADA_NA_RECEITA (23)
- CANCELAMENTO_DENEGADA_NA_RECEITA (21)

Nesses casos, o usuario ainda pode consultar, mas sem permissao de alteracao.

### 2.3 Campos/areas editaveis (nova)

A nova rotina organiza os campos por grupos funcionais.

#### Produto/Servicos
- Codigo, descricao, quantidade, embalagem, unidade, preco
- CFOP
- Frete, seguro, desconto, outros
- Receituario e CPF responsavel tecnico
- Informacoes complementares: declaracao de importacao, grupo de exportacao, combustiveis, rastreabilidade

#### ICMS e ST
- Origem/CST/CSOSN
- BC, aliquotas, reducoes
- ICMS proprio, ICMS ST
- FCP/FCP ST
- MVA
- Partilha/repasse e ST retido anteriormente (conforme cenario)

#### IPI
- Enquadramento IPI
- CST IPI
- BC IPI, aliquota IPI, valor IPI

#### PIS/COFINS
- CST PIS e CST COFINS
- BC, aliquotas e valores
- Natureza da receita

#### IBS/CBS
- Codigo situacao tributaria IBS/CBS
- Codigo classificacao tributaria
- Aliquotas, base, reducoes
- Diferimento e valores associados

Observacao:
Assim como no legado, a liberacao de campos depende de contexto fiscal (CST/CSOSN/modelo/tipo de nota) e regras de tela.

### 2.4 Impacto em estoque e custo (nova)

- A nova rotina grava diretamente movimentacao e totais fiscais (MOVPRO/MOVTRO/MOVBEM, REGENT/REGSAI etc.).
- Nao foi identificada atualizacao direta no estoque da CADPRO no fluxo de fechamento da nova correcao.

Conclusao pratica:
- Ha impacto nos dados de movimentacao e valores fiscais da nota.
- Alteracao direta de saldo atual de estoque no cadastro (via rotina dedicada de atualizacao de estoque) nao aparece no fechamento da nova rotina.
- O efeito em custo/saldo cadastral depende de como outras rotinas do sistema leem/recalculam MOVPRO/MOVTRO apos a correcao.

---

## 3) Respostas objetivas para as duvidas do Cloud

### 3.1 Quais status de notas permitem edicao (entrada e saida)?

#### Legado
- Saida: nao permite CANCELADA e PENDENTE.
- Entrada: sem bloqueio explicito por status de cancelada/pendente no ponto de validacao da chave.
- Ambos: bloqueia se data da nota estiver no periodo ja fechado da escrita fiscal.

#### Nova Correcao
- Saida: nao permite CANCELADA e PENDENTE na validacao da chave.
- Entrada: segue sem bloqueio explicito por cancelada/pendente no mesmo ponto.
- Ambos: bloqueia por fechamento fiscal.
- Regra adicional (nova): para saida NFe modelo 55, BLOQUEIA EDICAO DE CAMPOS quando status eletronico estiver em 9, 21 ou 23.

### 3.2 Quais campos sao permitidos para edicao?

Nos dois modulos, é possivel editar cabecalho e itens, incluindo:

- Cabecalho: transacao/tipo de movimentacao, transporte/frete, indicador IE (contribuinte), e no novo modulo tambem status eletronico.
- Item: quantidade, unidade, embalagem, preco, CFOP, CST/CSOSN, ICMS/ST/FCP, IPI, PIS/COFINS, natureza da receita e campos adicionais do novo modelo (IBS/CBS, rastreabilidade, importacao/exportacao, receituario).

A permissao final por campo depende de:

- Status editavel da nota
- Tipo da nota (movimentacao x bem)
- Regras fiscais/tributarias aplicaveis

### 3.3 E possivel alterar dados que impactem estoque e custo?

- Legado: sim, com controle por parametro. Pode atualizar estoque do cadastro e afetar custo/preco em cenarios especificos.
- Nova: altera movimentacao e totais fiscais; nao ha evidencia de chamada direta de atualizacao de saldo cadastral de estoque no fechamento da rotina.

### 3.4 SPED e relatorios de apuracao consideram dados apos alteracao?

Sim, as alteracoes sao gravadas nas tabelas fiscais e de movimentacao utilizadas pelo ERP (REGENT/REGSAI/MOVPRO/MOVTRO e correlatas).
No legado, ainda ha geracao explicita de pacote de alteracao ao finalizar.

Portanto, a tendencia operacional e que SPED/apuracoes e relatorios passem a refletir os dados corrigidos, desde que executados apos a gravacao.

---

## 4) Mapeamento Banco de Dados

### 4.1 Legado - Tabelas e Campos Principais

#### MOVPRO (Movimentação de Produtos)
Campos editáveis/gravados (seleção principal):
- `qtdemov05` (decimal 11,3) - Quantidade movimentada
- `preco05` (decimal 15,6) - Preço unitário
- `vlemb05` (decimal 13,4) - Valor embalagem
- `cst05` (char 3) - CST (origem + CST)
- `bcicms05` (decimal 15,2) - Base cálculo ICMS
- `valicms05` (decimal 15,2) - Valor ICMS
- `aliqicm05` (decimal 5,2) - Alíquota ICMS
- `pbcreduz05` (decimal 5,2) - Percentual redução BC
- `enqipi05` (char 3) - Enquadramento IPI
- `valoripi05` (decimal 15,2) - Valor IPI
- `cstpis05` (char 2) - CST PIS
- `cstcof05` (char 2) - CST COFINS
- `vlsubtri05` (decimal 15,2) - Valor subtribuição ICMS ST
- `aliicmst05` (decimal 5,2) - Alíquota ICMS ST
- `vlretemb05` (decimal 13,4) - ST retido por embalagem
- `cfop` (numeric 5) - CFOP
- `custo05` (decimal 15,4) - Custo do item
- `desconto` (decimal 15,2) - Desconto do item
- `ordem05` (numeric 3) - Ordem do item na nota

#### MOVTRO (Movimentação de Troca)
Estrutura similar a MOVPRO, 40+ campos com nomenclatura sem sufixo "05":
- `qtdemov`, `preco`, `vlemb`, `cst`, `bcicms`, `valicms`, etc.

#### REGENT (Registro de Entrada)
Campos de totais (notação sufixo "81"):
- `transac81` (char 4) - Tipo de transação
- `icmsdeso81` (decimal 15,2) - ICMS desonerado
- `bcst81` (decimal 15,2) - Base ST
- `icmsst81` (decimal 15,2) - Valor ST
- `valoripi81` (decimal 15,2) - Valor IPI
- `valcon81` (decimal 15,2) - Valor da nota
- `valcalc81` (decimal 15,2) - Valor cálculo

#### REGSAI (Registro de Saída)
Campos de totais (notação sufixo "83"):
- `transac83` (char 4) - Tipo de transação
- `bcst83` (decimal 15,2) - Base ST
- `icmsst83` (decimal 15,2) - Valor ST
- `valfrete83` (decimal 15,2) - Valor frete
- `totdesc83` (decimal 15,2) - Total desconto
- `valoripi83` (decimal 15,2) - Valor IPI
- `valcon83` (decimal 15,2) - Valor da nota

### 4.2 Nova - Tabelas Adicionais

#### MOVPRO/MOVTRO (campos IBS/CBS adicionais)
- `cstibscbs` (char 3) - Situação tributária IBS/CBS
- `aliqibs` (decimal 5,2) - Alíquota IBS (UF)
- `aliqibsmun` (decimal 5,2) - Alíquota IBS (Municipal)
- `aliqcbs` (decimal 5,2) - Alíquota CBS
- `valibsuf` (decimal 15,2) - Valor IBS (UF)
- `valibsmun` (decimal 15,2) - Valor IBS (Municipal)
- `valcbs` (decimal 15,2) - Valor CBS
- `prcredibsuf` (decimal 5,2) - % redução IBS UF
- `prcredibsmun` (decimal 5,2) - % redução IBS Municipal
- `prcredcbs` (decimal 5,2) - % redução CBS
- `prdiferao` (decimal 5,2) - % diferimento

#### MOVAUX (Auxiliares - itens com dados complementares)
Usada quando há rastreabilidade, DI, combustíveis ou exportação.

#### MOVBEM (Bens/Imobilizado)
Similar a MOVPRO, mas para ativo imobilizado.

---

## 5) Estrutura de Classes (Novo Módulo)

### 5.1 Classe Principal: SGCorrecaoNota

```
SGCorrecaoNota
  - nFilial                             (integer)
  - nChaveInterna                       (integer)
  - cTipoTerceiro                       (char 1: 'F'=Fornecedor ou 'C'=Cliente)
  - nTerceiro                           (integer)
  - cModelo                             (char 2: '55'=NFe ou '65'=NFCe)
  - cEntradaSaida                       (char 1: 'E'=Entrada ou 'S'=Saída)
  - nNumeroNota                         (integer)
  - cSerie                              (char 3)
  - cEspecie                            (char 1)
  - dEntradaSaida                       (date)
  - dEmissao                            (date)
  - cTransacao                          (char 4: 'PROD', 'CBG', 'COR', etc)
  - cChaveDaNFe                         (char 44)
  - aStatusNFe                          (array of integer: 0-9, 21, 23)
  - lPodeEditarNota                     (boolean)
  - nTotalBC_ICMS                       (decimal 15,2)
  - nTotalValorICMS                     (decimal 15,2)
  - nTotalValor_ICMS_ST                 (decimal 15,2)
  - nTotalValorIPI                      (decimal 15,2)
  - nTotalValorPis                      (decimal 15,2)
  - nTotalValorCofins                   (decimal 15,2)
  - nTotalValorIBSUF                    (decimal 15,2)
  - nTotalValorIBSMun                   (decimal 15,2)
  - nTotalValorCBS                      (decimal 15,2)
  - nTotalFrete                         (decimal 15,2)
  - nTotalSeguro                        (decimal 15,2)
  - nTotalDescontos                     (decimal 15,2)
  - nTotalNota                          (decimal 15,2)
  - aProdutos                           (array de SGCorrecaoProduto)
```

### 5.2 Classe de Produto: SGCorrecaoProduto

```
SGCorrecaoProduto
  - nMovimentacaoRecNo                  (integer, RecNo em MOVPRO/MOVTRO)
  - cTipoMovimentacao                   (char 1: 'T'=MOVTRO ou outro=MOVPRO)
  - oProdutoDetalhes                    (objeto SGCorrecaoProduto_Detalhes)
  - oProdutoICMS_ST                     (objeto SGCorrecaoProduto_ICMS_ST)
  - oProdutoIPI                         (objeto SGCorrecaoProduto_IPI)
  - oProdutoPisCofins                   (objeto SGCorrecaoProduto_PisCofins)
  - oProdutoIBSCBS                      (objeto SGCorrecaoProduto_IBSCBS)
```

### 5.3 Classe de Detalhes: SGCorrecaoProduto_Detalhes

```
SGCorrecaoProduto_Detalhes
  - nCodigo                             (integer, código CADPRO)
  - cDescricao                          (char 40)
  - nOrdem                              (integer, sequência na nota)
  - cNCM                                (char 8)
  - cEXTIPI                             (char 3)
  - nCFOP                               (integer)
  - nQuantidade                         (decimal 11,3)
  - nEmbalagem                          (decimal 9,3)
  - cUnidadeMedida                      (char 2)
  - nPreco                              (decimal 15,6)
  - nFrete                              (decimal 15,2)
  - nSeguro                             (decimal 15,2)
  - nDescontos                          (decimal 15,2)
  - cReceituario                        (char 30)
  - cCPFResponsavel                     (char 11)
  - aDeclaracaoDeImportacao             (array com: cDI, cUF, dData)
  - aGrupoDeExportacao                  (array com: nRegistro, cChaveNFe, nQuantidade)
  - oCombustiveis                       (objeto com: cCodeANP, nPercentualGasNatural, nCIDEAliquota)
  - aRastreabilidade                    (array com: cLote, dValidade, nQuantidade, dFabricacao)
```

### 5.4 Classe ICMS_ST: SGCorrecaoProduto_ICMS_ST

```
SGCorrecaoProduto_ICMS_ST
  - nOrigemCST                          (integer 0-9)
  - cCST                                (char 2)
  - cCSOSN                              (char 3, para Simples Nacional)
  - nBC_ICMS                            (decimal 15,2, base cálculo)
  - nAliquotaICMS                       (decimal 5,2)
  - nPercentualReducao_BC               (decimal 5,2)
  - nValorICMS                          (decimal 15,2)
  - nICMSDesonerado                     (decimal 15,2)
  - nAliquotaFCP                        (decimal 5,2)
  - nValorFCP                           (decimal 15,2)
  - nMVA                                (decimal 7,4, margem valor agregado)
  - nPercentualReducao_BC_ST            (decimal 5,2)
  - nBC_ICMS_ST                         (decimal 15,2)
  - nAliquotaICMS_ST                    (decimal 5,2)
  - nValorICMS_ST                       (decimal 15,2)
  - nAliquotaFCP_ST                     (decimal 5,2)
  - nValorFCP_ST                        (decimal 15,2)
  - nST_RetidoAnteriormente             (decimal 15,2)
```

### 5.5 Classe IPI: SGCorrecaoProduto_IPI

```
SGCorrecaoProduto_IPI
  - nCodigoEnquadramentoLegalIPI        (char 3)
  - cCST_IPI                            (char 2)
  - nBC_IPI                             (decimal 14,2)
  - nAliquotaIPI                        (decimal 5,2)
  - nValorIPI                           (decimal 13,4)
```

### 5.6 Classe PIS/COFINS: SGCorrecaoProduto_PisCofins

```
SGCorrecaoProduto_PisCofins
  - cCST_PIS                            (char 2)
  - cCST_COFINS                         (char 2)
  - nBC_PIS                             (decimal 15,2)
  - nBC_COFINS                          (decimal 15,2)
  - nAliquotaPIS                        (decimal 5,2)
  - nAliquotaCOFINS                     (decimal 5,2)
  - nValorPIS                           (decimal 15,2)
  - nValorCOFINS                        (decimal 15,2)
  - cNaturezaReceita                    (char 3)
```

### 5.7 Classe IBS/CBS: SGCorrecaoProduto_IBSCBS

```
SGCorrecaoProduto_IBSCBS
  - cCodigoSituacaoTributariaIBSCBS     (char 3)
  - cCodigoClassificacaoTributaria      (char 6)
  - nAliquotaIBSUF                      (decimal 5,2)
  - nAliquotaIBSMunicipal               (decimal 5,2)
  - nAliquotaCBS                        (decimal 5,2)
  - nBC_IBSCBS                          (decimal 15,2)
  - nPercentualReducaoIBSUF             (decimal 5,2)
  - nPercentualReducaoIBSMunicipal      (decimal 5,2)
  - nPercentualReducaoCBS               (decimal 5,2)
  - nPercentualDiferimento              (decimal 5,2)
  - nValorIBSUF                         (decimal 15,2)
  - nValorIBSMunicipal                  (decimal 15,2)
  - nValorCBS                           (decimal 15,2)
  - nValorDiferimento                   (decimal 15,2)
```

---

## 6) Sequência de Telas e Navegação

### 6.1 Fluxo Legado

```
1. Seleção de Parâmetros
  - Tipo (Outras, Troca, Imobilizado)
  - Filial
  - E/S (Entrada/Saída)
  - Chave (ou período/número)

2. Carregamento e Validação
  - Valida cancelada/pendente (saída)
  - Valida fechamento fiscal
  - Se bloqueado: rejeita e retorna
  - Se OK: carrega cabecalho + itens

3. Tela Principal (Menu de Opções)
  - [I]nserir item
  - [A]lterar item
  - [E]xcluir item
  - [M]anutenção (transação, IE, frete)
  - [S]air e gravar
  - [C]ancelar

* [I]nserir / [A]lterar / [M]anutencao (cabecalho):
  - Confirmação:
    - Valida tudo
    - Grava MOVPRO...
    - Gera pacote
```

### 6.2 Fluxo Novo

```
1. Seleção de Parâmetros
  - Tipo (Movimentação/Bem)
  - Filial
  - E/S
  - Chave (busca avançada)

2. Carregamento e Validação
  - Valida cancelada/pendente (saída)
  - Valida fechamento fiscal
  - Valida status eletrônico (NFe 9/21/23)
  - Se bloqueado: rejeita
  - Se OK: carrega em SGCorrecaoNota
  -      + array de SGCorrecaoProduto

3. Telas:

3.1. Tela 1:
  - Produto/Serviços(qtd, preço, CFOP, frete, desconto)

3.2. Tela 2:
  - ICMS e St (CST, CSONS, BC, alíquota)

3.3. Tela 3:
  - IPI (Enquad, CST, alíquota)

3.4. Tela 4:
  - PIS/COFINS (CST, BC, aliq)

3.5. Tela 5:
  - IBS/CBS (Situacao Tributaria, aliquota, val)

4. Teclas de atalho (somente quando escolhido nos filtros iniciais 'tipo movimentação' (Outras Notas)'):
  - F4 -> Movimentação
  - F5 -> Transporte
  - F6 -> Status da Nota
  - F7 -> Tipo de Contribuinte
  - F8 -> Edita Receituário
  - F9 -> Edita Guia de Trânsito

5. Confirmação (F3)
  - Valida tudo
  - Grava MOVPRO...
  - Grava MOVTRO...
  - Atualiza REGENT/REGSAI
  - Sem pacote

```

### 6.3 Fluxo de Validações (ambos)

```
Ao carregar nota:
  1. Valida status cancelada (E: não; S: SIM)
  2. Valida status pendente (E: não; S: SIM)
  3. Valida fechamento fiscal (E/S: SIM)
  4. [Novo] Valida status eletrônico NFe (S apenas, modelo 55)
  5. Se OK: continua; Se não OK: erro e retorna

Ao editar item:
  (Depende de validações em tempo real por CST/CSOSN/modelo)
  - Se CST muda: recalcula ST, FCP, etc
  - Se QTD muda: recalcula bases e impostos
  - Se CFOP muda: valida em TABCFO

Ao confirmar:
  - Valida todas as bases (nenhuma negativa)
  - Valida todos os CST/CSOSN
  - Calcula somas finais
  - Se OK: grava; Se não: mostra erro
```

---

## 7) Diferencas principais entre os modulos

- O legado e mais procedural e concentra validacao/gravacao com opcoes por tecla em uma tela principal.
- O novo organiza a edicao por objetos e telas tematicas (Produto, ICMS/ST, IPI, PIS/COFINS, IBS/CBS), com melhor separacao por grupo fiscal.
- O novo adiciona controle explicito de editabilidade por status eletronico da NFe de saida (modelo 55).
- O legado possui caminho explicito de atualizacao de estoque do cadastro (quando habilitado), o que nao aparece de forma direta no fechamento do novo.
