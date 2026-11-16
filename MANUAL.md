# Manual de uso — Smart Report

Guia para quem abre a fila, lê um report e registra a decisão. Os nomes de botões e telas estão em inglês, como no produto.

Todos os candidatos, empregadores, registros e documentos desta demonstração são fictícios.

## O que o report faz

Cada caso chega com um sinal e uma frase que explica o motivo. O report mostra o que o candidato declarou ao lado do que foi verificado. Cada afirmação aponta para o documento de origem e para a regra de SLA que encaminhou o caso.

O produto recomenda. Contratar, recusar e iniciar adverse action continuam com uma pessoa.

Há duas superfícies:

| Onde | Para quê |
| --- | --- |
| `index.html` | Fila, report com citações, SLA, adjudicação, portal do candidato e exportação. Abre no navegador, sem chave. |
| `agent.html` | Análise ao vivo: documentos editáveis, extração com citação literal e chat fundamentado. Precisa da API. |

## Como abrir

Protótipo: abra `index.html` no navegador, ou sirva a pasta com qualquer servidor estático.

Agente ao vivo, na raiz do repositório:

1. Instale a CLI: `npm i -g vercel`
2. Grave a chave no servidor: `vercel env add ANTHROPIC_API_KEY`
3. Rode `vercel dev`
4. Abra `http://localhost:3000` para o protótipo e `http://localhost:3000/agent.html` para o agente

A chave fica só no servidor. O navegador nunca a recebe.

## Cabeçalho

No topo, à direita do nome **Smart Report**, ficam os controles que valem para a tela inteira.

- **Recruiter view** é a fila e o report interno.
- **Candidate view** é o que o candidato vê: status de cada checagem, sem achados nem fontes.
- **Access level** existe só na visão do recrutador. O texto ao lado do seletor diz o que aquele nível libera.
- **SLA criteria** aparece a partir do Level 3 e abre o painel de regras. No protótipo o nível é um seletor de demonstração. Em produção ele viria do usuário autenticado.

## Sinais

A fila ordena os casos pelo sinal. Critical fica no topo.

| Sinal | Significado |
| --- | --- |
| Critical | Há um registro criminal não divulgado, ou outro achado que a matriz manda para revisão humana urgente. |
| Attention | Há discrepância de emprego, educação ou crédito que exige revisão, sem o peso de um registro não divulgado. |
| Routine | As checagens conferem, ou o caso ainda está em andamento sem achado que force revisão. |

Em cada linha, **Why this signal** é a frase do motivo. O progresso (`6/6`) é quantas checagens já terminaram. **Due in** é o prazo.

## Fila do recrutador

A tela **Screening queue** começa com **Live intake**. A cada minuto entra um screening fictício. **Start** e **Stop** ligam e pausam esse fluxo. O relógio mostra o tempo até o próximo.

Os cartões do dashboard filtram a lista. Clique de novo no cartão ativo para voltar a ver todos.

- **Active screenings** — todos
- **Critical signals** / **Attention signals** — pelo sinal
- **Discrepancies flagged** — casos com pelo menos uma discrepância
- **Complete and clear** — concluídos sem pendência

A barra **Screening status** filtra por andamento: **Needs review**, **In progress**, **Complete and clear**.

A busca aceita nome, referência (`SR-…`) ou número do pedido (`ORD-…`). O campo **Date** restringe por data de pedido (**Ordered**), prazo (**Due**), conclusão (**Completed**) ou qualquer uma delas (**Any date**). Se nada aparecer, **Show all** limpa filtro, busca e data.

A caixa à esquerda da linha seleciona o caso para exportar. Ela não abre o report. Clique no restante da linha para abrir.

### Status bot

O rosto no canto superior direito conta os casos que ainda precisam de você: status de revisão ou sinal critical, e que ainda não receberam uma decisão nesta sessão.

- Verde: a fila desses casos está vazia. O tooltip diz **Queue is clear.**
- Laranja: há casos que precisam de você, sem critical em aberto.
- Rosa: há pelo menos um critical.

O número é a quantidade. Clique no bot para ver nome, a próxima ação sugerida e o prazo. Clique num nome para abrir aquele report. Um screening novo faz o bot pulsar por alguns segundos. O bot some na **Candidate view**.

## Ler um report

No topo ficam nome, cargo, pacote, sinal e o banner **Why this case is…**. A grade traz Report ID, order number, datas, checagens concluídas e adjudicação. Os chips **SLA 2.2**, **SLA 4.2** e similares abrem a regra que encaminhou o caso.

Cada seção tem um selo `L2+`, `L3+`, `L4+` ou `L5+`. Esse número é o nível mínimo para ver o detalhe. Abaixo dele, a seção mostra o status e um cadeado. O texto do achado fica oculto. No Level 1 o report inteiro vira só a lista de status.

Dentro de uma seção liberada, cada achado traz:

- **Match** — o declarado e o verificado conferem.
- **Discrepancy** ou **Check** — divergem. Critical em rosa, attention em laranja.
- **Candidate stated** — o que a pessoa escreveu.
- **Smart Report verified** — o que a fonte confirmou.
- Um número ao lado do título — a citação.

Clique no número. O painel lateral abre o documento e marca o trecho. Feche com **✕** ou clicando fora.

**Back to queue** volta à fila.

## Níveis de acesso

O nível vale para a tela, para o chat e para a exportação. Seção bloqueada sai como bloqueada, com o nível exigido, e não como campo em branco.

| Nível | O que abre |
| --- | --- |
| 1 | Resultado geral e status de cada checagem. Sem achados, sem fontes, sem chat. |
| 2 | Identidade, emprego e educação, com fontes. O chat liga. |
| 3 | Busca criminal e o painel **SLA criteria**. |
| 4 | Histórico de crédito, para cargos sensíveis a finanças. |
| 5 | Exame toxicológico e acesso completo às fontes. |

Perguntar no chat sobre algo que está numa seção oculta não revela o conteúdo. A resposta diz que aquele material exige um nível mais alto.

## Perguntar ao report

**Ask this report** aparece a partir do Level 2, acima das seções. As respostas usam só as fontes deste caso, dentro do seu nível. Os chips sugerem perguntas já preparadas para aquele candidato. Você também pode digitar e clicar em **Ask**.

Perguntas úteis: por que o sinal é esse, o que o empregador confirmou, o que a regra de SLA diz, quais checagens bateram, qual é o status.

Se a pergunta for contratar, recusar ou tomar a decisão, a resposta recusa e devolve o caso para você. Números e chips **SLA** dentro da resposta abrem a mesma fonte ou a mesma regra do report.

No protótipo as respostas são roteirizadas para os casos de demonstração. No agente ao vivo elas vêm do modelo, já filtradas pelo nível antes do modelo ver o caso.

## Registrar a decisão

Quando a matriz manda revisão humana, o bloco **Recruiter adjudication** aparece no report.

1. Leia o banner, os achados e as citações.
2. Se o achado pede o lado do candidato, clique em **Request candidate context**. O botão vira **Context requested ✓**.
3. **Start adverse action** só habilita depois desse pedido. A hint explica: fair chance, o contexto vem antes da ação.
4. **Mark eligible** registra que você considerou a pessoa apta. Pode ser usado sem o pedido de contexto.
5. **Undo** desfaz a marca desta sessão. A decisão não volta para um sistema de pedidos neste MVP.

Um caso que a matriz auto-encerra (regra 6.1) não mostra esses botões. A adjudicação aparece como feita pelo Smart Report.

Pedir contexto não muda o sinal. A resposta do candidato, quando existe, fica anexada para você ler. Quem decide continua sendo você.

## Visão do candidato

**Candidate view** esconde nível, SLA e o status bot. A frase no topo deixa explícito: o candidato vê se cada checagem está **Complete** ou **Not complete**. Discrepância, registro e fonte não aparecem.

Os botões com nomes no topo são um seletor de demonstração, para você pré-visualizar cada pessoa. Em produção o candidato veria só o próprio caso.

Se o recrutador já pediu contexto naquele caso, surge o aviso **Your reviewer invited you to add context** e o botão **Share your context**. Depois do envio, a tela confirma que o texto foi anexado ao report do revisor. O rodapé lembra o direito a cópia e a contestação. Este protótipo não abre um fluxo real de disputa.

## Exportar

Na fila:

- Marque um ou mais casos. **Excel (n)** baixa `smart-report-status.xlsx` com nome, cargo, local, IDs, sinal, status, adjudicação, prazo e checagens. Sem seleção, o botão Excel fica desligado.
- **Export ZIP (all)** junta um PDF por caso da fila inteira. Com casos marcados, o ZIP leva só os marcados (`smart-report-reports.zip`).

Dentro do report:

- **PDF** baixa o report da pessoa no nível atual. Seção bloqueada entra como bloqueada.
- **Print** abre a impressão do navegador. Se a impressão não estiver disponível, o botão copia um resumo em texto.

O arquivo leva a linha do nível de acesso usado na exportação.

## Regras de SLA

**SLA criteria** (Level 3 ou mais) abre a matriz do cliente, somente leitura. A regra que disparou naquele caso fica destacada quando você chega por um chip **SLA**.

| Regra | Quando dispara | Encaminhamento |
| --- | --- | --- |
| 1.1 | Identidade confere | Automático |
| 2.1 | Emprego dentro da janela (título e datas, até 3 meses) | Automático |
| 2.2 | Data de emprego com mais de 3 meses de diferença, ou título divergente | Revisão, attention |
| 3.1 | Diploma conferido até 6 meses da data declarada | Automático |
| 3.2 | Formatura com mais de 6 meses de diferença, ou instituição divergente | Revisão, attention |
| 4.1 | Sem registros criminais | Automático |
| 4.2 | Registro que o candidato não divulgou. Avaliação individual antes de qualquer adverse action | Revisão, critical |
| 5.1 | Cobrança em aberto acima de US$ 5.000 em cargo sensível a finanças | Revisão, attention |
| 6.1 | Todas as seções acima liberadas | Automático, routine |

Critical prevalece sobre attention, que prevalece sobre routine. A regra 4.2 não recusa o caso sozinha. Ela obriga revisão humana.

## Um caminho curto no protótipo

1. Fique em **Recruiter view**, Level 3.
2. Abra Jordan Avery (`SR-2026-1187`), o caso critical no topo.
3. Clique na citação do registro de Cook County e leia o trecho marcado.
4. Clique em **SLA 4.2** e leia a regra.
5. Mude para Level 2 e veja a seção criminal travar. O chat, se perguntar do registro, também trava.
6. Volte ao Level 3, clique em **Request candidate context** e só então **Start adverse action** fica disponível. Use **Undo** se quiser limpar a marca.
7. Troque para **Candidate view**, escolha a mesma pessoa e, se o contexto foi pedido, use **Share your context**.

## Agente ao vivo

Em `agent.html` os documentos de Jordan Avery são editáveis. **Run analysis** envia o caso: o modelo extrai achados com trechos literais, o código descarta citação que não existe no documento nomeado, e a matriz de SLA define sinal e regras. O banner informa quantos achados foram descartados.

**Access level** nessa página filtra só o chat. Rode a análise antes de perguntar. **Ask this report** aparece depois do resultado.

Para ver a matriz reagir:

- Apague o documento do tribunal, ou mude a acusação de um jeito que o achado criminal suma: o sinal deixa de ser critical e a regra 4.2 sai da lista.
- Alinhe as datas de Meridian na candidatura com a verificação de RH: a discrepância de emprego some.
- Pergunte por que o caso precisa de revisão no Level 3 e de novo no Level 2: a resposta criminal trava no nível mais baixo.
- Pergunte se deve contratar: a resposta recusa.

## O que este report não faz

- Não recomenda contratar, recusar ou adverse action.
- Não altera o sinal porque o candidato respondeu ao convite.
- Não grava a adjudicação num sistema de pedidos.
- Não coleta consentimento real nem abre disputa.
- Não usa dado de produção. Os casos da demonstração são inventados.
