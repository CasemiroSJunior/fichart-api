# NOTICE — Atribuições e licenças de terceiros

Este arquivo cumpre as obrigações de atribuição que o **fichart-api** tem perante
terceiros. Ele é parte da distribuição: quem copiar, redistribuir ou hospedar este
repositório precisa manter este arquivo junto.

> **Escopo das licenças neste repositório**
>
> | O quê | Licença |
> |---|---|
> | Código-fonte do fichart-api (`src/`, `prisma/schema.prisma`, `prisma/migrations/`, scripts, configs) | MIT — veja [`LICENSE`](./LICENSE) |
> | Dados do SRD 5.1 em `prisma/seed/data/` | CC-BY-4.0 (Wizards of the Coast LLC) — veja abaixo |
> | Documentação em `docs/` e este NOTICE | MIT, salvo trechos citados de terceiros |
>
> O arquivo `LICENSE` cobre **apenas o código**. Ele não licencia os dados do SRD,
> que têm titular e licença próprios.

---

## 1. System Reference Document 5.1 (Wizards of the Coast LLC)

O `fichart-api` redistribui e adapta material do **System Reference Document 5.1**,
publicado pela Wizards of the Coast LLC em 27/01/2023 sob a licença
**Creative Commons Attribution 4.0 International (CC-BY-4.0)**.

O aviso de atribuição abaixo é reproduzido **literalmente e em inglês**, exatamente
como exigido pela página *Legal Information* do próprio SRD 5.1. Não traduza, não
reescreva e não abrevie este bloco.

<!-- BEGIN SRD 5.1 ATTRIBUTION — DO NOT TRANSLATE OR REWORD -->
> This work includes material taken from the System Reference Document 5.1
> ("SRD 5.1") by Wizards of the Coast LLC and available at
> https://dnd.wizards.com/resources/systems-reference-document. The SRD 5.1 is
> licensed under the Creative Commons Attribution 4.0 International License
> available at https://creativecommons.org/licenses/by/4.0/legalcode.
<!-- END SRD 5.1 ATTRIBUTION -->

**Aviso de isenção de garantias (CC-BY-4.0, art. 3(a)(1)(A)(iv)):**

<!-- BEGIN CC-BY-4.0 DISCLAIMER — DO NOT TRANSLATE OR REWORD -->
> Unless otherwise separately undertaken by the Licensor, to the extent possible,
> the Licensor offers the Licensed Material as-is and as-available, and makes no
> representations or warranties of any kind concerning the Licensed Material,
> whether express, implied, statutory, or other. This includes, without limitation,
> warranties of title, merchantability, fitness for a particular purpose,
> non-infringement, absence of latent or other defects, accuracy, or the presence
> or absence of errors, whether or not known or discoverable. Where disclaimers of
> warranties are not allowed in full or in part, this disclaimer may not apply to You.
>
> — Creative Commons Attribution 4.0 International Public License, Section 5(a).
<!-- END CC-BY-4.0 DISCLAIMER -->

### 1.1. Indicação de modificações (CC-BY-4.0, art. 3(a)(1)(B))

A CC-BY-4.0 obriga a **indicar que o material foi modificado** e a **preservar a
indicação de modificações anteriores**. O material do SRD 5.1 distribuído aqui
**não está no formato original** publicado pela Wizards of the Coast. Cadeia completa
de modificações:

1. **Wizards of the Coast LLC** publicou o SRD 5.1 como documento PDF em prosa,
   sob CC-BY-4.0.
2. **Contribuidores do projeto `5e-bits/5e-database`** converteram esse texto em
   arquivos JSON estruturados, normalizando nomes, criando chaves de índice
   (`index`), referências cruzadas (`url`) e agrupamentos por categoria. Um
   subconjunto foi **traduzido para português do Brasil** e teve unidades de medida
   convertidas do sistema imperial para o métrico (pés → metros, libras → quilos).
3. **O projeto fichart-api** copiou esses arquivos JSON sem editá-los à mão
   (veja [`prisma/seed/data/README.md`](./prisma/seed/data/README.md)) e, na etapa de
   *seed*, os transforma em um esquema relacional próprio: renomeia campos, separa
   entidades, converte custos para inteiros em peças de cobre (`costCp`) e pesos para
   centésimos de libra (`weightCentiLb`), e computa valores derivados em tempo de
   execução.

Nenhuma dessas modificações é endossada, revisada ou aprovada pela Wizards of the Coast.
Erros de conversão, tradução ou modelagem são responsabilidade do fichart-api e de
`5e-bits`, não da licenciante.

### 1.2. Direitos de banco de dados (CC-BY-4.0, art. 4)

O fichart-api carrega o conteúdo do SRD 5.1 para um banco PostgreSQL. A CC-BY-4.0
trata expressamente dessa hipótese no art. 4:

<!-- BEGIN CC-BY-4.0 §4 — VERBATIM -->
> Where the Licensed Rights include Sui Generis Database Rights that apply to Your use
> of the Licensed Material:
>
> a. for the avoidance of doubt, Section 2(a)(1) grants You the right to extract,
> reuse, reproduce, and Share all or a substantial portion of the contents of the
> database;
>
> b. if You include all or a substantial portion of the database contents in a database
> in which You have Sui Generis Database Rights, then the database in which You have
> Sui Generis Database Rights (but not its individual contents) is Adapted Material; and
>
> c. You must comply with the conditions in Section 3(a) if You Share all or a
> substantial portion of the contents of the database.
<!-- END CC-BY-4.0 §4 -->

Consequência prática para este projeto: a **estrutura** do banco do fichart-api
(o `schema.prisma`, as migrações, os índices, o modelo relacional) é obra própria e
está sob MIT; o **conteúdo** do SRD carregado nela continua sob CC-BY-4.0. Qualquer
resposta da API que devolva porção substancial desse conteúdo — o que inclui os
endpoints de catálogo — precisa carregar a atribuição do §1 deste arquivo. Veja a
recomendação de implementação em `prisma/seed/data/README.md`, §6.

### 1.3. Licença escolhida: CC-BY-4.0, não OGL 1.0a

O conteúdo do SRD 5.1 está disponível sob **duas** licenças alternativas: a
Open Game License 1.0a e a CC-BY-4.0. **O fichart-api opera exclusivamente sob a
CC-BY-4.0.**

O projeto **não aceita, não invoca e não redistribui** a Open Game License 1.0a.
Consequentemente, este repositório **não contém** cópia da OGL 1.0a nem a
declaração `Section 15 COPYRIGHT NOTICE` daquela licença — e isso é intencional,
não um esquecimento.

O fichart-api também **não** se apoia na *Wizards of the Coast Fan Content Policy* e
**não** exibe o aviso de *Fan Content*, porque aquela política proíbe a venda de
conteúdo e o projeto prevê assinatura paga.

---

## 2. 5e-bits/5e-database

Os arquivos JSON em `prisma/seed/data/` foram obtidos do repositório público
`5e-bits/5e-database`.

| Item | Valor |
|---|---|
| Repositório | https://github.com/5e-bits/5e-database |
| Commit de origem | `ce47a18dfeb3e41a1b2a2dfe00a25761c3c3a4f1` |
| Data do commit | 2026-08-24 |
| Caminhos copiados | `src/2014/en/` → `prisma/seed/data/en/` <br> `src/2014/pt-BR/` → `prisma/seed/data/pt-BR/` |
| Conjunto de regras | D&D 5e, ruleset 2014 (SRD 5.1) |
| Licença do repositório | MIT |
| Declaração de conteúdo do repositório | Open Game License 1.0a (veja §2.2) |

### 2.1. Licença MIT do 5e-bits/5e-database

Reproduzida literalmente, conforme exigido pela própria MIT:

<!-- BEGIN 5e-bits MIT LICENSE — VERBATIM -->
> MIT License
>
> Copyright (c) 2018-2020, Adrian Padua and Christopher Ward
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
<!-- END 5e-bits MIT LICENSE -->

### 2.2. Base jurídica para o conteúdo em inglês

O `README` do `5e-bits/5e-database` declara que o código é MIT e que *"the underlying
material is released using the Open Gaming License Version 1.0a"* — texto anterior a
27/01/2023, quando a Wizards ainda não havia liberado o SRD 5.1 sob Creative Commons.

Para o **material subjacente do SRD 5.1**, o fichart-api recebe a licença
**diretamente da Wizards of the Coast**, e não do `5e-bits`. É o que prevê a própria
CC-BY-4.0, art. 2(a)(5)(A):

<!-- BEGIN CC-BY-4.0 §2(a)(5)(A) — VERBATIM -->
> Every recipient of the Licensed Material automatically receives an offer from the
> Licensor to exercise the Licensed Rights under the terms and conditions of this
> Public License.
<!-- END CC-BY-4.0 §2(a)(5)(A) -->

Um redistribuidor intermediário não pode reduzir os direitos que a licenciante original
concedeu a todo mundo. Por isso a declaração de OGL feita pelo `5e-bits` não obriga o
fichart-api quanto ao conteúdo do SRD 5.1 em inglês.

### 2.3. Tradução pt-BR — atribuição adicional

Os arquivos em `prisma/seed/data/pt-BR/` **não são** material do SRD 5.1 no sentido
estrito. Eles são **obra derivada** ("Adapted Material", CC-BY-4.0 art. 1(a)): a
tradução para português e a conversão de unidades para o sistema métrico são
contribuição criativa autoral dos tradutores do `5e-bits`, e não da Wizards of the Coast.

Atribuição desse componente:

<!-- BEGIN 5e-bits pt-BR ATTRIBUTION — VERBATIM -->
> The Brazilian Portuguese (pt-BR) data files in `prisma/seed/data/pt-BR/` are a
> translation and metric-unit adaptation of the System Reference Document 5.1,
> produced by the contributors of the `5e-bits/5e-database` project
> (https://github.com/5e-bits/5e-database) and obtained from commit
> `ce47a18dfeb3e41a1b2a2dfe00a25761c3c3a4f1`. Copyright in the translated wording is
> held by those contributors; the underlying SRD 5.1 material remains
> © Wizards of the Coast LLC under CC-BY-4.0.
<!-- END 5e-bits pt-BR ATTRIBUTION -->

**Risco residual conhecido (único deste documento).** O `README` do `5e-bits`
qualifica o conteúdo como OGL 1.0a. Se essa declaração for lida como a licença de
saída da *tradução*, a redistribuição do subconjunto pt-BR estaria formalmente sob a
OGL 1.0a, e não sob a CC-BY-4.0. As leituras contrárias são fortes — a `LICENSE.md`
do repositório é MIT e cobre o repositório como um todo, e a menção à OGL é texto
legado de 2018–2020 — mas a ambiguidade existe. Enquanto ela não for resolvida pelo
upstream, este NOTICE atribui os arquivos pt-BR de forma explícita e separada, que é
a conduta exigida tanto pela CC-BY-4.0 quanto pela MIT quanto pela OGL 1.0a §15.
Nenhum outro componente do projeto depende dessa questão.

---

## 3. Marcas registradas

**A CC-BY-4.0 licencia direitos autorais. Não licencia marcas.** Texto literal da
licença, art. 2(b)(2):

<!-- BEGIN CC-BY-4.0 §2(b)(2) — VERBATIM -->
> Patent and trademark rights are not licensed under this Public License.
<!-- END CC-BY-4.0 §2(b)(2) -->

A licença também veda expressamente qualquer sugestão de endosso, no art. 2(a)(6):

<!-- BEGIN CC-BY-4.0 §2(a)(6) — VERBATIM -->
> No endorsement. Nothing in this Public License constitutes or may be construed as
> permission to assert or imply that You are, or that Your use of the Licensed Material
> is, connected with, or sponsored, endorsed, or granted official status by, the
> Licensor or others designated to receive attribution as provided in
> Section 3(a)(1)(A)(i).
<!-- END CC-BY-4.0 §2(a)(6) -->

Portanto:

- **DUNGEONS & DRAGONS**, **D&D**, **WIZARDS OF THE COAST**, o logotipo do dragão
  ampersand, a identidade visual dos livros, tipografia, capas, arte e demais marcas
  e elementos de *trade dress* são propriedade da Wizards of the Coast LLC e/ou de
  suas afiliadas. **Nada disso é licenciado ao fichart-api.**
- O fichart-api **não é** um produto oficial, licenciado, aprovado, endossado,
  patrocinado ou afiliado à Wizards of the Coast LLC, à Hasbro, Inc. ou a qualquer
  de suas subsidiárias.
- O fichart-api **não usa** logotipos, marcas figurativas, fontes proprietárias,
  arte ou qualquer elemento de identidade visual da Wizards of the Coast em seu
  produto, site, aplicativo, material de divulgação ou loja de aplicativos.
- **fichart** é o nome do produto. Ele não contém, imita ou sugere qualquer marca da
  Wizards of the Coast.

### 3.1. Como o projeto pode se referir ao jogo

A própria página *Legal Information* do SRD 5.1 autoriza, em texto literal, uma única
declaração de compatibilidade:

<!-- BEGIN SRD 5.1 COMPATIBILITY STATEMENT — VERBATIM -->
> Please do not include any other attribution regarding Wizards other than that
> provided above. You may, however, include a statement on your work that it is
> "compatible with fifth edition" or "5E compatible."
<!-- END SRD 5.1 COMPATIBILITY STATEMENT -->

**Formulações permitidas** (usar estas):

- `compatible with fifth edition`
- `5E compatible`
- `Compatível com a quinta edição` / `Compatível com 5E`
- `Construído sobre o System Reference Document 5.1, disponível sob CC-BY-4.0.`

**Formulações a evitar** (marca usada como identificação do produto, e não como
descrição de compatibilidade):

- `fichart — fichas de Dungeons & Dragons`
- `fichart D&D`, `D&D Character Sheet by fichart`
- `o app oficial de D&D`, `feito para D&D 5e`
- Qualquer uso de "D&D" ou "Dungeons & Dragons" em nome de produto, nome de domínio,
  nome de pacote npm, título de loja de aplicativos, handle de rede social, favicon
  ou logotipo.

O critério prático: a marca pode aparecer **como substantivo, no corpo do texto,
para descrever compatibilidade**, sem estilização e sem destaque maior que a marca
própria do projeto. Ela não pode aparecer **como adjetivo do produto** nem em posição
que sugira origem, patrocínio ou endosso.

---

## 4. Conteúdo fora do SRD 5.1

O SRD 5.1 é deliberadamente restrito. O fichart-api distribui **apenas** o que está
nele. Conteúdo de outros livros da Wizards of the Coast (Player's Handbook, Monster
Manual, Dungeon Master's Guide, Xanathar's, Tasha's, cenários de campanha, aventuras
publicadas) **permanece integralmente protegido por direito autoral** e não pode ser
copiado para este projeto por nenhuma via — nem pelo *seed*, nem por *homebrew* de
usuário, nem por importação.

O inventário exato do que existe em `prisma/seed/data/` está em
[`prisma/seed/data/README.md`](./prisma/seed/data/README.md), §3.

---

## 5. Conteúdo criado por usuários

Conteúdo autoral criado por usuários dentro do fichart-api (*homebrew*: itens, raças,
subclasses, magias e antecedentes próprios, com `source = HOMEBREW`) **não é** coberto
por este NOTICE. A titularidade permanece com quem criou. As regras de uso, licença
concedida à plataforma e o procedimento de notificação e remoção ficam nos Termos de
Uso do serviço, não neste arquivo.

---

## 6. Dependências de software

As dependências de runtime e desenvolvimento (Fastify, Prisma, TypeScript, Biome,
`@types/node`, tsx, dotenv e as respectivas árvores transitivas) mantêm suas próprias
licenças, declaradas em `package.json` e `package-lock.json` de cada pacote em
`node_modules/`. Nenhuma delas é redistribuída em forma de código-fonte neste
repositório.

---

*Última revisão deste NOTICE: 25/08/2026.*
