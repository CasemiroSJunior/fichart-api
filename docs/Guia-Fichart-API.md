# Guia do Projeto — fichart-api

> Documento de referência e continuidade do backend do **fichart**.
> Serve para três coisas: revisar o que já foi construído, saber o que vem pela frente,
> e dar contexto a outra pessoa (ou a outra IA) sem precisar recontar a história.
>
> **Última atualização:** 25/08/2026 — fim da Etapa 5.6 (modelagem completa do SRD 5.1).
> **Repositório:** https://github.com/CasemiroSJunior/fichart-api
>
> **Documentos irmãos:** [`Modelagem-SRD.md`](./Modelagem-SRD.md) (as decisões de modelagem e o
> plano de importação) · [`NOTICE.md`](../NOTICE.md) (licenças e atribuição) ·
> [`ERD.md`](./ERD.md) (DER gerado) · [`Conformidade-LGPD.md`](./Conformidade-LGPD.md)

---

## 0. Como usar este documento

**Se você é o Casemiro, retomando o trabalho:** vá direto para a [Trilha](#7-trilha--o-que-já-foi-feito) e ache onde parou. A seção [Armadilhas](#10-armadilhas-já-vividas) é o lugar de procurar **antes** de pesquisar na internet — todo problema listado ali já aconteceu neste projeto.

**Se você vai pedir ajuda a uma IA:** copie o bloco da seção [14](#14-prompt-para-dar-contexto-a-outra-ia) e cole no início da conversa. Ele carrega o contexto mínimo para a assistente não sugerir coisas que já foram descartadas.

**Se você é outra pessoa do grupo:** leia as seções 2, 3 e 11. Elas explicam o que o projeto é e quais regras o código segue.

**Mantenha este arquivo vivo.** Toda dúvida que surgir vai para a seção 13. Toda armadilha nova vai para a seção 10. Um guia que para de ser atualizado vira folclore.

---

## 1. O projeto em uma página

**Fichart** é um sistema de criação e gestão de fichas de personagem de **D&D 5ª edição**. A versão original era um wizard web de 5 etapas feito em Django. Esta é a reconstrução do zero, agora como **API REST independente**, porque o projeto passou a exigir vários clientes:

```
      ┌──────────┐   ┌──────────┐   ┌───────────────┐
      │  Mobile  │   │   Web    │   │Desktop / Bot  │
      └────┬─────┘   └────┬─────┘   └───────┬───────┘
           └──────────────┼─────────────────┘
                          ▼
                ┌───────────────────┐
                │  fichart-api      │  ← a regra de negócio mora AQUI
                └─────────┬─────────┘
                          ▼
                     PostgreSQL
```

A regra existe **em um lugar só**. Se a validação de uma etapa do wizard mudar, muda no servidor e todos os clientes obedecem no mesmo instante.

**Objetivo paralelo:** aprender TypeScript e a stack Node moderna com rigor. Por isso o projeto usa modo estrito, linter opinativo e revisão de Clean Code — o aprendizado é parte do entregável.

---

## 2. Decisões tomadas

Cada uma tem uma razão. Antes de mudar qualquer linha desta tabela, leia a razão.

| Tema | Decisão | Por quê |
|---|---|---|
| Arquitetura | API REST separada do front | Três ou mais clientes consumindo a mesma regra |
| Runtime | Node 24 LTS | LTS ativo; ímpares (25) são experimentais |
| Framework | Fastify | Expõe o TypeScript em vez de escondê-lo atrás de decorators |
| ORM | Prisma | Cliente tipado gerado do schema + gerador de DER |
| Banco | PostgreSQL 17 | Relacional de verdade; versão fixa para reprodutibilidade |
| Validação | Zod *(a implementar)* | TypeScript não valida dado externo em runtime |
| Lint/format | Biome | Um binário faz o papel de ESLint + Prettier |
| Idioma do código | **Inglês**, incluindo comentários | O SRD de D&D 5e é a fonte primária; APIs públicas de SRD usam os termos em inglês |
| IDs | UUIDv7 | Evita enumeração de registros via URL pública; v7 é ordenado por tempo |
| Exclusão | Soft delete (`deletedAt`) | Fichas e usuários nunca somem; conta pode ser reativada |
| Dinheiro | Inteiro em centavos | Ponto flutuante binário não representa `0.1` exatamente |
| Nomes no banco | `camelCase` no código, `snake_case` na tabela | Postgres rebaixa identificadores sem aspas para minúsculas |
| Docker em dev | Só o banco em container; app na máquina | Menos atrito enquanto se aprende; hot reload instantâneo |
| Commits | Conventional Commits | Histórico legível e é o que o mercado espera |
| Dados do SRD | **Cópia local** em `prisma/seed/data/`, do `5e-bits/5e-database` (commit fixo) | Depender da API pública de terceiro em tempo de seed torna a carga irreprodutível e refém do uptime alheio. Commit fixo = mesmo dado hoje e daqui a um ano |
| Licença dos dados | **CC-BY-4.0** (Wizards of the Coast), **não** OGL 1.0a | O SRD 5.1 é oferecido sob as duas; a OGL proibiria coisas que este projeto prevê. O código é MIT; os dados **não** são. Atribuição obrigatória em toda resposta de catálogo — ver [`NOTICE.md`](../NOTICE.md) |
| Wizard de 5 etapas | **Duas entidades**: `CharacterDraft` (tudo anulável, descartável) e `Character` (`NOT NULL` de verdade) | Uma tabela só com flag `isComplete` obriga `raceId` a ser anulável — o **banco** deixa de conseguir afirmar que uma ficha pronta tem raça, e todo consumidor reprova isso para sempre |
| Multiclasse | Modelado **agora**, via `CharacterClassLevel`; `Character.level` não existe | Retroajustar depois significa migrar toda ficha e reescrever toda regra que lê nível. O caso simples custa uma linha |
| Mesa de jogo | `Campaign` + `CampaignMember(role GM\|PLAYER)`; `Character.campaignId` **anulável** | A ficha existe antes da mesa e sobrevive ao fim dela |
| Visibilidade de conteúdo | `source` (SRD\|HOMEBREW) **e** `visibility` (PRIVATE\|CAMPAIGN\|PUBLIC), sem `@default` | Duas perguntas diferentes. Sem default, seed e rota de autoria são **obrigados** a se pronunciar — default `PRIVATE` esconde o SRD, default `PUBLIC` publica homebrew por esquecimento |
| Visibilidade de ficha | Enum **separado** `SheetVisibility` | `PRIVATE` numa ficha é "o dono **e o mestre**"; numa linha de catálogo é só o dono. Um enum com valor que significa duas coisas é a ambiguidade que o schema recusa |
| Customização | **Clonar**, nunca remendar. Linha com `source = SRD` é imutável | Uma ficha construída há um ano tem que resolver para o mesmo texto de regra. O cosmético fica na instância (`InventoryItem.customName`), o mecânico na definição |

### Decisões pendentes

- Autenticação: JWT próprio × biblioteca (`better-auth`) — **decidir na Etapa 9**
- Hospedagem do banco e da API em produção — **decidir na Etapa 13**
- Se o front web será consumido do mesmo repositório ou separado — **do grupo**
- As 8 perguntas de produto da matriz de autorização (mestre edita ficha? prosa pessoal tem
  visibilidade separada? homebrew publica em duas mesas?) — ver
  [`Modelagem-SRD.md` §5.3](./Modelagem-SRD.md#53-o-que-ainda-depende-de-decisão-do-usuário)

---

## 3. Stack e ambiente

### Versões travadas (24/08/2026)

| Peça | Versão |
|---|---|
| Node | 24.9.0 (via NVM) |
| npm | 11.6.0 |
| Docker | 28.3.2 |
| TypeScript | 7.0.2 |
| Fastify | 5.12.1 |
| Prisma CLI + Client | **7.9.1 — os dois na mesma versão, sempre** |
| Biome | 2.5.10 |
| PostgreSQL | 17-alpine |

> ⚠️ `prisma` e `@prisma/client` são duas metades da mesma ferramenta. Se as versões divergirem, o projeto quebra de formas que não parecem ter relação com versão. Instale sempre juntos e com a versão explícita.

### Requisitos da máquina

- **NVM** com Node 24 ativo (`nvm use 24`; no Windows exige terminal como Administrador)
- **Docker Desktop** — precisa estar **aberto**, não só instalado
- **VS Code** com as extensões **Biome** (`biomejs.biome`) e **Prisma**

### Subindo o projeto do zero

```bash
git clone https://github.com/CasemiroSJunior/fichart-api.git
cd fichart-api
npm ci
```

Copie `.env.example` para `.env` e preencha. Gere uma senha forte com:

```bash
node -e "console.log(require('crypto').randomBytes(24).toString('base64url'))"
```

> Use `base64url` e não `base64`: ele só produz caracteres seguros para URL, e a senha vai dentro da `DATABASE_URL`.

```bash
docker compose up -d
npx prisma migrate dev
npm run dev
```

Confirme em `http://localhost:3000/health`.

---

## 4. Estrutura do projeto

```
fichart-api/
├── .env                  ← segredos (NUNCA vai para o Git)
├── .env.example          ← as mesmas chaves, sem valores (VAI para o Git)
├── .gitattributes        ← normaliza fim de linha para LF
├── .gitignore
├── biome.json            ← formatação + lint
├── docker-compose.yml    ← Postgres
├── prisma.config.ts      ← config do Prisma 7 (a DATABASE_URL mora aqui)
├── tsconfig.json
├── docs/
│   ├── ERD.md            ← DER gerado automaticamente do schema
│   └── Guia-Fichart-API.md
├── prisma/
│   ├── schema.prisma     ← a fonte da verdade do banco
│   └── migrations/       ← histórico versionado (VAI para o Git, nunca se edita)
└── src/
    ├── app.ts            ← monta o Fastify (não abre porta)
    └── server.ts         ← só chama listen()
```

### Estrutura-alvo (a partir da Etapa 6)

```
src/
├── config/               env.ts — variáveis validadas com Zod no boot
├── db/                   prisma.ts — instância única do client
├── modules/
│   └── characters/
│       ├── character.routes.ts      HTTP: parse, status. Zero regra.
│       ├── character.service.ts     Regra de negócio. Zero SQL, zero Fastify.
│       ├── character.repository.ts  Prisma. Zero regra.
│       ├── character.schema.ts      Zod (entrada e saída)
│       └── character.test.ts
├── shared/               erros, middlewares, tipos
├── app.ts
└── server.ts
```

**Por que `app.ts` é separado de `server.ts`:** os testes importam `createApp()` e disparam requisições **sem abrir porta**. Testes ficam rápidos e paralelizáveis. Duas linhas de decisão que viabilizam uma suíte de testes saudável.

**Por que rota → service → repository:** se `character.service.ts` importar algo do Fastify, algo está errado. E o filtro de soft delete (`where: { deletedAt: null }`) mora **só** no repository — esquecer esse filtro uma vez vaza dado apagado para a API, e a defesa contra isso é estrutural, não disciplinar.

---

## 5. Comandos do dia a dia

### Aplicação

| Comando | O que faz |
|---|---|
| `npm run dev` | Sobe com hot reload. É o comando do dia a dia. |
| `npm run typecheck` | Verifica tipos sem gerar arquivo. **Diz a verdade sobre a saúde do projeto.** |
| `npm run lint` | Biome: padrões e riscos |
| `npm run format` | Biome: formatação |
| `npm run fix` | Biome: corrige o que dá para corrigir sozinho |
| `npm run verify` | `typecheck` + `lint`. **Rode antes de todo commit.** |
| `npm run build` | Gera `dist/` |
| `npm start` | Roda o `dist/` com Node puro |

> `npm run dev` funcionar **não** significa projeto são: o `tsx` roda mesmo com erro de tipo. Quem diz a verdade é o `npm run verify`.

### Banco

| Comando | O que faz |
|---|---|
| `npm run db:migrate` | Cria e aplica migration |
| `npm run db:studio` | Interface web em `localhost:5555` |
| `npm run db:generate` | Regenera o Prisma Client |
| `npm run db:reset` | ⚠️ Apaga tudo e roda as migrations do zero |

### Docker

| Comando | Container | Dados |
|---|---|---|
| `docker compose up -d` | sobe | — |
| `docker compose ps` | status (espere `Up (healthy)`) | — |
| `docker compose logs db` | logs do Postgres | — |
| `docker compose stop` | pausa | ✅ intactos |
| `docker compose down` | destrói | ✅ intactos |
| `docker compose down -v` | destrói | ❌ **apagados** |

Entrar no banco:

```bash
docker compose exec db psql -U fichart -d fichart
```

Dentro do `psql`: `\l` bancos · `\dt` tabelas · `\d nome` descreve · `\q` sai.

---

## 6. Modelo de dados atual

**81 modelos, 40 enums.** O SRD 5.1 inteiro (menos monstros e regras) está modelado.

> 📘 **A explicação completa — decisões difíceis, alternativas descartadas, matriz de
> autorização, plano de importação com as contagens esperadas — está em
> [`docs/Modelagem-SRD.md`](./Modelagem-SRD.md).** Esta seção é só o mapa.
>
> A **fonte da verdade** é [`prisma/schema.prisma`](../prisma/schema.prisma), que carrega a
> justificativa de cada decisão em comentário `///` no lugar onde ela vale. O DER completo,
> gerado automaticamente, fica em [`docs/ERD.md`](./ERD.md).

| Bloco | Modelos | O que guarda |
|---|---:|---|
| **Catálogo SRD** | 59 | Vocabulário base (8), motor de escolhas (4), equipamento (10), magias (4), classes (17), raças (9), antecedentes e talentos (6), i18n (1) |
| **Personagem** | 17 | A ficha, o rascunho do wizard, e todo o estado mutável de sessão |
| **Campanha** | 2 | `Campaign` + `CampaignMember` |
| **Conta** | 3 | `User` + `UserCredential` + `Payment` |

As sete tabelas da Etapa 5 continuam lá — `User`, `Character`, `Race`, `Subrace`,
`CharacterClass`, `Background`, `Language`, `Payment` — mas nenhuma delas está como estava:
`Character.level` **deixou de existir** (é a soma de `CharacterClassLevel`), o `passwordHash`
saiu de `User` para `UserCredential`, a N:N implícita `Character ↔ Language` virou
`CharacterLanguage` explícita com `origin`, e todo catálogo ganhou `srdIndex` + `source`.

### Padrões de modelagem presentes

- **1:1 opcional como afirmação** — `Item` + `WeaponDetail`/`ArmorDetail`/`VehicleDetail`/
  `MagicItemDetail`. "Isto é uma arma" é a **linha existir**, não um booleano que pode discordar
  dos dados ao lado.
- **Arco exclusivo** — uma coluna por tipo de alvo, todas anuláveis, com um discriminador enum e
  um `CHECK (num_nonnulls(...) = 1)`. Usado em `Proficiency`, `OptionChoice`,
  `ChoiceOptionReference`, `CharacterFeature`, `CharacterResourceUsage`, `RaceTraitGrant`,
  `AbilityBonusGrant`.
- **FK composta para fechar estado impossível** — `Character → CampaignMember(campaignId, userId)`
  impede ficha numa mesa que o dono nunca entrou; `→ Subclass(id, characterClassId)` impede
  bárbaro com o Domínio da Vida; `→ ChoiceOption(id, choiceId)` impede resposta tirada da lista de
  outra pergunta.
- **`Json` onde o dado é genuinamente heterogêneo** — `ClassLevel.classSpecific` (32 chaves
  distintas, três convenções numéricas), validado por Zod **no ponto de leitura**, não no banco.
- **Recursão real** — `OptionChoice ↔ ChoiceOption` com profundidade 3 no equipamento inicial do
  guerreiro.
- **Soft delete + `onDelete: Restrict`** em toda FK de dono. O padrão do Prisma para relação
  opcional é `SET NULL`, e `owner_id IS NULL` significa "SRD, público" — apagar uma conta
  **publicava** o homebrew privado de quem pediu para ser esquecido.

### O que é derivado e por isso **não** é coluna

Nível total, modificadores, bônus de proficiência, CA, iniciativa, CD de magia, percepção
passiva, capacidade de carga, PV máximo, espaços de magia de multiclasse. As fórmulas estão em
[`Modelagem-SRD.md` §6](./Modelagem-SRD.md#6-o-que-é-derivado-e-por-isso-não-está-no-banco).
Duas exceções, ambas documentadas onde vivem: `Character.armorClassOverride` e
`User.premiumUntil`.

### ⚠️ O schema está incompleto sem a migration crua

O Prisma não expressa `CHECK`, `UNIQUE … NULLS NOT DISTINCT`, índice único parcial, extensão nem
gatilho. Faltam **10 CHECKs, 5 uniques com `NULLS NOT DISTINCT`, 3 índices parciais,
`CREATE EXTENSION citext` e 2 gatilhos** — listados no cabeçalho do `schema.prisma` e em
[`Modelagem-SRD.md` §4.4](./Modelagem-SRD.md#44-a-dívida-que-fecha-a-conta-a-migration-crua).
**Enquanto isso não existir, vários comentários do schema descrevem uma garantia que o banco não
faz.** As 4 migrations em `prisma/migrations/` ainda descrevem o schema antigo de 7 modelos:
`prisma migrate deploy` num banco limpo **não** produz o arquivo atual.

---

## 7. Trilha — o que já foi feito

### ✅ Etapa 1 — Ambiente
Node via NVM, `npm init`, `git init`, `.gitignore`.
**Conceitos:** Node é o runtime; npm é o gerenciador; `package.json` é a identidade do projeto; LTS é sempre versão par.

### ✅ Etapa 2 — TypeScript
`typescript`, `@types/node`, `tsx`; `tsconfig.json` estrito; scripts no `package.json`.
**Conceitos:** os tipos **desaparecem em runtime** — TS protege as fronteiras internas, e o dado externo precisa de validação em runtime (é o papel do Zod); `dependencies` × `devDependencies`; `package-lock.json` e `npm ci`; o `^` do semver.

### ✅ Etapa 3 — Primeiro servidor HTTP
Fastify, `createApp()` / `server.ts`, rota `GET /health`.
**Conceitos:** Node tem **uma thread** atendendo todos — por isso toda E/S é assíncrona e `await` libera a thread em vez de bloqueá-la; nunca fazer laço pesado de CPU num handler; `host: '0.0.0.0'` é obrigatório para funcionar dentro do Docker; `/health` é rota de produção, não exercício.

### ✅ Etapa 4 — Postgres no Docker
`docker-compose.yml` com volume, healthcheck e senha; `.env` e `.env.example`.
**Conceitos:** imagem está para container como classe está para objeto; container é descartável e o **volume** é o que sobrevive; `down` × `down -v`; healthcheck responde "aceita conexão?", não "o processo existe?"; as variáveis `POSTGRES_*` só valem na **primeira** inicialização do volume.

### ✅ Etapa 5 — Prisma e modelagem
Schema com 7 modelos, migrations versionadas, Prisma Studio, DER automático.
**Conceitos:** as quatro peças do Prisma (Schema, Migrate, Client, Studio); migration é **append-only** — nunca se edita nem se apaga uma já aplicada; **o Postgres não indexa chave estrangeira automaticamente**, então FK usada em filtro ou join precisa de `@@index` explícito; normalize o que varia e deixe plano o que é fixo pelo domínio (os seis atributos são seis colunas, não uma tabela).

### ✅ Etapa 5.5 — Revisão de Clean Code
Correções aplicadas ao schema após revisão.
**Conceitos:**
- Todo campo que identifica um registro para um humano é `@unique` **no banco** — validação só no código não é atômica
- **`passwordHash`, nunca `password`** — o nome errado convida ao erro, e o Prisma retorna todos os campos escalares por padrão
- **Não armazene o que pode ser derivado**: `premiumUntil` sozinho, sem `premiumActive` — duas fontes de verdade divergem
- **Booleano que carrega data escondida vira timestamp**: `deletedAt`, não `deleted`
- Nunca nomeie entidade com palavra da linguagem: `CharacterClass`, não `Class`
- Idempotência: referência externa de pagamento é `@unique`, porque gateways reenviam webhooks
- Formatação é trabalho de máquina — `biome` e `prisma format`, nunca à mão

### ✅ Etapa 5.6 — Modelagem completa do SRD 5.1
Download do `5e-bits/5e-database` em commit fixo (25 arquivos `en/`, 12 `pt-BR/`), `NOTICE.md`
com a atribuição CC-BY-4.0, e o schema indo de **7 para 81 modelos / 40 enums** em três passadas:
modelagem, proporcionalidade (118 → 76 modelos, sem perder um fato que o SRD publica) e correção
(quatro revisões adversariais — regras de 5e, modelagem relacional, convenções, segurança —
44 achados aceitos, 7 descartados). `prisma validate` limpo. **Nenhuma migration rodada.**
Documentado em [`docs/Modelagem-SRD.md`](./Modelagem-SRD.md).

**Conceitos:**
- **Meça antes de normalizar.** Seis tabelas EAV para os recursos por nível custavam ~1.369
  linhas para representar 247 objetos JSON — e a garantia que prometiam (tipagem por
  `valueKind`) **nenhuma constraint fazia**. Validação que ia acabar no service de qualquer
  jeito não justifica seis tabelas.
- **Um discriminador que já existe torna a tabela de vínculo redundante.** As 6 link tables de
  escolha eram `(ownerId, choiceId, anchor, sortOrder)` seis vezes, e o `anchor` já nomeava o
  dono. Pior: modelavam N:N sobre domínio 1:N.
- **No Postgres, `NULL` é distinto.** Um `@@unique` sobre colunas anuláveis **não protege nada** —
  precisa de `UNIQUE … NULLS NOT DISTINCT` (PG 15+).
- **O padrão do Prisma para FK opcional é `ON DELETE SET NULL`**, que não é "não cascateia": é
  "orfana em silêncio". Combinado com "dono nulo = conteúdo público", vira vazamento de dado
  privado.
- **O Prisma devolve todo escalar de um modelo incluído** quando a chamada não diz `select`. A
  defesa durável não é disciplina em cada repositório: é topologia — o segredo vai para uma
  tabela que nenhum `include` alcança.
- **`desc` é palavra totalmente reservada do Postgres.** O Prisma sempre cita identificadores, então
  a migration passa e o defeito fica invisível até você abrir o `psql`.
- **Duas colunas capazes de discordar sobre o mesmo fato é bug**, não redundância defensiva —
  vale para `isVariant` × `basedOnItemId`, para `premiumActive` × `premiumUntil` e para
  `Skill.abilityScoreId` × `Skill.ability`.
- **Coluna `NOT NULL` sem `@default` é ferramenta de projeto**: obriga todo escritor a se
  pronunciar, em vez de escolher um erro padrão para ele.

---

## 8. Trilha — o que vem

### ⬜ Etapa 5.7 — Migration crua e seed
Gerar a migration real (as 4 existentes descrevem o schema antigo), acrescentar à mão os 10
CHECKs, os 5 `UNIQUE … NULLS NOT DISTINCT`, os 3 índices únicos parciais, o
`CREATE EXTENSION citext` e os 2 gatilhos; depois implementar o seed nas 12 fases de
[`Modelagem-SRD.md` §7](./Modelagem-SRD.md#7-plano-de-importação), conferindo as **7.628 linhas
esperadas** em 59 tabelas.
**Atenção:** os CHECKs de visibilidade e o seed que escreve essas colunas têm que entrar na
**mesma release** — separados, um dos dois quebra. E o seed é `upsert` por `srdIndex`, nunca
`deleteMany` + `createMany`: as FKs de dono são `Restrict` de propósito.

### ⬜ Etapa 6 — Prisma Client no código
Instância única do client, `/health` verificando o banco, primeiro CRUD de `Character` em rota → service → repository.
**Vai aparecer:** o Prisma 7 exige um *driver adapter* (`@prisma/adapter-pg`); o `.env` **não é carregado sozinho** quando você roda `npm run dev` — hoje o `dotenv` só serve ao `prisma.config.ts`, que é ferramenta de CLI.

### ⬜ Etapa 7 — Zod
Validação da entrada HTTP e das variáveis de ambiente no boot.
**Fecha o arco da Etapa 2:** é aqui que o dado externo passa a ser verificado de verdade, e não só prometido pelo tipo.

### ⬜ Etapa 8 — Erros e respostas padronizadas
Classe de erro de domínio, handler global, formato único de resposta de erro, status HTTP corretos.
**Por que agora:** com três clientes diferentes, formato de erro inconsistente vira três tratamentos diferentes do mesmo problema.

### ⬜ Etapa 9 — Autenticação e autorização
Hash de senha (argon2), JWT, rotas protegidas, fluxo de **reativação de conta**, e o cuidado com enumeração de usuários.
**Fluxo de reativação já sustentado pelo schema:**
```
POST /v1/users { email, password }
  └─ findUnique({ where: { email } })
       ├─ não achou               → cria conta
       ├─ achou, deletedAt = null → 409 conflito
       └─ achou, deletedAt ≠ null → oferece reativação
```

### ⬜ Etapa 10 — Testes
Vitest, Supertest e **Testcontainers** (sobe um Postgres real e descartável durante o teste — sem mock e sem banco compartilhado sujo).

### ⬜ Etapa 11 — OpenAPI
`@fastify/swagger` gerando a documentação **a partir dos schemas Zod**. Com três clientes, isso deixa de ser luxo: é o contrato que evita integração por WhatsApp.

### ⬜ Etapa 12 — Docker de produção e CI
Dockerfile multi-stage, usuário não-root, `.dockerignore`, GitHub Actions rodando `npm run verify` e os testes em todo push.

### ⬜ Etapa 13 — Deploy
Hospedagem, variáveis de ambiente em produção, migrations em produção, monitoramento.

### Pendências transversais

- `/v1` nas rotas — **antes** de qualquer cliente publicar
- CORS (`@fastify/cors`) — o front web vai ser bloqueado pelo navegador sem isso
- Rate limiting nas rotas de autenticação **e no endpoint de entrada em campanha** (`inviteCode`
  é o único identificador enumerável do schema — todo o resto é UUIDv7)
- ~~Seed dos dados do SRD~~ → virou a **Etapa 5.7**, com plano em
  [`Modelagem-SRD.md` §7](./Modelagem-SRD.md#7-plano-de-importação)
- Atribuição CC-BY-4.0 nas respostas de catálogo (obrigação de licença, não enfeite — ver
  [`NOTICE.md`](../NOTICE.md) §1.2)
- Job que apaga de verdade contas com `deletedAt` > 6 semanas — e ele é uma **transação
  ordenada**, não um `DELETE FROM users`: toda FK de dono é `Restrict`, então o delete simples é
  recusado justamente para quem já criou personagem, campanha ou pagamento
- Transação de saída de campanha: gravar `leftAt`, anular `campaignId` das fichas daquele usuário
  naquela mesa, e rebaixar o conteúdo `CAMPAIGN` dele para `PRIVATE`
- `pino-pretty` para log legível em desenvolvimento
- README, LICENSE, `.vscode/settings.json`

---

## 9. Conceitos-chave

Referência rápida. Se algum destes ficou nebuloso, é o ponto para revisar.

**Os tipos do TypeScript não existem em runtime.** O compilador verifica, apaga as anotações e gera JavaScript comum. Consequência: dado que vem de requisição HTTP, arquivo ou banco não é verificado pelo TS — o tipo diz "eu prometi", não "isto foi conferido". Fronteira externa exige validação em runtime.

**`strict: true` não se desliga.** Sem ele você escreve JavaScript com enfeite.

**ESM: o `import` termina em `.js` mesmo apontando para um `.ts`.** O caminho se refere ao arquivo **compilado**. O TypeScript não reescreve caminhos, só apaga tipos.

**`async`/`await` não é paralelismo.** Node tem uma thread; `await` a libera para atender outros enquanto esta requisição espera. Esquecer o `await` devolve a `Promise` em vez do valor — e o TS costuma avisar, porque o tipo vira `Promise<T>`.

**`dependencies` × `devDependencies`.** Se é ferramenta para produzir código, é `-D`. Se roda quando um cliente faz requisição, é dependência normal.

**`npm ci` × `npm install`.** `install` pode atualizar versões; `ci` instala exatamente o `package-lock.json`. Em CI e Docker, sempre `ci`.

**O `^` protege pacote, não relação entre pacotes.** `^6.19.3` nunca sobe para 7 — e foi exatamente isso que deixou o CLI do Prisma no 6 com o client no 7.

**Volume é o que sobrevive.** Container é gado, não bicho de estimação: quando dá problema, joga fora e sobe outro.

**O Compose nomeia recursos pelo nome da pasta.** Renomeou a pasta → novo projeto → **novo volume vazio**.

**Migration é append-only.** Errou? A próxima corrige. Nunca edite nem apague uma já aplicada.

**Postgres não indexa FK automaticamente.** Com 50 linhas ninguém nota; com 500 mil a tela trava e o código está "certo".

**Dinheiro é inteiro em centavos.** `0.1 + 0.2 === 0.30000000000000004` em qualquer linguagem.

**Não guarde estado derivado.** Duas fontes de verdade não ficam sincronizadas — ficam divergentes, e quem descobre é o usuário.

**Soft delete tem três armadilhas:** (1) booleano perde a data, use timestamp; (2) o registro inativo continua ocupando o `@unique` — no nosso caso é intencional, é o que viabiliza a reativação; (3) toda consulta precisa filtrar, e por isso o filtro mora só no repository.

**Mensagem de erro descreve o sintoma no ponto onde o programa desistiu — quase nunca a causa.** "Authentication failed" do Prisma era incompatibilidade de versão.

**Para isolar a causa, teste a camada mais baixa primeiro.** Entre aplicação e banco há cinco camadas. Se o `psql` conecta com aquelas credenciais, o problema não é senha, nem rede, nem container.

**Quando o comportamento depende da máquina de quem executa, falta um arquivo no repositório.** `package-lock.json` (versões), `biome.json` (formatação), `.gitattributes` (fim de linha), `.env.example` (configuração), `docker-compose.yml` (serviços). "Na minha máquina funciona" é sempre um desses faltando.

---

## 10. Armadilhas já vividas

Todas aconteceram neste projeto. **Procure aqui antes de pesquisar na internet.**

### `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified`
**Docker Desktop não está aberto.** O `docker --version` funciona mesmo assim, porque responde pelo executável; qualquer comando que fale com o motor precisa do Desktop rodando.

### `nvm use` dá "access denied" no Windows
Ele altera um link simbólico em `C:\Program Files`. Abra o terminal **como Administrador**, rode, depois volte ao terminal normal.

### `TS2591: Cannot find name 'process'`
Falta `@types/node`. `npm install --save-dev @types/node`.
⚠️ **Não** adicione `"types": ["node"]` no tsconfig como "solução". Isso desliga a descoberta automática, e o próximo `@types/*` que você instalar será ignorado em silêncio.

### `TS5112: tsconfig.json is present but will not be loaded`
Você passou um arquivo na linha de comando (`tsc src/index.ts`), e isso faz o `tsc` **ignorar o tsconfig**. Rode `npx tsc` sozinho, sempre.

### Prisma: `P1012: Argument "url" is missing` ou `P1000: Authentication failed`
**Versões de `prisma` e `@prisma/client` divergentes.** No Prisma 7 a URL sai do `schema.prisma` e vai para o `prisma.config.ts`; no 6 é o contrário. Com o config presente, o CLI para de carregar o `.env` sozinho (`Prisma config detected, skipping environment variable loading`) e o `env("DATABASE_URL")` do schema resolve **vazio** — daí "autenticação falhou" com credenciais corretas.
**Correção:** `npm install --save-dev prisma@X` e `npm install @prisma/client@X`, mesma versão, e a URL só no `prisma.config.ts`.

### Postgres recusa a senha depois que você mudou o `.env`
As variáveis `POSTGRES_*` só têm efeito na **primeira** inicialização do volume. `docker compose down -v` e suba de novo.

### `git diff` mostra o arquivo inteiro alterado sem ninguém ter mexido
**Fim de linha (CRLF × LF).** Falta `.gitattributes` com `* text=auto eol=lf`, e depois `git add --renormalize .`.

### `npm audit` acusa "high" e manda rodar `--force`
Leia **o que ele vai instalar** antes. No nosso caso, `npm audit fix --force` faria downgrade do Prisma para 6.12.0 e reabriria o inferno de versões.
**Como avaliar:** está em `dependencies` ou `devDependencies`? Qual é a falha? Quem alimenta a função vulnerável? Existe atacante nessa história? A severidade é atribuída à biblioteca, sem contexto do seu projeto.
**Vulnerabilidade conhecida e aceita:** `deepmerge-ts` (3 high), transitiva de `prisma` (CLI, devDependency). A função vulnerável só processa o `prisma.config.ts` local e o pacote não vai para produção. Reavaliar quando o Prisma atualizar.

### `O sistema não pode encontrar o arquivo especificado` num comando com `<`
No `cmd.exe`, **aspas simples não agrupam** e `<` é operador de redirecionamento. Use **aspas duplas** — funcionam nos três shells do Windows.

### Container não sobe: "name is already in use"
`container_name: fichart-db` é fixo, então duas pastas de projeto disputam o mesmo nome. Derrube o outro primeiro.

### Commit saiu com o e-mail errado
`git config user.email` mostra o que vale **naquela pasta**. A configuração está em `~/.gitconfig` com `includeIf`, que carrega `~/.gitconfig-pessoal` para tudo dentro de `projetos/pessoal/`.
```bash
git log -1 --format="%an <%ae>"
```
⚠️ **Repositório pessoal criado fora de `projetos/pessoal/` volta a usar o e-mail da empresa, em silêncio.**

### Trabalho perdido ao trocar de máquina
`.git` **é** o projeto; o código na pasta é só o último frame. Ao mudar de máquina: `push` e `clone`, nunca copiar a pasta.

### `psql` responde `ERROR: syntax error at or near "desc"` numa coluna que existe
**`desc` é palavra TOTALMENTE reservada no Postgres**, ao lado de `ORDER`, `GROUP`, `TABLE` e
`USER` (Apêndice C do manual). O Prisma **sempre** cita identificadores, então a migration passa,
o client funciona e o defeito fica invisível — até a primeira vez que você abre o `psql` para
conferir alguma coisa, que neste projeto é o tempo todo.

```sql
SELECT name, desc FROM spells;              -- erro de sintaxe
SELECT name, "desc" FROM spells;            -- funciona, mas você precisa lembrar para sempre
```

**Correção adotada:** o campo Prisma continua `desc` (casa com a chave do JSON do SRD e lê bem
num `select`), mas a **coluna** é `description`, via `desc String[] @map("description")`. 18
ocorrências. É a única exceção de `@map` no projeto que não é conversão para snake_case.
⚠️ A armadilha maior é a classe do erro, não a palavra: **nomear coluna com reservada do banco**
é tão proibido quanto nomear classe com palavra da linguagem. Confira contra o Apêndice C, não
contra a memória.

### FK opcional sem `onDelete` explícito vira `SET NULL` — e pode publicar dado privado
O padrão do Prisma para relação **opcional** não é "não cascateia"; é `ON DELETE SET NULL`, que é
"orfana em silêncio". Combine isso com uma regra de negócio que lê ausência como significado e o
resultado é vazamento:

```prisma
ownerId String?
owner   User?   @relation(fields: [ownerId], references: [id])   // ← SET NULL implícito
```

Aqui, `owner_id IS NULL` está documentado como **"conteúdo do SRD, visível para todo mundo"**.
Então apagar de verdade uma conta — o job de purga de 6 semanas, que existe justamente para
atender quem pediu para ser esquecido — anulava o `owner_id` de todo o homebrew daquela pessoa,
e cada linha passava a ser lida como catálogo público. **A exclusão da conta publicava o conteúdo
privado dela.**

**Correção:** `onDelete: Restrict` **declarado**, em toda FK de dono. A purga falha alto em vez de
vazar baixo, o que obriga o offboarding a ser um passo explícito de transferência ou anonimização.
⚠️ Efeito colateral aceito: `DELETE FROM users` passa a ser recusado para qualquer pessoa que já
tenha criado personagem, campanha ou pagamento. A purga vira transação ordenada.
⚠️ Corolário: **nunca teste "é SRD?" perguntando `owner_id IS NULL`.** A coluna que responde é
`source`. Dono nulo deve ser lido como "o CHECK está quebrado".

### Unicidade de e-mail é sensível a maiúsculas no Postgres
`text` compara **byte a byte**. Com `email String @unique`, `casemiro@example.com` e
`Casemiro@example.com` são duas contas válidas e distintas: dá para registrar a variante de caixa
de um endereço já existente, e o fluxo de recuperação — `findUnique({ where: { email } })` —
resolve para a linha que estiver escrita idêntica. Fica genuinamente ambíguo qual conta recebe o
e-mail de reset, enquanto o suporte vê dois usuários visualmente iguais.

**Correção:** `email String @unique @db.Citext`, com `CREATE EXTENSION IF NOT EXISTS citext` **na
migration, antes de a coluna existir**.
⚠️ Segundo efeito na mesma coluna: o `@unique` **sobrevive ao soft delete**, de propósito — é o
que reserva o endereço durante as 6 semanas de recuperação. O preço é um **oráculo de
existência**: o cadastro responderia "já existe" para uma conta que sumiu. Por isso o endpoint de
cadastro tem que responder **igual** nos dois casos e mandar a decisão por e-mail.

### Soft delete sem índice torna a purga inexecutável
Todo modelo ganhou `deletedAt`, mas em nenhum deles `deleted_at` era a **coluna líder** de algum
índice — ele vinha atrás de `item_kind`, de `user_id`, de `owner_id`. E `users` não tinha índice
nenhum além da PK e do e-mail.

O job de retenção varre `WHERE deleted_at < now() - interval '6 weeks'`. Sem índice liderado por
essa coluna, ele faz **sequential scan em toda tabela que deveria limpar** — e o modo de falha
não é "fica lento": é o job ficar lento demais, ser desligado, e o dado pessoal simplesmente
**ficar**. Um requisito de privacidade que morre por causa de um plano de execução.

**Correção:** `@@index([deletedAt])` próprio em toda tabela com soft delete, e na migration crua
estreitar para índice parcial — que é uma fração do tamanho, porque a maioria esmagadora das
linhas tem `deleted_at IS NULL`:

```sql
CREATE INDEX ... ON items (deleted_at) WHERE deleted_at IS NOT NULL;
-- e o inverso para as telas de navegação:
CREATE INDEX ... ON items (visibility, deleted_at) WHERE deleted_at IS NULL;
```

⚠️ Lição geral: **um índice composto só serve à consulta cuja coluna líder ele tem.**
`@@index([itemKind, deletedAt])` não ajuda nada quem filtra só por `deletedAt`.

---

## 11. Convenções do projeto

**Idioma:** inglês em identificadores e comentários, incluindo os de domínio.

**Nomes:**
- Função é verbo em `camelCase` (`createApp`), classe e tipo em `PascalCase`, constante de módulo em `UPPER_SNAKE`
- Nunca nomear algo com palavra da linguagem: `Class`, `Function`, `Object`, `Type`, `Number`, `String`, `Map`, `Set`, `Error`
- Variável e função nunca diferem só por caixa (`app` × `App` é armadilha)

**Prisma:**
- Modelo no singular e `PascalCase`; tabela no plural e `snake_case`, via `@@map`
- Campo em `camelCase`; coluna em `snake_case`, via `@map`
- Toda FK usada em filtro ou join ganha `@@index`
- Comentário de documentação com `///` (aparece no autocomplete), não `//`

**Commits — Conventional Commits:**
```
feat:     recurso novo
fix:      correção
chore:    build, config, dependências
docs:     documentação
refactor: reestruturação sem mudar comportamento
test:     testes
```
Assunto curto, no imperativo, minúsculo, sem ponto final. Detalhe vai no corpo, depois de uma linha em branco.

**Antes de todo commit:**
```bash
npm run verify
```

**Nunca commitar:** `.env`, `node_modules/`, `dist/`, credencial em qualquer forma.
**Sempre commitar:** `package-lock.json`, `prisma/migrations/`, `.env.example`, `.gitattributes`.

---

## 12. Glossário do domínio (PT → EN)

Do `models.py` do projeto Django original para os nomes deste projeto. Traduzido para o **termo do SRD**, não literal.

| Django (PT) | Aqui (EN) | Observação |
|---|---|---|
| `Personagem` | `Character` | |
| `Classe` | `CharacterClass` | `Class` é palavra da linguagem |
| `Raca` / `Subraca` | `Race` / `Subrace` | |
| `Antecedente` | `Background` | termo do SRD |
| `Magia` | `Spell` | |
| `Truque` | `Cantrip` | termo do SRD, não "Trick" |
| `Arma` | `Weapon` | |
| `Propriedade` | `WeaponProperty` | mais específico que `Property` |
| `Armadura` / `TipoArmadura` | `Armor` / `ArmorType` | |
| `EquipamentoDeAventura` | `AdventuringGear` | termo do SRD |
| `ConjuntoEquipamento` | `EquipmentPack` | termo do SRD |
| `Ferramenta` | `Tool` | |
| `Idiomas` | `Language` | singular |
| `HabilidadeEspecial` | `Trait` | o SRD chama traços raciais de "Traits" |
| `IncrementoHabilidade` | `AbilityScoreIncrease` | |
| `Proficiencia` | `Proficiency` | |
| `ProficienciaSalvaguardas_Pericias` | `Skill` + `SavingThrow` | dois conceitos disfarçados de um |
| `Usuario` | `User` | |
| `Cobranca` | `Payment` | |

---

## 13. Dúvidas

### Já respondidas

<details>
<summary><b>Desenvolvo dentro do Docker ou na minha máquina?</b></summary>

Existem três níveis, e a escolha aqui foi o nível 1:

1. **Só as dependências em container** (escolhido) — banco no Docker, app na máquina. Hot reload instantâneo, debugger sem configuração, zero atrito. É o certo enquanto se está aprendendo: se o ambiente tiver atrito, cada erro fica ambíguo entre "meu tipo está errado" e "o container não recarregou".
2. **App também em container, com bind mount** — ambiente idêntico para todos, mas no Windows, com o código em `C:\Users\...`, o file watching através da fronteira Windows↔Linux é lento e às vezes não dispara.
3. **Nível 2 com o código dentro do WSL2** — todas as vantagens sem a dor de performance. É para onde migrar quando o projeto estiver de pé.

O Dockerfile de produção, porém, se escreve cedo (Etapa 12) — deixado para o fim, é sempre uma tarde perdida descobrindo dependência que só existia na sua máquina.
</details>

<details>
<summary><b>Login pelo navegador ou token no GitHub?</b></summary>

**Navegador (OAuth via Git Credential Manager)**, para trabalho na sua máquina. Você nunca manuseia o segredo — e segredo que você não vê é segredo que você não cola no lugar errado. O token renova sozinho e é revogável pela interface do GitHub.

**Token (PAT)** só quando não há navegador: servidor, CI/CD, GitHub Actions. Nesse caso use *fine-grained*, limitado ao repositório, com expiração — nunca um *classic* com escopo `repo` inteiro. E jamais coloque o token na URL do remote: ele fica em texto puro no `.git/config`.

⚠️ **A armadilha:** se o navegador estiver logado na conta da empresa, o GCM autoriza a conta da empresa, muitas vezes sem perguntar. Confira a conta antes de clicar em Authorize, ou use janela anônima.
</details>

<details>
<summary><b>Como commitar com o usuário pessoal numa máquina da empresa?</b></summary>

`includeIf` no `~/.gitconfig` — o Git carrega configurações diferentes conforme a pasta:

```ini
[includeIf "gitdir/i:C:/Users/usuario/projetos/pessoal/"]
	path = C:/Users/usuario/.gitconfig-pessoal
```

Três detalhes que fazem isso falhar em silêncio: a **barra final é obrigatória**; use **barras normais** mesmo no Windows; e `gitdir/i:` (com `/i`) para ignorar maiúsculas.

O Git lê de cima para baixo e **a última definição vence** — o `includeIf` precisa vir depois do `[user]` global.

**Identidade ≠ credencial.** `user.email` é o que fica gravado no commit; o Credential Manager é quem você é ao empurrar. São eixos independentes e podem estar errados separadamente.
</details>

<details>
<summary><b>Por que Fastify e não NestJS?</b></summary>

NestJS é o que mais aparece em vaga no Brasil, mas para **aprender TypeScript** ele atrapalha: decorators, injeção de dependência por metadata e `reflect-metadata` escondem a linguagem atrás do framework. Você aprende *NestJS*, não *TypeScript*.

Fastify + Zod obriga a entender generics, inferência, tipos utilitários e narrowing. Depois de alguns meses, NestJS se aprende em uma semana — o contrário não é verdade.
</details>

<details>
<summary><b>O que o Django dava que o Node não dá?</b></summary>

| Django dava | Aqui vem de |
|---|---|
| ORM + migrations | Prisma |
| Autenticação | `@fastify/jwt` ou `better-auth` |
| **Django Admin** | **não existe equivalente** |
| Forms / validação | Zod |
| Rotas | Fastify |

A linha do Admin é a que dói: não existe equivalente pronto. O **Prisma Studio** cobre a necessidade de *desenvolvimento*, mas não tem login, nem permissão, nem regra de negócio — **nunca exponha na internet**.

É troca consciente: você monta mais e entende cada peça. Para aprender, é melhor; para entregar em duas semanas, o Django ganhava.
</details>

<details>
<summary><b>Como estruturar o wizard de 5 etapas na API? Uma rota por etapa com rascunho salvo, ou uma única criação no final?</b></summary>

**Rascunho salvo, em uma entidade própria** — `CharacterDraft`, com **tudo anulável** e
`currentStep` para o cliente retomar exatamente onde o jogador parou, em vez de reprocessar
validação para adivinhar.

O ponto que decide não é a rota, é a **tabela**. As três opções eram:

1. **Criação única no final** — o jogador perde tudo ao fechar a aba, e o cliente vira dono de um
   estado grande e não validado.
2. **Uma tabela `characters` com flag `isComplete`** — parece econômico e é o pior dos três: para
   caber o rascunho, `raceId`, `backgroundId` e as habilidades precisam ser anuláveis. Aí o
   **banco deixa de conseguir afirmar** que uma ficha pronta tem raça, e todo service, toda query
   e todo cliente precisa reprovar isso para sempre. Um estado temporário enfraquece a entidade
   real permanentemente.
3. **Duas entidades** (escolhida).

Três razões, e a terceira é a que fecha:
- `characters` volta a ter `NOT NULL` que significam alguma coisa.
- **Ciclos de vida diferentes.** Rascunho é descartável — abandonado em dois cliques, apagado de
  verdade em 30 dias, e por isso **não tem `deletedAt`** (soft delete de lixo só guarda lixo).
  Personagem é soft-deleted e recuperável.
- **A validação roda uma vez, na transição.** "Crie o `Character` a partir deste draft" é um
  único lugar onde todas as regras são conferidas. Com a flag, elas se espalham por todo caminho
  de escrita.

O custo é uma função de mapeamento no fim do wizard. É barato pelo que compra.

⚠️ E o rascunho tem **três** tabelas, não um espelho das 17 do personagem: toda escolha do wizard
passa pelo mesmo motor de escolhas do catálogo, então `draftLanguages`, `draftProficiencies` e
`draftEquipment` seriam a mesma tabela com nomes diferentes.
</details>

<details>
<summary><b>Onde entra a regra do SRD (ex.: classe determina armaduras permitidas) — no `service` ou como constraint no banco?</b></summary>

**Nos dois, e o critério é o tipo da regra — não a preferência de quem escreve.**

| Vai para o **banco** | Vai para o **service** |
|---|---|
| Estado que **não pode existir**, em nenhuma circunstância | Regra que depende de **cálculo, contexto ou nível** |
| FK, `@@unique`, `CHECK`, FK **composta** | Aritmética de regra, agregação, ordem de eventos |
| Ex.: "esta subclasse pertence a esta classe" → FK composta `(id, characterClassId)` | Ex.: "você pode usar armadura pesada" → depende das proficiências efetivas de N fontes |
| Ex.: "a resposta veio da lista da pergunta" → FK composta `(id, choiceId)` | Ex.: "escolha exatamente 2" → `chooseCount` é conferido contando linhas |
| Ex.: "no máximo uma concentração" → índice único parcial | Ex.: "CD de magia" → derivado, nunca coluna |

**O teste prático:** se a regra violada produz uma linha que **nenhum caminho de código deveria
conseguir criar**, ela é do banco — porque o banco é o único lugar que vale para *todos* os
caminhos, incluindo o script de correção que alguém vai rodar às 2h da manhã. Se a regra depende
de somar, comparar níveis ou olhar o resto da ficha, ela é do service.

Dois exemplos reais desta rodada, que só ficaram claros quando o critério foi aplicado:

- `Character.campaignId` e `Character.userId` eram duas FKs soltas. `PATCH /characters/:id` com
  qualquer id de campanha punha a ficha na tela daquela mesa. Virou **FK composta** para
  `CampaignMember(campaignId, userId)`: o banco recusa. Nenhuma quantidade de validação em service
  fecha isso, porque basta um caminho esquecer.
- "Escolha exatamente N" **não** virou constraint. Postgres não expressa "no máximo N linhas por
  grupo" sem gatilho, e a regra é do domínio. Fica no service — mas a FK composta
  `(choiceOptionId, choiceId)` garante que as linhas contadas são pelo menos da pergunta certa.

⚠️ E há um terceiro lugar, que é o menos óbvio: **validação de `Json` com Zod no ponto de
leitura**. `ClassLevel.classSpecific` não tem constraint nenhuma no banco — e a versão
normalizada anterior, com seis tabelas, **também não tinha**. Zod por `valueKind` valida mais do
que a forma normalizada validava.
</details>

### Em aberto

*Preencha conforme surgirem. Formato sugerido:*

```markdown
<details>
<summary><b>A pergunta</b></summary>

**Contexto:** o que eu estava fazendo quando a dúvida apareceu
**O que tentei:**
**Resposta:** _(preencher)_
</details>
```

- [ ] Vale usar Testcontainers no CI, ou é lento demais para o GitHub Actions gratuito?
- [ ] Como versionar a API quando o app mobile já estiver publicado?
- [ ] O mestre pode **editar** a ficha do jogador, ou só ler? Se puder, falta trilha de auditoria — não existe modelo de audit log no schema.
- [ ] A prosa pessoal da ficha (`backstory`, `notes`, `flaws`) deveria ter visibilidade separada da mecânica? Hoje `sheetVisibility` é uma coluna só.
- [ ] Homebrew pode ser publicado em **mais de uma** mesa? Hoje não — `Item.campaignId` é uma campanha só, e a alternativa (N:N por catálogo) recriaria 6 tabelas de junção e quebraria a equivalência que fecha o vazamento de visibilidade.
- [ ] Existe papel de **administrador** da plataforma? Não existe no schema, e moderação de conteúdo `PUBLIC` não tem nenhuma tabela hoje.
- [ ] Autoria de homebrew é recurso **pago**? `User.premiumUntil` existe, mas nada amarra assinatura a permissão de escrita.
- [ ] Como servir a atribuição CC-BY-4.0 nas respostas de catálogo — header, envelope da resposta, ou rota `/legal`?
- [ ] Suportar o ruleset **2024** algum dia? Exigiria uma dimensão de versão em todo o catálogo.
- [ ] `Monsters.json` (334 linhas) entra em alguma versão? Precisa de chave sintética antes de qualquer seed idempotente — 841 ações e 551 habilidades sem `index` próprio.

---

## 14. Prompt para dar contexto a outra IA

Copie o bloco abaixo e cole no início da conversa.

```
Você é meu professor de backend. Estou aprendendo Node e TypeScript do zero,
vindo de Delphi 6/10 e Firebird (13 anos em sistemas legados de varejo/PDV).
Sei SQL e modelagem relacional bem; JavaScript e o ecossistema Node são novos para mim.

COMO EU QUERO QUE VOCÊ TRABALHE
- Baby steps: uma etapa por vez, e espere eu confirmar que funcionou antes de seguir.
- Explique o PORQUÊ de cada decisão, não só o comando. Analogias com Delphi/Firebird ajudam.
- Não escreva o código por mim: me instrua e explique. Eu digito.
- Pegue pesado em Clean Code. Quero revisão rigorosa, com o princípio por trás de cada achado.
- Se eu colar um erro, me ensine a LER a mensagem, não só a corrigir.
- Responda em português do Brasil. O código e os comentários são em inglês.

O PROJETO
fichart-api: API REST para fichas de personagem de D&D 5e. Backend separado,
consumido por clientes web, mobile e desktop/mensageria. Projeto de faculdade (FATEC)
e de portfólio. Reconstrução de um sistema Django antigo, com banco novo do zero.
Repositório: https://github.com/CasemiroSJunior/fichart-api

STACK (versões travadas)
Node 24.9 · TypeScript 7.0.2 · Fastify 5.12 · Prisma 7.9.1 (CLI e client na MESMA versão)
PostgreSQL 17-alpine em Docker · Biome 2.5.10 · tsx · Windows 11 + cmd/PowerShell

DECISÕES JÁ TOMADAS — não sugira mudar sem eu pedir
- Fastify (não NestJS): quero enxergar o TypeScript, não escondê-lo atrás de decorators
- Prisma (não Drizzle): pelo cliente tipado e pelo gerador de DER
- Identificadores e comentários em inglês
- IDs em UUIDv7; soft delete com `deletedAt DateTime?` (nunca booleano)
- Dinheiro e medida em INTEIRO na menor unidade: costCp (peças de cobre),
  weightCentiLb (libras x 100), amountMinorUnits (menor unidade da moeda)
- `camelCase` no código, `snake_case` nas tabelas (via @map/@@map)
- Nunca nomear com palavra reservada — nem da LINGUAGEM (CharacterClass, nunca Class)
  nem do POSTGRES (a coluna é `description`, porque `desc` é totalmente reservada)
- `source` é reservada no projeto para uma pergunta só: SRD ou HOMEBREW.
  Origem de concessão (raça/classe/talento) chama-se `origin`
- NÃO armazenar estado derivado. Nível total, modificadores, bônus de proficiência, CA,
  iniciativa, CD de magia, percepção passiva, capacidade de carga e PV máximo são
  calculados no service. Duas exceções documentadas: armorClassOverride e premiumUntil
- Toda FK usada em filtro ou join tem @@index explícito (o Postgres não indexa FK sozinho)
- Docker só para o banco em desenvolvimento; app roda na máquina
- Arquitetura: rota → service → repository (o filtro de soft delete mora só no repository)
- `app.ts` monta o Fastify e `server.ts` só chama listen(), para os testes não abrirem porta

DOMÍNIO — decisões de produto já fechadas
- Dados do SRD 5.1 copiados localmente (5e-bits/5e-database, commit fixo), sob CC-BY-4.0.
  Código é MIT; os dados NÃO são. Atribuição obrigatória nas respostas de catálogo
- Wizard de 5 etapas = DUAS entidades: CharacterDraft (tudo anulável, descartável, sem
  deletedAt) e Character (NOT NULL de verdade, criado só quando o wizard conclui)
- Multiclasse já modelado: CharacterClassLevel. Character.level NÃO existe (é a soma)
- Truque não é entidade separada: é Spell com level 0
- Customização é CLONAR, nunca remendar. Linha com source=SRD é imutável. Cosmético fica
  na instância (InventoryItem.customName), mecânico fica na definição
- Mesa: Campaign + CampaignMember(role GM|PLAYER). Character.campaignId é ANULÁVEL
- source (SRD|HOMEBREW) e visibility (PRIVATE|CAMPAIGN|PUBLIC) são perguntas diferentes, e
  visibility NÃO tem @default de propósito. SheetVisibility é um enum separado

ONDE ESTOU
Etapas 1 a 5.6 concluídas: ambiente, TypeScript estrito, Fastify com GET /health,
Postgres em Docker com volume e healthcheck, e o schema Prisma com **81 modelos e
40 enums** — o SRD 5.1 inteiro modelado, menos monstros e regras, que estão fora de
escopo por decisão. O schema passa em `prisma validate`.

⚠️ NADA DISSO ESTÁ NO BANCO AINDA. As 4 migrations em prisma/migrations/ descrevem o
schema ANTIGO de 7 modelos; `prisma migrate deploy` num banco limpo não produz o arquivo
atual. E o Prisma não expressa CHECK, UNIQUE NULLS NOT DISTINCT, índice único parcial,
extensão nem gatilho — faltam 10 CHECKs, 5 uniques, 3 índices parciais,
CREATE EXTENSION citext e 2 gatilhos, todos listados no cabeçalho do schema.prisma.

PRÓXIMA ETAPA
Etapa 5.7 — gerar a migration real, escrever à mão a parte que o Prisma não expressa, e
implementar o seed nas 12 fases documentadas (7.628 linhas em 59 tabelas, contagens
esperadas na documentação). O seed é upsert por srdIndex, NUNCA deleteMany+createMany:
as FKs de dono são onDelete: Restrict de propósito.
Depois, Etapa 6 — Prisma Client no código: instância única, /health verificando o banco,
primeiro CRUD de Character na estrutura rota → service → repository.
Atenção: o Prisma 7 exige driver adapter (@prisma/adapter-pg), e o .env NÃO é
carregado automaticamente pelo `npm run dev` (hoje o dotenv só serve ao prisma.config.ts).

Leia docs/Guia-Fichart-API.md para o contexto completo e as armadilhas que eu já enfrentei,
e docs/Modelagem-SRD.md para as decisões de modelagem e o plano de importação.
Comece me perguntando onde eu quero retomar.
```

> **Dica:** se a ferramenta permitir anexar arquivo, anexe este `.md` inteiro, o
> `docs/Modelagem-SRD.md` **e** o `prisma/schema.prisma`. O prompt acima é o resumo para
> quando só der para colar texto.
>
> ⚠️ O `schema.prisma` tem 4.724 linhas, a maior parte comentário `///` explicando o porquê
> de cada decisão. Se a ferramenta cortar o arquivo, anexe o `Modelagem-SRD.md` **primeiro**:
> ele é o resumo executivo do mesmo raciocínio.

---

## Registro de alterações

| Data | O que mudou |
|---|---|
| 24/08/2026 | Documento criado ao fim da Etapa 5 |
| 25/08/2026 | **Etapa 5.6 — modelagem completa do SRD 5.1.** Seção 2: acrescentadas 8 decisões (SRD copiado localmente com licença CC-BY-4.0, `CharacterDraft` separado de `Character`, multiclasse já modelado, campanha e visibilidade de conteúdo, `SheetVisibility` como enum próprio, customização por clone). Seção 6 reescrita para o estado novo (81 modelos / 40 enums) e apontando para o novo `docs/Modelagem-SRD.md`. Seção 7: registrada a Etapa 5.6 com 8 conceitos. Seção 8: criada a Etapa 5.7 (migration crua + seed) e atualizadas as pendências transversais. Seção 10: 4 armadilhas novas (`desc` é reservada do Postgres; FK opcional sem `onDelete` vira `SET NULL` e publica dado privado; unicidade de e-mail sensível a maiúsculas; soft delete sem índice torna a purga inexecutável). Seção 13: duas dúvidas movidas para "respondidas" (estrutura do wizard; regra no service × constraint no banco) e 8 novas em aberto. Seção 14: prompt atualizado para o estado novo. Documento novo: `docs/Modelagem-SRD.md`. |
