# Conformidade com a LGPD — fichart-api

> Documento de conformidade com a **Lei 13.709/2018 (LGPD)** para o backend do fichart.
> Escrito no porte real do projeto: trabalho de faculdade que pode virar produto pago.
>
> **Base analisada:** `prisma/schema.prisma` (8 modelos), `src/app.ts`, `src/server.ts`,
> `docs/Guia-Fichart-API.md` — estado de 24/08/2026, fim da Etapa 5.
> **Última atualização:** 25/08/2026.

---

## 0. Como ler este documento

Cada obrigação tem uma etiqueta de **quando**:

| Etiqueta | Significado |
|---|---|
| 🔴 **AGORA** | Vale mesmo no ambiente acadêmico, ou é barato agora e caro depois |
| 🟡 **ANTES DE IR AO AR** | Passa a ser exigível no dia em que existir um usuário real ou uma cobrança |
| 🔵 **QUANDO O RECURSO EXISTIR** | Depende de funcionalidade ainda não construída (Campaign, publicação pública, NF-e) |

E cada item do checklist técnico tem um estado:

| Marca | Significado |
|---|---|
| ✅ | Já existe no repositório |
| ⚠️ | Existe parcialmente, ou existe de um jeito que precisa de ajuste |
| ❌ | Não existe |

**A regra que resume o documento inteiro:** a LGPD não pede que você colete pouco *dado*, pede
que você tenha uma **finalidade declarada** para cada dado, uma **base legal** que sustente a
finalidade, um **prazo** para descartar, e a **capacidade técnica** de responder ao titular
dentro de 15 dias. O fichart já acerta a parte mais difícil por acaso: ele coleta quase nada.

---

## 1. Escopo, papéis e enquadramento

### 1.1 Quem é quem

| Papel | Quem é | Fundamento |
|---|---|---|
| **Controlador** | Quem opera o fichart e decide as finalidades. Hoje: Casemiro (pessoa natural). No ar: a PJ que faturar a assinatura | art. 5º, VI |
| **Operadores** | Hospedagem da API e do banco, gateway de pagamento, provedor de e-mail transacional, provedor de observabilidade/logs | art. 5º, VII |
| **Titulares** | Usuários cadastrados; futuramente também mestres e jogadores em campanhas | art. 5º, V |
| **Encarregado (DPO)** | Ver §1.3 | art. 5º, VIII; art. 41 |

> ⚠️ **O gateway de pagamento tem papel duplo.** Ele é **operador** ao processar a cobrança que
> você determinou, e **controlador autônomo** sobre o dado de cartão e sobre o antifraude dele.
> Confira isso no DPA do gateway antes de assinar — muda quem responde por um vazamento de cartão.
> Como o fichart **não guarda dado de cartão**, essa fronteira já está do lado certo por desenho.

### 1.2 Agente de tratamento de pequeno porte

A **Resolução CD/ANPD nº 2/2022** cria um regime simplificado para microempresas, empresas de
pequeno porte, startups e pessoas naturais que tratam dados como controlador — **desde que não
realizem tratamento de alto risco**.

Alto risco exige **um critério geral** (larga escala **ou** potencial de afetar significativamente
interesses e direitos fundamentais) **somado a um critério específico** (entre eles: dados de
crianças, adolescentes e idosos; decisões automatizadas com efeito jurídico; dados sensíveis;
vigilância de área pública).

**Enquadramento do fichart hoje:** pequeno porte. Trata dado de adolescente potencialmente
(critério específico), mas não em larga escala nem com potencial de afetação significativa
(nenhum critério geral). **Não é alto risco.**

> 🔵 **Reavalie se o produto crescer.** O regime simplificado se perde no dia em que "larga escala"
> passar a ser verdade e a base de usuários for majoritariamente adolescente. Isso reintroduz
> a obrigação de encarregado formal, registro completo e, provavelmente, RIPD.

O que o regime simplificado dispensa (e o que **não** dispensa):

| Dispensa | Continua obrigatório |
|---|---|
| Indicação formal de encarregado | Canal de comunicação com o titular, público e funcional |
| Registro de operações em formato completo | Registro simplificado das operações (§13 deste documento) |
| Política de segurança extensa | Medidas de segurança do art. 46 |
| — | Bases legais, direitos do titular, comunicação de incidente |

### 1.3 Canal do titular

🔴 **AGORA (é uma linha de texto, não custa nada).** Publique um endereço único e permanente:
`privacidade@fichart.<dominio>`. Ele precisa existir na Política de Privacidade, nos Termos e
dentro da aplicação. Enquanto o projeto for acadêmico, pode ser um alias do e-mail pessoal — o
que não pode é o titular não ter para onde escrever.

🟡 **NO AR:** nomeie o encarregado no site (mesmo dispensado, indicar é sinal de maturidade e
custa uma linha), e defina o SLA interno de 15 dias corridos.

---

## 2. Inventário do que o sistema trata hoje

Levantado direto do schema. Esta tabela é a matéria-prima das duas tabelas seguintes.

| Tabela | Campo | É dado pessoal? | Observação |
|---|---|---|---|
| `users` | `name` | Sim | Deveria ser **nome de exibição**, não nome civil. Ver §5.2 |
| `users` | `email` | Sim — identificador direto | `@unique`; ocupa o índice mesmo após soft delete (intencional) |
| `users` | `password_hash` | Sim — **dado de autenticação** | Vazamento aqui é incidente de risco relevante por definição. Ver §8.2 |
| `users` | `premium_until` | Sim, por associação | Revela status contratual |
| `users` | `deleted_at` / `created_at` / `updated_at` | Sim, por associação | Metadado de ciclo de vida |
| `payments` | `external_payment` | Sim, por associação | Referência do gateway. **Não é dado de cartão** — correto |
| `payments` | `amount_cents`, `currency`, `status`, `paid_at` | Sim, por associação | Dado financeiro/transacional |
| `characters` | `name`, atributos, FKs de raça/classe/antecedente | Sim, por associação | Conteúdo do titular. **Não é dado sensível** — ver §2.1 |
| `races`, `subraces`, `character_classes`, `backgrounds`, `languages` | todos | **Não** | Catálogo do SRD. Fora da LGPD |
| Logs do Fastify | `remoteAddress` (IP), rota, método | Sim — IP é dado pessoal | Hoje capturado por padrão sem política. Ver §7.6 |

### 2.1 "Raça" de personagem não é dado sensível — e isso precisa estar escrito

O art. 11 define dado sensível como aquele sobre **origem racial ou étnica** *da pessoa natural*,
convicção religiosa, opinião política, filiação sindical, saúde, vida sexual, genética ou biometria.

`Character.raceId = "Elfo"` é atributo de uma **personagem de ficção**, não da pessoa. O mesmo vale
para classe, antecedente e alinhamento. **Nada no fichart hoje é dado sensível**, e isso derruba
todo o regime mais rígido do art. 11 (consentimento específico e destacado, bases legais estreitas).

Registre essa conclusão por escrito, porque a leitura ingênua do schema — uma coluna chamada
`race_id` numa tabela ligada a `users` — assusta quem faz auditoria rápida.

> 🔵 **O que muda essa conclusão:** um campo de **texto livre** (história do personagem, notas da
> campanha, bio do jogador). Aí o titular pode escrever religião, orientação sexual ou condição de
> saúde por conta própria. Não vira automaticamente tratamento de dado sensível pelo controlador,
> mas cria dado sensível **em repouso** no seu banco. Mitigação proporcional: proibir nos Termos,
> não indexar, não usar esse campo para segmentar, classificar ou treinar nada.

---

## 3. Bases legais (art. 7º)

O erro mais caro em projeto pequeno é **usar consentimento para tudo**. Consentimento é revogável
a qualquer momento (art. 8º, §5). Se o cadastro depende de consentimento, o titular revoga e você
é obrigado a parar de prestar o serviço que ele contratou. **Execução de contrato (art. 7º, V) é a
base certa para tudo que é o serviço em si.** Consentimento fica reservado para o que é *extra*.

| # | Tratamento | Dados | Base legal | Por que essa e não outra |
|---|---|---|---|---|
| 1 | **Cadastro e manutenção da conta** | `name`, `email`, `password_hash`, timestamps | **art. 7º, V** — execução de contrato | Os Termos de Uso são o contrato; a conta é indispensável para prestá-lo. Consentimento aqui seria autossabotagem |
| 2 | **Autenticação e sessão** | `password_hash`, tokens, `credentials_valid_from` | **art. 7º, V** + dever do **art. 46** | Não é finalidade separada: é a execução do contrato feita com segurança |
| 3 | **Verificação de e-mail** | `email`, token, `email_verified_at` | **art. 7º, V** (o e-mail é o canal do contrato) + **IX** (antiabuso) | Garante que o titular é quem diz ser antes de vincular conteúdo à conta |
| 4 | **Guarda das fichas de personagem** | `characters.*` | **art. 7º, V** | Guardar a ficha **é** o objeto do contrato. Pedir consentimento para o núcleo do serviço é ruído |
| 5 | **Cobrança da assinatura premium** | `user_id`, `external_payment`, `amount_cents`, `status`, `paid_at` | **art. 7º, V** | Cobrar é execução do contrato oneroso |
| 6 | **Guarda fiscal e contábil do pagamento** | os mesmos, após o fim do contrato | **art. 7º, II** (obrigação legal) + **art. 16, I** | Prazo próprio, independente da vontade do titular. Ver §6.3 |
| 7 | **Prevenção a fraude e abuso** | tentativas de login, IP, rate limit | **art. 7º, IX** — legítimo interesse | Passa no teste do art. 10: finalidade legítima, dados mínimos, expectativa razoável do titular, salvaguardas |
| 8 | **Registros de acesso à aplicação** | IP, timestamp, rota, `user_id` | **art. 7º, II** — Marco Civil, art. 15 | Obrigação legal autônoma. Sobrevive ao pedido de exclusão. Ver §6.4 |
| 9 | **Comunicações transacionais** (recuperação de senha, aviso de expiração do premium, aviso de mudança nos Termos) | `email`, `name` | **art. 7º, V** | Não é marketing. Não precisa de opt-in e **não deve ter link de descadastro** |
| 10 | **Comunicações de marketing** (novidades, newsletter) | `email`, `name` | **art. 7º, I** — consentimento | Checkbox **separado**, **nunca pré-marcado**, **nunca embutido** no aceite dos Termos (art. 8º, §4 anula autorização genérica) |
| 11 | **Métricas de produto** | contagens agregadas, sem identificação | **fora da LGPD** se de fato anonimizado (art. 12) | Ver a armadilha em §5.4 |
| 12 | **Defesa em processo judicial ou administrativo** | o que for pertinente | **art. 7º, VI** | Base de contingência. Não justifica retenção preventiva genérica |
| 13 | 🔵 **Campanhas — mestre vê jogadores** | `name` de exibição, vínculo `CampaignMember` | **art. 7º, V** | Ver §3.1 |
| 14 | 🔵 **Publicação pública de ficha ou item** (`visibility = PUBLIC`) | conteúdo + autoria | **art. 7º, I** — consentimento | Expõe a terceiros indeterminados. Precisa ser ato afirmativo, granular e reversível |
| 15 | 🔵 **Emissão de nota fiscal** | CPF/CNPJ, razão social | **art. 7º, II** | Categoria de dado **nova**, ainda inexistente no schema. Ver §3.2 |

### 3.1 Campanhas: o dado que é de duas pessoas ao mesmo tempo

`Campaign` + `CampaignMember(role GM|PLAYER)` cria a primeira situação em que **um titular vê dado
de outro**. Três regras a implantar junto com o recurso:

1. **Exponha nome de exibição, nunca e-mail.** O e-mail é identificador direto e chave de conta.
   O mestre não precisa dele para rodar a mesa.
2. **Convite é por e-mail digitado, não por busca.** Não crie endpoint que confirme se um e-mail
   existe na base — isso é um oráculo de enumeração servido em bandeja. Convite gera um token
   opaco enviado ao endereço; a resposta da API é sempre a mesma tenha o e-mail conta ou não.
3. **O mestre não tem veto sobre a exclusão do jogador.** Quando o jogador pede eliminação, ele
   sai. Se a história da campanha precisar de continuidade, o vínculo vira "jogador removido"
   com identificadores destruídos — não se preserva o titular para conforto de terceiro.

### 3.2 O CPF que ainda não existe

Hoje o fichart não coleta CPF, e a nota fiscal (se houver) sai pelo gateway ou pela contabilidade.
**Mantenha assim o máximo de tempo possível.** No dia em que o fichart emitir NF por conta própria,
entra uma categoria de dado de risco alto de fraude, com dever de proteção maior — cifra em
coluna, log de acesso a esse campo, e um item novo na tabela de retenção. Não antecipe isso.

---

## 4. Menores de idade (art. 14) — exposição real e resposta proporcional

### 4.1 O que a lei realmente diz

Comece separando dois grupos, porque a lei os trata de forma diferente:

- **Criança** — até 12 anos incompletos (ECA, art. 2º)
- **Adolescente** — de 12 a 18 anos incompletos

| Dispositivo | Alcance | Exigência |
|---|---|---|
| art. 14, **caput** | crianças **e** adolescentes | Tratamento **no melhor interesse** do menor |
| art. 14, **§1º** | **apenas crianças** | Consentimento **específico e em destaque** de ao menos um dos pais ou responsável |
| art. 14, **§2º** | crianças | Manter **pública** a informação sobre dados coletados, uso e exercício de direitos |
| art. 14, **§4º** | crianças | **Não condicionar** participação em **jogos e aplicações de internet** ao fornecimento de dados além dos estritamente necessários |
| art. 14, **§5º** | crianças | **Esforços razoáveis** para verificar o consentimento do responsável, "consideradas as tecnologias disponíveis" |
| art. 14, **§6º** | ambos | Linguagem **simples, clara e acessível** |

Dois pontos que costumam ser lidos errado:

**O §1º não é a única base legal possível.** Houve leitura inicial de que dado de criança só se
trata com consentimento parental. O entendimento que se consolidou na doutrina e nos estudos da
ANPD é que as demais bases do art. 7º permanecem disponíveis, desde que o **melhor interesse** do
menor governe a decisão. Na prática isso importa: você não precisa de consentimento parental para
o `password_hash` de um adolescente de 15 anos — a base é execução de contrato.

**Adolescente não exige consentimento parental pela LGPD.** Exige melhor interesse. O que exige
representação ou assistência do responsável para o adolescente é o **Código Civil**, e por outro
motivo: capacidade civil para contratar. Menor de 16 é absolutamente incapaz; entre 16 e 18 é
relativamente incapaz e precisa de assistência. **Isso atinge a assinatura premium, não o cadastro
gratuito.**

### 4.2 A exposição real do fichart

Baixa, e por três razões concretas:

1. O fichart **não coleta data de nascimento**. Sem esse campo, não há tratamento de dado que
   revele idade. Você não sabe — e não precisa saber.
2. O fichart **não faz perfilamento, não veicula publicidade, não recomenda nada** com base em
   comportamento. Quase todo o dano regulatório associado a menores no mundo vem daí.
3. O conjunto coletado — nome de exibição e e-mail — é o mínimo aritmético para existir uma conta.
   O **§4º**, que é a regra mais dura do artigo para um produto de jogo, já está satisfeito por
   desenho: não há um único campo cuja ausência impeça o uso e cuja presença seja dispensável.

### 4.3 O que fazer na prática

| Medida | Veredito | Justificativa |
|---|---|---|
| **Coletar data de nascimento** | 🔴 **NÃO FAÇA** | Coletar idade para "proteger menores" cria exatamente o dado que você queria não ter, em toda a base, para tratar um risco que a arquitetura já mitiga. É o contrário da minimização (art. 6º, III) |
| **Idade mínima nos Termos: 13 anos** | ✅ **Faça** | Alinha com a prática internacional, é honesto sobre o público real de D&D, e é executável |
| **Declaração de idade no cadastro** | ✅ **Faça** | Caixa não pré-marcada: *"Declaro ter 13 anos ou mais e, se tenho menos de 18, que meus pais ou responsáveis conhecem e autorizam meu uso do fichart."* Grave **timestamp, versão do texto e IP** — não a idade |
| **Consentimento parental verificado** | ❌ **Não é exigível aqui** | O §1º alcança **crianças**; abaixo de 13 o cadastro está vedado pelos Termos. Exigir verificação parental de adolescente é obrigação que a lei não impõe — e verificação séria custa coleta de documento do responsável, que é *mais* dado pessoal, de *mais* uma pessoa |
| **Bloquear premium para menor de 18** | 🟡 **Sim, no ar** | Não é LGPD, é Código Civil. Nos Termos: contratação do plano pago exige 18 anos ou responsável contratando. Na prática o gateway já é a barreira (cartão/Pix de titular capaz) |
| **Canal de remoção pelo responsável** | 🔴 **Faça (é uma frase)** | Na Política: *"Se você é pai, mãe ou responsável e identificou conta de menor de 13 anos, escreva para privacidade@… e a conta será encerrada e os dados eliminados."* Esta frase é o "esforço razoável" (§5º) proporcional a este porte |
| **Publicidade e perfilamento para menores** | 🔴 **Proibido por política interna** | Escreva a vedação agora, antes de existir tentação comercial |
| **Linguagem simples na Política** | 🟡 **Sim** | §6º. Um resumo de 10 linhas no topo do documento resolve |

> **O raciocínio de proporcionalidade, em uma frase:** o §5º pede esforços razoáveis
> *"consideradas as tecnologias disponíveis"* — para um app de ficha de RPG sem publicidade,
> sem perfilamento e sem dado sensível, a barreira contratual somada ao canal de remoção é o
> esforço razoável. Verificação documental de responsável seria desproporcional ao risco e
> aumentaria o dano potencial de um vazamento.

> 🔵 **Um gatilho para revisitar:** se o produto vier a ter chat de mesa, perfil público ou
> qualquer superfície social entre usuários, o risco muda de patamar e um RIPD simplificado
> (art. 38) passa a ser prudente.

---

## 5. Direitos do titular (art. 18) — o que cada um exige deste código

**Prazo.** O art. 19, II fixa **15 dias** para a declaração clara e completa de acesso; o art. 19, I
manda entregar a versão simplificada **imediatamente**. Para os demais direitos a lei não fixa prazo.
**Adote 15 dias corridos como SLA único** — é defensável, é simples de operar e evita discussão.
Se não der para atender, o art. 18, §4 exige resposta **justificando** de fato ou de direito.

| Direito (art. 18) | Exigência técnica no fichart | Estado |
|---|---|---|
| **I — Confirmação da existência** | `GET /v1/me` autenticado responde imediatamente. Fora da conta, o pedido vai pelo canal do titular e **não pode virar oráculo de enumeração**: a resposta a "existe conta com este e-mail?" só vai para o e-mail, nunca para quem perguntou | ❌ |
| **II — Acesso** | `GET /v1/me` (simplificado, imediato) + `POST /v1/me/exports` (cópia integral, art. 19, §3). Uma coisa não substitui a outra | ❌ |
| **III — Correção** | `PATCH /v1/me` para `name` e `email`. Troca de e-mail exige confirmação no endereço novo **e** aviso no antigo (senão vira sequestro de conta). Dado de catálogo do SRD não é corrigível pelo titular — não é dado dele | ❌ |
| **IV — Anonimização, bloqueio ou eliminação de dado desnecessário, excessivo ou irregular** | Precisa de rotina de **anonimização** (§5.4) e de **bloqueio** — estado em que o registro existe, não é usado por nenhuma funcionalidade e só serve à finalidade legal que o sustenta. Ver §6.5 | ❌ |
| **V — Portabilidade** | Rota de exportação em formato interoperável. Ver §5.1 | ❌ |
| **VI — Eliminação** | Fluxo **separado** do encerramento de conta. Este é o ponto mais importante do documento inteiro — ver §6.2 | ⚠️ |
| **VII — Informação sobre uso compartilhado** | Lista de operadores e finalidades, **mantida atualizada na Política**. É documental, não código | ❌ |
| **VIII — Informação sobre não consentir e as consequências** | Texto ao lado de cada checkbox opcional: *"Se você não marcar, nada muda no seu uso do fichart — você só não recebe os e-mails de novidades."* | ❌ |
| **IX — Revogação do consentimento** | Só se aplica ao que for tratado com consentimento (marketing, publicação pública). Revogação **imediata**, no mesmo lugar onde foi dada, sem fricção. Preserva-se o **registro** da revogação | ❌ |

### 5.1 Portabilidade — o formato

O art. 18, V remete à regulamentação da ANPD, que **ainda não editou regra geral de portabilidade**
fora de setores específicos como o Open Finance. O padrão exigível hoje vem do art. 19, §3: formato
que **permita utilização subsequente**, isto é, estruturado, interoperável e legível por máquina.

**Formato: JSON, UTF-8, um arquivo, esquema versionado.**

Justificativa: é o formato nativo da API, não perde estrutura aninhada (personagem → idiomas),
é legível por humano e por máquina, e não sofre com a ambiguidade de separador e codificação que
o CSV tem em português. Ofereça CSV apenas como conveniência adicional para a lista de personagens.

**A regra que decide se sua exportação presta:** ela precisa ser útil **em outro produto**. Isso
significa **resolver as chaves estrangeiras para nomes**. Um arquivo com `"raceId":
"0198f2c1-..."` não é portabilidade, é despejo de banco.

```jsonc
{
  "schemaVersion": "1.0",
  "generatedAt": "2026-08-25T14:03:11.284Z",
  "controller": { "name": "fichart", "contact": "privacidade@fichart.app" },
  "account": {
    "displayName": "Casemiro",
    "email": "casemiro@exemplo.com",
    "createdAt": "2026-03-02T11:20:00.000Z",
    "premiumUntil": "2027-03-02T00:00:00.000Z",
    "emailVerifiedAt": "2026-03-02T11:24:41.000Z"
  },
  "characters": [
    {
      "name": "Thaliondir",
      "level": 3,
      "abilityScores": { "strength": 10, "dexterity": 16, "constitution": 12,
                         "intelligence": 14, "wisdom": 11, "charisma": 8 },
      "race": "Elf",                  // nome resolvido, não o UUID
      "subrace": "High Elf",
      "characterClass": "Wizard",
      "background": "Acolyte",
      "languages": ["Common", "Elvish"],
      "createdAt": "2026-03-02T11:31:09.000Z",
      "updatedAt": "2026-07-18T20:02:55.000Z"
    }
  ],
  "payments": [
    { "externalReference": "pay_3RtZ...", "amountCents": 1990, "currency": "BRL",
      "status": "PAID", "paidAt": "2026-03-02T11:40:12.000Z" }
  ],
  "consents": [
    { "purpose": "MARKETING_EMAIL", "grantedAt": "2026-03-02T11:20:00.000Z",
      "revokedAt": "2026-05-10T08:15:00.000Z" }
  ],
  "legalAcceptances": [
    { "document": "TERMS_OF_USE", "version": "2026-02-01", "acceptedAt": "2026-03-02T11:20:00.000Z" }
  ]
}
```

**O que entra:** o que o titular forneceu e o que a atividade dele gerou.
**O que não entra:**
- `passwordHash` — **nunca**. Não serve ao titular e transforma o arquivo numa arma se vazar.
- Catálogo do SRD em bloco — não é dado pessoal, e o nome resolvido já dá interoperabilidade.
- Registros de acesso (Marco Civil) — são obrigação legal do controlador, não conteúdo do titular.
  Se o titular pedir esses registros pelo direito de **acesso**, entregue à parte, sob análise.

**Como entregar, sem transformar o direito num vetor de ataque:**

| Cuidado | Implementação |
|---|---|
| Reautenticação | Exigir a senha atual na requisição, mesmo com sessão válida |
| Processamento assíncrono | `POST /v1/me/exports` → `202` + id do job; `GET /v1/me/exports/:id` → estado e link |
| Link efêmero | URL assinada, validade curta (15 min), uso único |
| Nunca por anexo de e-mail | E-mail leva o **aviso**; o arquivo fica atrás de autenticação |
| Limite de frequência | 1 exportação por conta a cada 24 h |
| Arquivo descartável | Apagar o arquivo gerado em até 7 dias |
| Registro | Gravar o pedido em `data_subject_requests` — é sua prova de atendimento |

### 5.2 Minimização começa no rótulo do campo

`users.name` hoje não diz se é nome civil ou apelido. **Rotule na interface como "nome de exibição"
e diga na Política que não é preciso usar o nome real.** Custa zero, reduz o dano de um vazamento,
e é literalmente o princípio da necessidade (art. 6º, III) aplicado com uma string de UI.

### 5.3 Enumeração de usuários é um problema de conformidade, não só de segurança

O fluxo desenhado na Etapa 9 do guia responde **409 Conflito** quando o e-mail já tem conta ativa.
Isso confirma a terceiros a existência de um titular — é vazamento de dado pessoal por design.

Duas saídas honestas:

- **Preferida:** o cadastro **sempre** responde `202` com a mesma mensagem ("se este endereço puder
  ser cadastrado, você receberá um e-mail"). A bifurcação (criar conta / avisar que já existe /
  oferecer reativação) acontece **dentro do e-mail**, que só o dono do endereço lê.
- **Aceitável, se documentada:** manter o `409` pela usabilidade, e compensar com rate limit
  agressivo por IP e por e-mail, CAPTCHA após N tentativas, e o registro dessa decisão aqui.

Em qualquer das duas: **hash da senha mesmo quando o usuário não existe**, com parâmetros idênticos,
para o tempo de resposta não denunciar a existência da conta.

### 5.4 Anonimização de verdade — e a armadilha do hash

O art. 12 tira o dado anonimizado do alcance da LGPD, **desde que a reversão não seja possível por
meios razoáveis**. Daí a regra prática mais violada do assunto:

> **Hash de e-mail não é anonimização.** É pseudonimização. O espaço de e-mails é enumerável;
> quem tem a lista e o algoritmo reverte por força bruta em minutos. Dado pseudonimizado continua
> sendo dado pessoal, continua precisando de base legal e continua entrando na tabela de retenção.

Anonimizar de verdade, neste sistema, é **destruir** o identificador — não transformá-lo:

| Campo | Anonimização correta |
|---|---|
| `users.name` | `'Titular removido'` (literal fixo, igual para todos) |
| `users.email` | `NULL` — exige tornar a coluna `String?`. Postgres aceita múltiplos `NULL` num índice único, então a `@unique` continua válida |
| `users.password_hash` | Destruir. Conta anonimizada não volta |
| `characters` | Excluir de fato. É conteúdo do titular, não tem prazo legal próprio |
| `access_logs.ip_address` | Truncar (`/24` em IPv4, `/48` em IPv6) quando expirar o prazo do Marco Civil, se houver interesse em manter contagem |

E o teste que fecha a questão: **se existe um caminho de volta ao titular, não é anonimização.**
Se você guardou o hash do e-mail "só para não deixar reabrir a conta", isso é pseudonimização com
finalidade de antiabuso — base legal art. 7º, IX, prazo próprio, declarado na Política.

---

## 6. Retenção e eliminação

### 6.1 O erro conceitual que a política de 6 semanas contém hoje

O comentário no schema diz, corretamente, que a conta não some no primeiro clique e que há uma
janela de recuperação. O problema é que **um único fluxo está fazendo o trabalho de dois eventos
juridicamente distintos**:

| Evento | O que é | Quem manda no prazo |
|---|---|---|
| **Encerramento de conta** | O titular resolve parar de usar. Rescisão contratual | **Você**, desde que declarado nos Termos. 6 semanas é razoável e defensável |
| **Pedido de eliminação (art. 18)** | O titular exerce um direito legal | **Ele.** Você não segura o dado dele por 6 semanas "por precaução" |

Procurar no art. 16 qual inciso autorizaria segurar por 6 semanas contra a vontade do titular
mostra que **nenhum autoriza**: não é obrigação legal (I), não é pesquisa (II), não é transferência
a terceiro (III), e o inciso IV — uso exclusivo do controlador — **exige que o dado esteja
anonimizado**, o que destruiria justamente a possibilidade de reativação que motiva a janela.

**Conclusão: a política de 6 semanas é defensável — como cláusula contratual de encerramento
voluntário. Não é oponível a um pedido de eliminação.**

### 6.2 O desenho correto: três estados, não um

```
             encerrar conta                 fim das 6 semanas
   ATIVA  ──────────────────►  DESATIVADA  ──────────────────►  ELIMINADA
     ▲                              │                                ▲
     └────── reativar ◄─────────────┘                                │
                                                                     │
   ATIVA ──────────── pedido de eliminação (art. 18) ────────────────┘
                          (até 15 dias, sem janela de graça)
```

Três campos em `User` sustentam isso — hoje existe apenas o primeiro:

| Campo | Semântica | Estado |
|---|---|---|
| `deletedAt` | Conta desativada pelo titular. Reativável dentro da janela | ✅ |
| `erasureRequestedAt` | Direito do art. 18 exercido. **Bloqueia a reativação** e dispara a rotina de eliminação | ❌ |
| `anonymizedAt` | Identificadores destruídos. A linha só sobrevive para ancorar registro fiscal | ❌ |

### 6.3 Por que a conta paga não pode ser `DELETE`

Este é o achado de engenharia com consequência jurídica direta, e ele **impede a implementação
literal da política atual**:

`payments.user_id` é `String` **obrigatório**, sem `onDelete`. O padrão do Postgres é `NO ACTION`.
Logo, `DELETE FROM users` em quem já pagou **falha por violação de chave estrangeira** — e não
adianta contornar apagando o pagamento junto, porque o registro fiscal tem **prazo legal próprio de
5 anos**, superior e independente das 6 semanas.

**A eliminação definitiva de um titular que pagou é anonimização do `User`, não `DELETE`:**

```
1. DELETE nos characters (e nas linhas da junção com languages)
2. UPDATE users SET name = 'Titular removido',
                    email = NULL,
                    password_hash = '',
                    anonymized_at = now()
3. payments permanece, íntegro e BLOQUEADO, até o fim do prazo fiscal
4. Expirado o prazo fiscal: DELETE nos payments e só então DELETE no users
```

Titular que **nunca pagou** não tem essa amarra: `DELETE` de verdade, e o e-mail volta a ficar
livre no índice único.

> ⚠️ **Consequência para o schema:** `email` precisa virar `String?`. Toda a camada de autenticação
> tem de assumir que existe `User` sem e-mail — e esse usuário **jamais** autentica, jamais reativa
> e jamais aparece em busca. Decidir isso agora custa uma migration; decidir depois custa refatorar
> autenticação em produção.

### 6.4 O prazo que sobrevive ao pedido de exclusão

Duas categorias continuam existindo depois que o titular pede eliminação, e **isso é legal e precisa
estar na Política**:

**Registro fiscal do pagamento — 5 anos.** Base: art. 7º, II e art. 16, I. Prazos que sustentam:
CTN arts. 173 e 174 (decadência e prescrição tributária), Código Civil art. 206, §5º, I (cobrança de
dívida líquida), CDC art. 27 (reparação por fato do serviço). Todos convergem em **5 anos** —
contados do encerramento do exercício em que ocorreu a operação, que é o critério prático da guarda
fiscal.

**Registros de acesso à aplicação — 6 meses.** Base: Marco Civil da Internet (Lei 12.965/2014),
art. 15: o provedor de aplicações de internet constituído como pessoa jurídica com fins econômicos
**deve** guardar os registros de acesso a aplicações por 6 meses, sob sigilo. É obrigação autônoma;
o titular não pode dispensá-la. O §2º ainda permite que autoridade determine preservação por prazo
maior.

> Note a assimetria: enquanto o projeto **não** for PJ com fins econômicos, o art. 15 **não obriga**.
> Mas manter os registros continua sendo boa medida de segurança (base art. 7º, IX) — e é o único
> jeito de responder "quais titulares foram afetados" num incidente (art. 48, §1º, II).

### 6.5 Bloqueio ≠ retenção

Manter dado por obrigação legal **não** autoriza continuar usando o dado. Depois do pedido de
eliminação, o registro fiscal entra em **bloqueio** (art. 18, IV): sai de qualquer consulta de
produto, sai de relatório, sai de métrica, sai de suporte. Só a finalidade fiscal o alcança.

Implementação: filtro no repositório (mesmo lugar onde já mora o filtro de soft delete, pelo mesmo
motivo estrutural que o guia defende) e, idealmente, **schema separado no Postgres** com permissão
distinta, para que o usuário da aplicação não enxergue a tabela bloqueada.

### 6.6 Tabela de retenção

| # | Categoria | Dados | Base legal | Prazo | Gatilho de eliminação | Fundamento do prazo |
|---|---|---|---|---|---|---|
| 1 | Conta ativa | `users.name`, `email`, `password_hash`, `premium_until` | art. 7º, V | Enquanto a conta existir | Encerramento ou inatividade | Necessidade (art. 6º, III) |
| 2 | Conta desativada | os mesmos | art. 7º, V (cláusula de reativação) | **42 dias** (6 semanas) | Fim da janela → §6.3 | Decisão de produto, declarada nos Termos |
| 3 | Conta com pedido de eliminação | os mesmos | — | **Até 15 dias corridos** | O próprio pedido | art. 16 + art. 19, II por analogia |
| 4 | Credencial | `password_hash` | art. 7º, V | Igual à conta; destruída **no ato** do pedido de eliminação | Pedido | Minimização; reduz dano de vazamento |
| 5 | Fichas | `characters.*` + junção com `languages` | art. 7º, V | Enquanto a conta existir | Encerramento; ou 30 dias na lixeira após soft delete da ficha | Sem prazo legal próprio |
| 6 | Pagamento — operação | `payments.*` | art. 7º, V | Enquanto a conta existir | Migra para a linha 7 | — |
| 7 | Pagamento — guarda fiscal | `payments.*` + vínculo com o titular, **em bloqueio** | art. 7º, II + art. 16, I | **5 anos** do encerramento do exercício da operação | Expiração automática | CTN 173/174; CC 206, §5º, I; CDC 27 |
| 8 | Registros de acesso à aplicação | IP, timestamp, `user_id`, método, rota, status | art. 7º, II | **6 meses** | Expiração automática | Marco Civil, art. 15 |
| 9 | Logs de aplicação e erro | Sem dado pessoal; IP redigido | art. 7º, IX | **30 dias** | Rotação do provedor | Necessidade operacional |
| 10 | Aceite de Termos e Política | Versão, timestamp, IP, user agent | art. 7º, II + ônus da prova (art. 8º, §2) | Vida da conta **+ 5 anos** | Expiração | Prescrição (CC 206, §5º, I) |
| 11 | Consentimentos | Finalidade, concessão, revogação, IP | art. 7º, I + art. 8º, §2 | Vida do consentimento **+ 5 anos** da revogação | Expiração | Prova de que houve e de que cessou |
| 12 | Requisições de titular | Tipo, datas, decisão, justificativa | art. 6º, X (responsabilização) | **5 anos** | Expiração | Prestação de contas |
| 13 | Registro de incidentes | Natureza, dados afetados, medidas, decisão de comunicar ou não | Res. CD/ANPD 15/2024 | **5 anos** | Expiração | A própria resolução |
| 14 | Backups | Snapshot íntegro do banco | Acessória às linhas acima | **30 dias**, rotativos | Expiração natural | "Limites técnicos" do art. 16 |
| 15 | 🔵 E-mail bloqueado por abuso | Hash do e-mail (**pseudonimizado**) | art. 7º, IX | **2 anos** | Expiração | Proporcionalidade — e ver §5.4 |
| 16 | 🔵 Nota fiscal com CPF | CPF/CNPJ, razão social | art. 7º, II | **5 anos** | Expiração | Guarda fiscal |

**Backups, a pergunta que sempre aparece:** o art. 16 fala em eliminar *"no âmbito e nos limites
técnicos das atividades"*. Backup íntegro não se edita cirurgicamente sem comprometer a integridade
do próprio backup. A prática aceita, e que você deve **escrever na Política**: o dado eliminado
não é restaurado; se houver restauração por desastre, a eliminação é reaplicada imediatamente
depois; e o backup expira naturalmente em até 30 dias.

---

## 7. Segurança (art. 46)

O art. 46 exige medidas **técnicas e administrativas** aptas a proteger contra acesso não
autorizado e situações acidentais ou ilícitas. O §2º manda observá-las **desde a concepção** —
o que, para um projeto na Etapa 5, é uma oportunidade: nada aqui é retrofit.

A referência de calibragem para este porte é o **Guia Orientativo de Segurança da Informação para
Agentes de Tratamento de Pequeno Porte**, da ANPD.

### 7.1 Hash de senha — argon2id, e por quê

**Recomendação: `argon2id`.** Não é preferência de estilo; são quatro diferenças materiais.

| Critério | bcrypt | argon2id |
|---|---|---|
| Custo do atacante | **Só CPU.** GPU e FPGA paralelizam barato | **Memória.** Cada tentativa exige N MiB simultâneos — o gargalo do atacante deixa de ser silício e vira RAM, o que derruba o paralelismo em ordens de grandeza |
| Limite de entrada | **72 bytes, truncados em silêncio.** Passphrase longa perde entropia sem aviso | Sem limite prático |
| Pré-hash como remendo | SHA-256 antes do bcrypt para furar o limite introduz byte nulo e abre *password shucking* | Desnecessário |
| Recomendação atual | "Aceitável em sistema legado" | **Primeira opção** do OWASP; variante recomendada pela RFC 9106 |

`argon2id` é híbrido: herda de `argon2i` a resistência a ataque de canal lateral e de `argon2d` a
resistência a *time-memory trade-off*. É a variante certa para senha em servidor.

**Parâmetros.** Comece pelo piso do OWASP, que é seguro e cabe em VPS pequena:

```ts
// src/modules/auth/password.ts
import argon2 from "argon2";

/// OWASP floor for Argon2id. Every parameter set below is equivalent in strength;
/// this one is chosen because 19 MiB per hash survives a small VPS under concurrent logins.
const HASH_OPTIONS = {
  type: argon2.argon2id,
  memoryCost: 19456, // 19 MiB, in KiB
  timeCost: 2,       // iterations
  parallelism: 1,    // lanes
  hashLength: 32,    // bytes
} as const;
```

Conjuntos equivalentes do OWASP — escolha por perfil de máquina, não por "mais é melhor":

| memoryCost | timeCost | parallelism |
|---|---|---|
| 47104 (46 MiB) | 1 | 1 |
| **19456 (19 MiB)** | **2** | **1** ← padrão recomendado |
| 12288 (12 MiB) | 3 | 1 |
| 9216 (9 MiB) | 4 | 1 |
| 7168 (7 MiB) | 5 | 1 |

**Como calibrar, sem chute:**

1. Meça no **host de produção**, não na sua máquina. Alvo: **200–500 ms** por hash.
2. A conta que realmente importa é `memoryCost × logins simultâneos ≤ RAM que você pode ceder`.
   64 MiB × 20 logins concorrentes = 1,28 GiB. Numa VPS de 1 GiB isso é um **auto-DoS**, e o
   atacante o dispara de graça martelando `/login`. **Rate limit no login não é conforto: é o que
   torna o parâmetro de memória seguro.**
3. Com folga de RAM (≥ 2 GiB dedicáveis), suba para `memoryCost: 65536` (64 MiB), `timeCost: 3`.

**Três detalhes que fazem a diferença:**

- **Não guarde os parâmetros em coluna.** Argon2 emite string PHC autocontida —
  `$argon2id$v=19$m=19456,t=2,p=1$<salt>$<hash>`. O campo `passwordHash String` que **já existe**
  no schema basta, e continuará bastando quando os parâmetros mudarem.
- **Reforce os parâmetros ao longo do tempo com `argon2.needsRehash(hash, HASH_OPTIONS)`** no
  login: se o hash antigo estiver abaixo do padrão atual, regrave com os parâmetros novos — você
  já tem a senha em claro naquele instante. É a única janela em que dá para migrar sem forçar
  troca em massa.
- **Salt é por senha, gerado pela biblioteca, 16 bytes.** Nunca um salt global — salt global é
  praticamente não ter salt.

**Escolha de biblioteca.** `argon2` (npm) é binding nativo e exige compilação (`node-gyp`) — algo
a resolver no Dockerfile multi-stage da Etapa 12. `@node-rs/argon2` traz binários pré-compilados
para as plataformas comuns e evita o toolchain de build. As duas são adequadas; a segunda dá menos
atrito no Windows e em imagem Alpine.

**Se por algum motivo tiver de ser bcrypt:** custo mínimo **12**, e **valide explicitamente o
comprimento máximo de 72 bytes**, rejeitando com erro claro em vez de truncar em silêncio.

**Política de senha (NIST SP 800-63B, e vale a pena seguir):**

| Faça | Não faça |
|---|---|
| Mínimo de 8 caracteres, recomendar 12+ | Exigir composição obrigatória (maiúscula + número + símbolo) — piora a entropia real e empurra para `Senha@123` |
| Aceitar até 64+ caracteres, todo Unicode imprimível, inclusive espaço | Expiração periódica sem indício de comprometimento |
| Bloquear senhas de listas de vazamento conhecidas | Impedir colar a senha (quebra gerenciador de senha) |
| Normalizar Unicode (NFKC) antes de hashear | Truncar em silêncio |

### 7.2 Autenticação e sessão

- Token de acesso curto (**15 min**) + **refresh token guardado como hash** no banco, revogável.
- 🔴 **JWT puro não é revogável — e isso quebra a LGPD.** Quando o titular pede eliminação, o acesso
  tem de cair **naquele instante**. Sem tabela de sessão ou sem `credentialsValidFrom` no `User`,
  um token emitido antes continua válido até expirar. É requisito legal disfarçado de detalhe.
- Rotação de refresh token com detecção de reuso (reuso = token roubado = derruba a família toda).
- Segredo do JWT em variável de ambiente, **nunca** no repositório. Rotacionável.
- Ver §5.3 sobre enumeração e sobre hashear mesmo quando o usuário não existe.

### 7.3 Autorização por registro

A convenção do projeto — *"toda função de repositório precisa carregar quem está pedindo desde já"* —
é exatamente a defesa contra **IDOR**, a falha que mais vaza dado em API REST. Mantenha-a como
regra estrutural, não disciplinar.

> ⚠️ **UUIDv7 não é autorização.** Ele evita enumeração sequencial, mas é **ordenado por tempo**:
> um ID revela o instante de criação e permite inferir vizinhança temporal. Trate ID como
> identificador, jamais como segredo.

### 7.4 Transporte e repouso

| Medida | Nota |
|---|---|
| TLS 1.2+ obrigatório, HTTP redirecionado, HSTS | 🟡 No ar |
| Cifra em repouso no disco do banco | Provedor gerenciado normalmente já entrega. Confirme e registre |
| Cifra em coluna | Desnecessária para nome e e-mail neste porte. **Obrigatória se entrar CPF** |
| `@fastify/helmet` | Cabeçalhos de segurança |
| CORS por allowlist | **Nunca `origin: "*"` com credenciais** — é o mesmo que não ter CORS |

### 7.5 Segredos e privilégio

- 🔴 `.env` fora do Git — **já está** no `.gitignore`.
- 🔴 **A senha de desenvolvimento nunca vira a senha de produção.** Rotacione antes do primeiro deploy.
- 🟡 Segredos em cofre da plataforma, não em arquivo no servidor.
- 🟡 **Menor privilégio no Postgres:** o usuário da aplicação não é `SUPERUSER` nem dono do schema.
  Migration roda com um usuário mais privilegiado, separado, e só no pipeline.
- 🔴 **Prisma Studio jamais exposto na internet.** O guia já diz isso; aqui vira também requisito
  do art. 46, porque Studio é acesso irrestrito sem autenticação nem trilha.

### 7.6 Logs — o vazamento que ninguém percebe

`src/app.ts` está com `Fastify({ logger: true })`. O serializador padrão de requisição do Fastify
registra `remoteAddress` — ou seja, **o IP já está sendo logado**, e IP é dado pessoal. Em produção
esses logs vão para um provedor terceiro, o que faz disso um **compartilhamento de dado pessoal com
operador**, sem finalidade declarada e sem prazo.

Correções, todas baratas:

| Correção | Por quê |
|---|---|
| Configurar `redact` no pino para `authorization`, `cookie`, `set-cookie`, `password`, `token` | Cabeçalho de autenticação em log é credencial em texto puro |
| **Nunca logar corpo de requisição** | Cadastro e login carregam senha no corpo |
| **Proibir credencial e token em query string** | Query string entra em log de acesso, proxy, referer e histórico do navegador |
| Decidir conscientemente sobre o IP | Se quiser o IP, guarde em `access_logs` com TTL de 6 meses (§6.4) — não solto em log sem prazo |
| Serializador próprio para `req` | O padrão registra mais do que você precisa |

### 7.7 Dado real nunca sai de produção

🔴 **AGORA, e é a regra mais barata e mais violada de todas:** banco de desenvolvimento e de teste
usam **apenas dado sintético** — o seed do SRD mais usuários fictícios. Copiar dump de produção para
a máquina do dev transforma cada notebook do time num ponto de vazamento fora de qualquer controle.

Testcontainers (Etapa 10) já resolve isso pela arquitetura: banco descartável, dado gerado. Bom.

### 7.8 Contratos com operadores (art. 39)

🟡 Antes do primeiro usuário real, cada operador precisa de contrato ou DPA cobrindo: finalidade
limitada, atuação apenas sob instrução do controlador, confidencialidade, medidas de segurança,
subcontratação mediante autorização, **apoio ao atendimento dos direitos do titular**, **notificação
imediata de incidente**, e eliminação ou devolução dos dados ao fim.

Na prática, provedores sérios já publicam DPA — **leia e arquive**, não presuma.

### 7.9 Transferência internacional (arts. 33 a 36)

🟡 **Hospedar a API ou o banco fora do Brasil é transferência internacional de dados.** Vercel, AWS
fora de `sa-east-1`, Railway, Fly.io, Stripe US, provedores de e-mail e de observabilidade —
todos entram nessa conta.

A **Resolução CD/ANPD nº 19/2024** aprovou o regulamento de transferência internacional e as
**Cláusulas-Padrão Contratuais (CPC)**. Antes do deploy: mapeie onde cada operador processa,
verifique qual mecanismo do art. 33 sustenta cada fluxo, e **confirme o texto vigente das CPC e os
prazos de adequação junto à ANPD** — este é um tema com regulamentação em movimento.

**A saída mais simples para um projeto deste porte: hospedar no Brasil.** Elimina a questão inteira.

---

## 8. Incidentes (art. 48) — o que precisa existir *antes*

### 8.1 A regra e o relógio

A **Resolução CD/ANPD nº 15/2024** regulamenta a comunicação de incidentes. O prazo é de
**3 (três) dias úteis contados da ciência** de que o incidente afetou dados pessoais e pode
acarretar risco ou dano relevante. A comunicação é feita à ANPD e aos titulares afetados.

Conteúdo mínimo, direto do art. 48, §1º:

1. Natureza dos dados pessoais afetados
2. Informações sobre os titulares envolvidos
3. Medidas técnicas e de segurança que protegiam os dados
4. Riscos relacionados ao incidente
5. Motivos da demora, se a comunicação não foi imediata
6. Medidas adotadas ou a adotar para reverter ou mitigar o prejuízo

> **Três dias úteis é pouco.** Se você começar a montar o plano depois que o incidente acontecer,
> o prazo acaba enquanto você ainda tenta descobrir quem foi afetado. Todo o valor deste capítulo
> está em ser trabalho feito **antes**.

### 8.2 Por que o vazamento da tabela `users` é automaticamente relevante

Entre os critérios de risco relevante da resolução estão dados de **crianças e adolescentes** e
**dados de autenticação em sistemas**.

Consequência direta para o fichart:

- `users.password_hash` é dado de autenticação. Vazar a tabela `users` **é** incidente de risco
  relevante. Não há espaço para "achamos que não era grave".
- O público do produto inclui adolescentes. Isso reforça o mesmo enquadramento.

E é aqui que a escolha do §7.1 tem efeito jurídico, não só técnico: o **art. 48, §3º** diz que a
ANPD, ao julgar a gravidade, considerará a comprovação de que foram adotadas medidas técnicas que
tornem os dados **ininteligíveis**. Hash `argon2id` com parâmetros documentados **é** essa prova.
Senha em MD5, SHA-1 ou texto puro é o oposto — agrava.

### 8.3 O que ter pronto, antes

| # | Item | Quando | Estado |
|---|---|---|---|
| 1 | **Plano de resposta em uma página**: quem declara o incidente, quem contém, quem comunica, telefones e e-mails | 🔴 AGORA | ❌ |
| 2 | **Definição de "ciência"** e de quem tem autoridade para declará-la — é o que dispara o relógio dos 3 dias úteis | 🔴 AGORA | ❌ |
| 3 | **Registro de incidentes** (tabela ou planilha), incluindo os **não comunicados** e a justificativa de não comunicar — guardado por 5 anos | 🔴 AGORA | ❌ |
| 4 | **Capacidade de responder "quem foi afetado"** — sem `access_logs`, o art. 48, §1º, II é inrespondível | 🟡 NO AR | ❌ |
| 5 | **Botão de pânico:** invalidar todas as sessões e forçar troca de senha global (`credentialsValidFrom` ou tabela de sessão) | 🟡 NO AR | ❌ |
| 6 | **Modelos prontos**: comunicação à ANPD, e-mail aos titulares, nota pública | 🟡 NO AR | ❌ |
| 7 | **Contatos dos operadores** e a cláusula contratual que os obriga a avisar você **imediatamente** | 🟡 NO AR | ❌ |
| 8 | **Backup com restauração testada** — backup nunca restaurado não é backup, é esperança | 🟡 NO AR | ❌ |
| 9 | **Canal do titular já publicado** — no dia do incidente não dá tempo de criar | 🔴 AGORA | ❌ |
| 10 | Monitoramento mínimo: alerta de erro em massa, de pico de 401/403, de exportação anômala | 🟡 NO AR | ❌ |

> ℹ️ A Resolução CD/ANPD nº 2/2022 prevê tratamento diferenciado de prazos para agentes de pequeno
> porte. **Não construa o plano contando com prazo estendido:** confirme o texto vigente antes de
> depender dele, e opere sempre com o relógio de 3 dias úteis. Se houver folga, ela é bônus.

---

## 9. Acadêmico × produção — o que muda de verdade

### 9.1 A exceção do art. 4º, e o tamanho exato dela

> **Art. 4º** Esta Lei não se aplica ao tratamento de dados pessoais: […]
> **II** — realizado para fins exclusivamente: […] **b) acadêmicos**, aplicando-se a esta hipótese
> os arts. 7º e 11 desta Lei;

Três leituras precisas, porque essa é a parte mais citada errado do assunto:

1. **"Exclusivamente" é literal.** A exceção morre no primeiro sinal de finalidade econômica.
   O fichart tem `premiumUntil` e `Payment` no schema — **a intenção comercial está declarada no
   modelo de dados**. Enquanto ninguém pagar de fato, a exceção ainda se sustenta; no primeiro
   pagamento, acaba.
2. **A exceção não é isenção completa.** Ela mesma ressalva os **arts. 7º e 11**: mesmo em pesquisa
   acadêmica, todo tratamento de dado pessoal real precisa de **base legal**.
3. **Dado sintético está fora da LGPD por natureza** (art. 5º, I e art. 12), não por exceção.
   Este é o caminho limpo — e é por isso que §7.7 é a regra mais importante da fase acadêmica.

### 9.2 O que é obrigatório **agora**

Se o banco só tiver dado sintético, o seed do SRD e a conta do próprio autor, a LGPD praticamente
não se aplica. Mesmo assim, faça estes itens agora — não por obrigação, mas porque **cada um deles
custa minutos hoje e dias depois**:

| # | Item | Por que agora e não depois |
|---|---|---|
| 1 | **`argon2id` desde o primeiro login** (Etapa 9) | Trocar algoritmo com base viva exige campanha de re-hash no login e conviver com dois formatos por meses |
| 2 | **Desenhar os três estados de conta** (§6.2) e os campos `erasureRequestedAt` / `anonymizedAt` | Enxertar "eliminação ≠ desativação" em código pronto é refatoração de autenticação, não uma migration |
| 3 | **Decidir `email String?`** (§6.3) | Tornar `@unique` anulável com base em produção mexe em login, cadastro e reativação ao mesmo tempo |
| 4 | **Nunca colocar dado real em dev/teste** | Custa zero. Reverter um vazamento de dump não custa zero |
| 5 | **`.env` fora do Git** ✅ | Já feito. Segredo commitado vive no histórico para sempre |
| 6 | **Redação de log e proibição de token em query string** (§7.6) | Log é o vazamento que ninguém percebe até auditar |
| 7 | **Canal do titular publicado** | É uma linha de texto |
| 8 | **Este documento existir e ser mantido** | É a semente do registro de operações do art. 37 |
| 9 | **Rotular `name` como nome de exibição** | Uma string de UI que reduz permanentemente o dano de qualquer vazamento futuro |
| 10 | **Termos e Política escritos, mesmo em rascunho** | Escrever a Política obriga a responder "para que serve cada campo" — e isso corrige o schema |

**Cuidado prático com a fase acadêmica:** no dia em que um colega ou o professor criar conta com
e-mail real para testar, existe titular real. A saída correta não é papelada: é **e-mail descartável
ou conta de teste**, e apagar tudo ao fim da avaliação.

### 9.3 O que passa a ser obrigatório **quando for ao ar**

Gatilho: **o primeiro usuário que não é você**, ou **a primeira cobrança** — o que vier antes.

| # | Obrigação | Artigo |
|---|---|---|
| 1 | Política de Privacidade **publicada antes da coleta** | art. 9º |
| 2 | Termos de Uso aceitos com registro de versão e data | art. 8º, §2 (prova) |
| 3 | Canal do titular funcional, com SLA de 15 dias | art. 18; art. 41 |
| 4 | Rotas de acesso, correção, exportação e eliminação | art. 18, II, III, V, VI |
| 5 | **Job de eliminação definitiva** rodando de fato | art. 16 |
| 6 | Registros de acesso à aplicação, 6 meses | Marco Civil, art. 15 |
| 7 | Retenção fiscal de pagamento em bloqueio, 5 anos | art. 7º, II; art. 16, I |
| 8 | Medidas de segurança do §7 implantadas | art. 46 |
| 9 | Plano e registro de incidentes | art. 48; Res. 15/2024 |
| 10 | Contratos/DPA com todos os operadores | art. 39 |
| 11 | Análise de transferência internacional | arts. 33 a 36; Res. 19/2024 |
| 12 | Registro das operações de tratamento (§13) | art. 37 |
| 13 | Idade mínima e declaração no cadastro | art. 14 |
| 14 | Atribuição do SRD 5.1 (CC-BY-4.0) | Não é LGPD, mas é obrigação legal. Ver §12 |

---

## 10. Checklist técnico

### 10.1 Schema Prisma

| # | Item | Estado | Quando |
|---|---|---|---|
| 1 | `passwordHash` nomeado corretamente, nunca `password` | ✅ | — |
| 2 | Não guarda dado de cartão; só referência do gateway | ✅ | — |
| 3 | Soft delete com `deletedAt DateTime?` em `User` e `Character` | ✅ | — |
| 4 | `externalPayment @unique` (idempotência de webhook) | ✅ | — |
| 5 | UUIDv7 em vez de inteiro sequencial | ✅ | — |
| 6 | `User.erasureRequestedAt` — pedido do art. 18, bloqueia reativação | ❌ | 🔴 AGORA |
| 7 | `User.anonymizedAt` — identificadores destruídos | ❌ | 🔴 AGORA |
| 8 | `User.credentialsValidFrom` — invalidação global de token | ❌ | 🟡 NO AR |
| 9 | `User.emailVerifiedAt` | ❌ | 🟡 NO AR |
| 10 | `User.email` passa a `String?` para permitir anonimização (§6.3) | ❌ | 🔴 AGORA (decisão) |
| 11 | `LegalDocument` + `LegalDocumentAcceptance` — versão, data, IP do aceite | ❌ | 🟡 NO AR |
| 12 | `Consent` — finalidade, concessão, revogação | ❌ | 🟡 NO AR |
| 13 | `DataSubjectRequest` — prova de atendimento do art. 18 | ❌ | 🟡 NO AR |
| 14 | `AccessLog` — Marco Civil, art. 15, com TTL de 6 meses | ❌ | 🟡 NO AR |
| 15 | 🔵 `Campaign` / `CampaignMember` com exposição de nome, nunca de e-mail | ❌ | 🔵 |

Esqueleto das tabelas novas, seguindo as convenções do projeto (identificadores em inglês, modelo
singular `PascalCase`, tabela plural `snake_case`, campo `camelCase` com `@map`, `@@index` em toda
FK usada em filtro, documentação com `///`):

```prisma
enum LegalDocumentKind {
  TERMS_OF_USE
  PRIVACY_POLICY
}

enum ConsentPurpose {
  MARKETING_EMAIL
  PUBLIC_SHARING
}

enum DataSubjectRequestKind {
  CONFIRMATION
  ACCESS
  CORRECTION
  ANONYMIZATION
  PORTABILITY
  ERASURE
  SHARING_INFO
}

enum DataSubjectRequestStatus {
  RECEIVED
  IN_PROGRESS
  FULFILLED
  REJECTED
}

/// Versioned legal text. A new version is a new row: published documents are immutable,
/// because an acceptance must always point at the exact wording the user agreed to.
model LegalDocument {
  id          String            @id @default(uuid(7))
  kind        LegalDocumentKind
  version     String
  content     String
  publishedAt DateTime          @map("published_at")

  acceptances LegalDocumentAcceptance[]

  @@unique([kind, version])
  @@map("legal_documents")
}

/// Proof that a given user agreed to a given version. LGPD art. 8, § 2 puts the burden
/// of proving consent on the controller.
model LegalDocumentAcceptance {
  id String @id @default(uuid(7))

  userId String @map("user_id")
  user   User   @relation(fields: [userId], references: [id])

  legalDocumentId String        @map("legal_document_id")
  legalDocument   LegalDocument @relation(fields: [legalDocumentId], references: [id])

  acceptedAt DateTime @default(now()) @map("accepted_at")
  ipAddress  String?  @map("ip_address")
  userAgent  String?  @map("user_agent")

  @@unique([userId, legalDocumentId])
  @@index([userId])
  @@map("legal_document_acceptances")
}

/// Opt-in for anything that is NOT required to run the service. Never used for the
/// account itself, which stands on contract performance (LGPD art. 7, V).
model Consent {
  id String @id @default(uuid(7))

  userId String @map("user_id")
  user   User   @relation(fields: [userId], references: [id])

  purpose   ConsentPurpose
  grantedAt DateTime       @default(now()) @map("granted_at")
  revokedAt DateTime?      @map("revoked_at")
  ipAddress String?        @map("ip_address")

  @@index([userId])
  @@index([purpose])
  @@map("consents")
}

/// Audit trail for data subject requests (LGPD art. 18). Kept for accountability
/// (art. 6, X) even after the account itself is gone.
model DataSubjectRequest {
  id String @id @default(uuid(7))

  userId String @map("user_id")
  user   User   @relation(fields: [userId], references: [id])

  kind        DataSubjectRequestKind
  status      DataSubjectRequestStatus @default(RECEIVED)
  requestedAt DateTime                 @default(now()) @map("requested_at")
  respondedAt DateTime?                @map("responded_at")

  /// Recorded when a request is rejected or only partially fulfilled (LGPD art. 18, § 4).
  decisionNote String? @map("decision_note")

  @@index([userId])
  @@index([status])
  @@map("data_subject_requests")
}

/// Application access records required by the Brazilian Civil Rights Framework for the
/// Internet (Law 12.965/2014, art. 15): six months, under confidentiality.
/// Deliberately separate from application logs, which must carry no personal data.
model AccessLog {
  id String @id @default(uuid(7))

  userId String? @map("user_id")

  ipAddress  String  @map("ip_address")
  userAgent  String? @map("user_agent")
  method     String
  path       String
  statusCode Int     @map("status_code")
  occurredAt DateTime @default(now()) @map("occurred_at")

  @@index([userId])
  @@index([occurredAt])
  @@map("access_logs")
}
```

### 10.2 Rotas

| # | Rota | Direito | Estado | Quando |
|---|---|---|---|---|
| 1 | `GET /v1/me` | art. 18, I e II (simplificado, imediato) | ❌ | 🟡 |
| 2 | `PATCH /v1/me` | art. 18, III | ❌ | 🟡 |
| 3 | `POST /v1/me/exports` → `202` + job | art. 18, V e art. 19, §3 | ❌ | 🟡 |
| 4 | `GET /v1/me/exports/:id` | entrega do arquivo | ❌ | 🟡 |
| 5 | `POST /v1/me/deactivation` — encerramento voluntário, janela de 6 semanas | Contrato | ❌ | 🟡 |
| 6 | `POST /v1/me/erasure` — art. 18, VI, **sem** janela de graça | art. 18, VI | ❌ | 🟡 |
| 7 | `POST /v1/me/reactivation` — só se `erasureRequestedAt IS NULL` | Contrato | ❌ | 🟡 |
| 8 | `GET/PUT /v1/me/consents` — conceder e revogar, granular | art. 18, IX | ❌ | 🟡 |
| 9 | `GET /v1/legal/terms` e `/privacy` — versão vigente, pública | art. 9º | ❌ | 🟡 |
| 10 | Reautenticação obrigatória em exportação, eliminação e troca de e-mail | art. 46 | ❌ | 🟡 |

### 10.3 Jobs

| # | Job | Frequência | Ação | Estado | Quando |
|---|---|---|---|---|---|
| 1 | Eliminação de contas desativadas | Diária | `deletedAt < now() - 42 dias` → §6.3 | ❌ | 🟡 |
| 2 | Eliminação por pedido do titular | Diária (ou imediata) | `erasureRequestedAt IS NOT NULL` → §6.3, em até 15 dias | ❌ | 🟡 |
| 3 | Expurgo de `access_logs` | Diária | `occurredAt < now() - 6 meses` | ❌ | 🟡 |
| 4 | Expurgo de pagamento fora do prazo fiscal | Mensal | `> 5 anos` → apaga o `Payment` e, se for a última âncora, o `User` anonimizado | ❌ | 🟡 |
| 5 | Expurgo de arquivos de exportação | Diária | `> 7 dias` | ❌ | 🟡 |
| 6 | Expurgo de lixeira de ficha | Diária | `characters.deletedAt < now() - 30 dias` | ❌ | 🟡 |

> ⚠️ **Todo job de eliminação precisa de teste automatizado.** Job de expurgo é código que ninguém
> lê e que, quando erra, erra apagando o que não devia — ou, pior, não apagando nada em silêncio
> por dois anos. Cubra os dois lados: apagou o que devia **e** preservou o pagamento no prazo fiscal.

### 10.4 Segurança

| # | Item | Estado | Quando |
|---|---|---|---|
| 1 | `.env` no `.gitignore` | ✅ | — |
| 2 | `.env.example` sem valores reais | ✅ | — |
| 3 | `argon2id` com parâmetros explícitos (§7.1) | ❌ | 🔴 |
| 4 | `argon2.needsRehash` no login | ❌ | 🟡 |
| 5 | Hash falso quando o usuário não existe (defesa contra timing) | ❌ | 🟡 |
| 6 | Validação de entrada com Zod em toda fronteira externa | ❌ | 🟡 (Etapa 7) |
| 7 | `@fastify/rate-limit` em `/login`, `/signup`, `/password-reset`, `/exports` | ❌ | 🟡 |
| 8 | `@fastify/helmet` | ❌ | 🟡 |
| 9 | CORS por allowlist, nunca `*` com credenciais | ❌ | 🟡 |
| 10 | `redact` no pino; corpo de requisição nunca logado (§7.6) | ⚠️ `logger: true` cru | 🔴 |
| 11 | Token de acesso curto + refresh hasheado e revogável | ❌ | 🟡 |
| 12 | Filtro de soft delete **só** no repository | ⚠️ decidido, sem código | 🟡 |
| 13 | Autorização por registro em toda função de repositório | ⚠️ decidido, sem código | 🟡 |
| 14 | Menor privilégio no usuário do Postgres | ❌ | 🟡 |
| 15 | Senha de dev rotacionada antes do primeiro deploy | ❌ | 🟡 |
| 16 | TLS + HSTS | ❌ | 🟡 |
| 17 | Dado real jamais em dev/teste | ⚠️ regra por escrever | 🔴 |
| 18 | `npm audit` no CI + Dependabot | ❌ | 🟡 |
| 19 | Backup automático **com restauração testada** | ❌ | 🟡 |
| 20 | Prisma Studio nunca exposto | ✅ regra no guia | — |

### 10.5 Documentos

| # | Documento | Estado | Quando |
|---|---|---|---|
| 1 | Este documento, mantido vivo | ✅ | — |
| 2 | Política de Privacidade publicada (§11) | ❌ | 🟡 |
| 3 | Termos de Uso publicados (§12) | ❌ | 🟡 |
| 4 | Registro das operações — art. 37 (§13) | ⚠️ esqueleto abaixo | 🔴 |
| 5 | Plano de resposta a incidente (§8.3) | ❌ | 🔴 |
| 6 | Registro de incidentes, 5 anos | ❌ | 🔴 |
| 7 | DPA de cada operador, lido e arquivado | ❌ | 🟡 |
| 8 | Mapa de transferência internacional | ❌ | 🟡 |
| 9 | Aviso de atribuição do SRD 5.1 (CC-BY-4.0) | ❌ | 🔴 |

---

## 11. Esqueleto da Política de Privacidade

O art. 9º define o conteúdo mínimo. A estrutura abaixo cobre os sete incisos e mais o que a prática
exige. **Escreva em linguagem simples** — o art. 14, §6º exige isso quando há menores, e não faz
mal a ninguém.

```markdown
# Política de Privacidade do fichart
Versão 1.0 — vigente desde DD/MM/AAAA

## Resumo em 10 linhas          ← art. 14, §6º; e é o único trecho que as pessoas leem
- Pedimos duas coisas: um nome de exibição e um e-mail. Nada além disso.
- O nome de exibição não precisa ser seu nome real.
- Não guardamos dado de cartão. A cobrança é feita por [GATEWAY].
- Suas fichas são suas. Você pode baixar tudo em JSON quando quiser.
- Você pode encerrar a conta a qualquer momento e apagar seus dados.
- Não vendemos dado. Não fazemos publicidade dirigida. Não criamos perfil de ninguém.
- Idade mínima: 13 anos.
- Dúvida ou pedido: privacidade@fichart.[dominio]

## 1. Quem somos                                          [art. 9º, III e IV]
Controlador: [RAZÃO SOCIAL ou NOME], [CNPJ ou CPF], [ENDEREÇO].
Contato para assuntos de dados pessoais: privacidade@fichart.[dominio].
Encarregado: [NOME], mesmo endereço.

## 2. Que dados tratamos e por quê                        [art. 9º, I e II]
Tabela: dado → finalidade → base legal → prazo.
Reproduzir aqui, em linguagem comum, as tabelas dos §3 e §6.6 deste documento.
Dizer explicitamente o que NÃO coletamos: data de nascimento, CPF, telefone,
endereço, localização, dado de cartão.

## 3. Como usamos cookies                                 [front-end]
Apenas os essenciais de sessão e segurança. Se um dia houver analytics ou qualquer
cookie não essencial, ele passa a exigir banner com opção real de recusar,
e recusar não pode degradar o serviço.

## 4. Com quem compartilhamos                             [art. 9º, V e art. 18, VII]
Lista nominal e atualizada de operadores, com finalidade e país de processamento:
- Hospedagem da aplicação e do banco: [FORNECEDOR] — [PAÍS]
- Gateway de pagamento: [FORNECEDOR] — [PAÍS]
- E-mail transacional: [FORNECEDOR] — [PAÍS]
- Observabilidade e logs: [FORNECEDOR] — [PAÍS]
Não vendemos, não alugamos e não cedemos dado pessoal para publicidade.

## 5. Transferência internacional                         [arts. 33 a 36]
Se algum fornecedor acima processar fora do Brasil, dizer qual, para onde, e sob
qual mecanismo (Cláusulas-Padrão Contratuais da ANPD, ou outra hipótese do art. 33).

## 6. Por quanto tempo guardamos                          [art. 9º, II; art. 16]
Reproduzir a tabela do §6.6 em linguagem comum. Explicar em uma frase:
"Encerrar a conta e pedir a exclusão dos dados são coisas diferentes — a primeira
tem uma janela de 42 dias para você mudar de ideia; a segunda não tem janela."
Explicar backups: o dado apagado não volta; o backup expira em até 30 dias.
Explicar as duas exceções que sobrevivem: registro fiscal (5 anos) e registros de
acesso exigidos pelo Marco Civil (6 meses).

## 7. Seus direitos                                       [art. 9º, VII; art. 18]
Listar os nove incisos do art. 18 com uma frase cada.
Dizer ONDE se exerce cada um: dentro do app, ou pelo e-mail do §1.
Prazo de resposta: até 15 dias corridos.
Dizer que a recusa em consentir com o que é opcional não afeta o uso do serviço.
                                                          [art. 18, VIII]

## 8. Crianças e adolescentes                             [art. 14, §2º e §6º]
Idade mínima: 13 anos. Menores de 18 usam com conhecimento dos responsáveis.
Plano pago exige 18 anos, ou contratação pelo responsável.
Não fazemos publicidade nem perfilamento — para ninguém, e menos ainda para menores.
Se você é responsável e encontrou conta de menor de 13 anos: escreva para
privacidade@fichart.[dominio]. Encerramos a conta e eliminamos os dados.

## 9. Como protegemos                                     [art. 46]
Em linguagem comum e sem revelar arquitetura: senhas guardadas com algoritmo
moderno de derivação (nunca em texto), tráfego cifrado, acesso restrito,
backups, registro de acessos administrativos.

## 10. Incidentes                                         [art. 48]
"Se ocorrer incidente com risco relevante, comunicaremos você e a ANPD nos prazos
da lei, informando o que aconteceu, quais dados foram afetados e o que fazer."

## 11. Mudanças nesta Política
Versionada, com histórico público. Mudança relevante é avisada por e-mail com
antecedência de [30] dias.

## 12. Reclamação
Você pode reclamar à ANPD: https://www.gov.br/anpd
```

**Três erros a evitar:**

1. **Publicar depois de começar a coletar.** O art. 9º pressupõe informação **prévia**. A Política
   entra no ar antes do primeiro cadastro.
2. **Copiar política de outro produto.** Ela descreve *aquele* tratamento. Cada linha que não
   corresponde ao seu sistema é uma declaração falsa e uma infração autônoma de transparência.
3. **Deixar a lista de operadores desatualizada.** Trocou de hospedagem, entrou uma ferramenta de
   e-mail? A Política muda no mesmo dia. É o item que mais envelhece em silêncio.

---

## 12. Esqueleto dos Termos de Uso

Os Termos são **contrato** — Código Civil, CDC e Marco Civil, não LGPD. É a base legal do art. 7º, V:
se o contrato não existir ou for vago, a base legal principal do sistema fica sem lastro.

```markdown
# Termos de Uso do fichart
Versão 1.0 — vigente desde DD/MM/AAAA

## 1. Quem oferece o serviço          [CDC art. 31; Decreto 7.962/2013, art. 2º]
Razão social, CNPJ, endereço físico, endereço eletrônico, canal de atendimento.
Comércio eletrônico exige identificação completa e ostensiva — não é opcional.

## 2. O que o fichart é
Descrição do serviço, o que o plano gratuito inclui, o que o premium inclui.

## 3. Quem pode usar
Idade mínima 13 anos. Entre 13 e 18, com conhecimento e autorização do responsável.
Plano pago: 18 anos, ou contratação pelo responsável (capacidade civil — CC arts. 3º e 4º).
Uma conta por pessoa; o titular responde pelo uso da credencial dele.

## 4. Conta e credencial
Cadastro exige nome de exibição e e-mail. Você é responsável por manter a senha em
segredo e por avisar em caso de uso indevido.

## 5. Seu conteúdo é seu
As fichas que você cria são suas. Você nos concede apenas a licença técnica,
limitada e revogável, necessária para hospedar, processar e exibir esse conteúdo
para você — e para quem você escolher, se um dia usar campanhas ou publicação.
Encerrada a conta, a licença termina.

## 6. Conteúdo proibido
Ilícito, que viole direito de terceiro, que assedie ou ofenda.
E, expressamente:
- Não insira dado pessoal de terceiros em campos livres.
- Não insira dado sensível (saúde, religião, política, orientação sexual, biometria),
  nem sobre você nem sobre ninguém.

## 7. Propriedade intelectual e o SRD
O código e a marca fichart pertencem ao controlador.
Aviso obrigatório de atribuição:

  This work includes material taken from the System Reference Document 5.1
  ("SRD 5.1") by Wizards of the Coast LLC and available at
  https://www.dndbeyond.com/srd. The SRD 5.1 is licensed under the Creative
  Commons Attribution 4.0 International License available at
  https://creativecommons.org/licenses/by/4.0/legalcode.

"Dungeons & Dragons", "D&D" e "Wizards of the Coast" são marcas de seus titulares.
A licença CC-BY-4.0 NÃO licencia marcas: o fichart não é afiliado, patrocinado
nem endossado pela Wizards of the Coast, e não pode dar a entender que seja.

## 8. Plano premium                    [CDC; Decreto 7.962/2013]
Preço total, forma de pagamento, periodicidade, renovação automática (se houver)
e como cancelar. Cancelar tem de ser tão fácil quanto contratar.
Direito de arrependimento: 7 dias corridos a partir da contratação, pelo mesmo
canal em que foi contratado, com devolução integral.        [CDC art. 49]
Reajuste: como e com quanta antecedência é avisado.

## 9. Encerramento da conta
Você pode encerrar a qualquer momento. A conta fica desativada por 42 dias e pode
ser reativada nesse período; depois disso os dados são eliminados ou anonimizados.
Se você preferir a eliminação imediata, use o pedido de exclusão — nesse caso não
há janela de reativação. Detalhes na Política de Privacidade.
Podemos encerrar sua conta por violação destes Termos, com aviso e motivo.

## 10. Disponibilidade
Serviço prestado no estado em que se encontra, com melhores esforços.
Manutenções programadas são avisadas quando possível.
Sem garantia de disponibilidade ininterrupta.
⚠️ Não exclua nem atenue responsabilidade por vício ou defeito do serviço:
o CDC (art. 25) considera abusiva a cláusula que faça isso.

## 11. Privacidade
Remissão à Política de Privacidade, que é parte integrante destes Termos.

## 12. Alterações
Versionadas, com histórico. Mudança relevante é avisada com [30] dias de
antecedência; continuar usando após a vigência significa aceitar.

## 13. Lei aplicável e foro
Lei brasileira. Foro do domicílio do consumidor.        [CDC art. 101, I]
⚠️ Cláusula de foro de eleição contra o consumidor é abusiva. Não use.
```

**Requisito técnico dos Termos, que é o que os torna prova:** o aceite grava `userId`,
`legalDocumentId` (versão exata), `acceptedAt`, `ipAddress` e `userAgent`. Documento publicado é
**imutável** — mudou o texto, é versão nova, com aceite novo. Sem isso, você não consegue provar
a que texto o titular aderiu, e o art. 8º, §2 põe esse ônus em você.

---

## 13. Registro das operações de tratamento (art. 37) — versão simplificada

O art. 37 obriga controlador e operador a manter registro das operações. Para agente de pequeno
porte, a Resolução CD/ANPD nº 2/2022 admite formato simplificado — **esta tabela cumpre o papel.**
Mantenha-a viva; ela é a primeira coisa pedida numa fiscalização.

| Operação | Dados | Finalidade | Base legal | Titulares | Compartilhamento | Retenção | Medidas |
|---|---|---|---|---|---|---|---|
| Cadastro e conta | nome de exibição, e-mail, hash de senha | Criar e manter a conta | art. 7º, V | Usuários | Hospedagem | Vida da conta + 42 dias | argon2id, TLS, autorização por registro |
| Guarda de fichas | conteúdo do personagem | Prestar o serviço | art. 7º, V | Usuários | Hospedagem | Vida da conta | Autorização por registro, soft delete |
| Cobrança | referência do gateway, valor, status | Cobrar a assinatura | art. 7º, V | Assinantes | Gateway | Vida da conta | Sem dado de cartão |
| Guarda fiscal | os mesmos, em bloqueio | Obrigação fiscal | art. 7º, II | Assinantes | Contabilidade | 5 anos | Bloqueio de acesso funcional |
| Registros de acesso | IP, timestamp, rota, `user_id` | Marco Civil e segurança | art. 7º, II | Usuários | Hospedagem | 6 meses | Sigilo, TTL automático |
| Antifraude | tentativas de login, IP | Prevenir abuso | art. 7º, IX | Usuários e visitantes | — | 30 dias | Rate limit |
| Comunicação transacional | e-mail, nome de exibição | Operar o contrato | art. 7º, V | Usuários | Provedor de e-mail | Vida da conta | — |
| Marketing | e-mail, nome de exibição | Novidades | art. 7º, I | Quem consentiu | Provedor de e-mail | Até revogar + 5 anos | Opt-in separado, opt-out em 1 clique |
| Atendimento ao titular | pedido, decisão, datas | Cumprir o art. 18 | art. 6º, X | Usuários | — | 5 anos | Registro auditável |

---

## 14. Os dez primeiros passos, em ordem

Ordenados por **custo de adiar**, não por importância teórica.

| # | Ação | Quando | Onde |
|---|---|---|---|
| 1 | Decidir `email String?` e criar `erasureRequestedAt` / `anonymizedAt` | 🔴 AGORA | `schema.prisma` |
| 2 | Escrever a regra "dado real jamais em dev/teste" no guia | 🔴 AGORA | `Guia-Fichart-API.md` |
| 3 | Configurar `redact` no logger e proibir token em query string | 🔴 AGORA | `src/app.ts` |
| 4 | Publicar o e-mail do canal do titular | 🔴 AGORA | README + futura Política |
| 5 | Adicionar o aviso de atribuição do SRD 5.1 | 🔴 AGORA | README + `LICENSE` |
| 6 | Plano de resposta a incidente em uma página + registro de incidentes | 🔴 AGORA | `docs/` |
| 7 | Implementar `argon2id` com os parâmetros do §7.1 | 🔴 Etapa 9 | `src/modules/auth/` |
| 8 | Separar `deactivation` de `erasure` nas rotas e no service | 🟡 Etapa 9 | `src/modules/users/` |
| 9 | Rota de exportação JSON com FKs resolvidas | 🟡 Etapa 9–11 | `src/modules/users/` |
| 10 | Jobs de expurgo, **com teste automatizado** | 🟡 antes do deploy | `src/jobs/` |

---

## 15. Referências

**Legislação**
- Lei 13.709/2018 (LGPD) — em especial arts. 4º, 5º, 6º, 7º, 8º, 9º, 10, 11, 12, 14, 15, 16, 18, 19, 33 a 39, 41, 46, 48
- Lei 12.965/2014 (Marco Civil da Internet) — arts. 7º, 10 a 15
- Lei 8.078/1990 (CDC) — arts. 25, 27, 31, 49, 101
- Lei 8.069/1990 (ECA) — art. 2º (criança × adolescente)
- Lei 10.406/2002 (Código Civil) — arts. 3º, 4º, 205, 206
- Lei 5.172/1966 (CTN) — arts. 173 e 174
- Decreto 7.962/2013 — contratação no comércio eletrônico

**Regulamentação da ANPD**
- Resolução CD/ANPD nº 2/2022 — agentes de tratamento de pequeno porte
- Resolução CD/ANPD nº 15/2024 — comunicação de incidente de segurança
- Resolução CD/ANPD nº 19/2024 — transferência internacional e Cláusulas-Padrão Contratuais
- Guia Orientativo — Segurança da Informação para Agentes de Tratamento de Pequeno Porte
- Estudos e orientações da ANPD sobre dados de crianças e adolescentes

**Técnicas**
- OWASP Password Storage Cheat Sheet — parâmetros de Argon2id, scrypt e bcrypt
- RFC 9106 — Argon2
- NIST SP 800-63B — diretrizes de autenticação e política de senha

**Licenciamento de conteúdo**
- SRD 5.1, Wizards of the Coast — Creative Commons Attribution 4.0 International

> ⚠️ A regulamentação da ANPD está em evolução contínua. Antes de ir ao ar, **confirme o texto
> vigente** das resoluções citadas — sobretudo prazos de incidente e o regime de transferência
> internacional. Este documento reflete o estado do assunto em agosto de 2026 e não substitui
> parecer jurídico.

---

## Registro de alterações

| Data | O que mudou |
|---|---|
| 25/08/2026 | Documento criado a partir do schema da Etapa 5 |
