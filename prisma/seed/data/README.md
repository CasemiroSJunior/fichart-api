# `prisma/seed/data` — dados de origem do SRD 5.1

> ## ⚠️ NÃO EDITE ESTES ARQUIVOS À MÃO
>
> Todo arquivo `.json` desta pasta é **cópia byte a byte** de um repositório externo,
> fixada em um commit específico. Editar um deles quebra três coisas ao mesmo tempo:
>
> 1. **Reprodutibilidade.** Ninguém consegue mais reproduzir esta pasta a partir da
>    origem, e a próxima atualização sobrescreve a edição em silêncio.
> 2. **Conformidade de licença.** A CC-BY-4.0 (art. 3(a)(1)(B)) obriga a *indicar que
>    o material foi modificado*. Uma edição manual não declarada nos deixa fora de
>    conformidade.
> 3. **Rastreabilidade.** O `SOURCE_COMMIT.txt` passa a mentir sobre o conteúdo.
>
> **Correção de dado errado?** Faça no *seed* (`prisma/seed/`), como transformação
> explícita e comentada, ou abra issue em
> https://github.com/5e-bits/5e-database/issues. Nunca no `.json`.
>
> **Regra de conteúdo novo:** conteúdo que **não** está no SRD 5.1 nunca entra nesta
> pasta. Ele entra pelo caminho de *homebrew*, com `source = HOMEBREW` e dono
> identificado. Veja §5.

---

## 1. O que há aqui

```
prisma/seed/data/
├── README.md            ← este arquivo
├── SOURCE_COMMIT.txt    ← o commit exato de onde tudo veio
├── en/                  ← 25 arquivos, SRD 5.1 em inglês (completo)
└── pt-BR/               ← 12 arquivos, tradução parcial
```

São os dados de catálogo do **D&D 5e, ruleset 2014** — o conjunto coberto pelo
System Reference Document 5.1. É a matéria-prima do *seed*: raças, classes,
subclasses, magias, equipamento, monstros, condições, perícias e afins.

Formato: JSON, UTF-8 sem BOM, quebra de linha LF. O `.gitattributes` da raiz aplica
`* text=auto eol=lf`, que preserva isso corretamente.

## 2. De onde veio

| Item | Valor |
|---|---|
| Repositório | https://github.com/5e-bits/5e-database |
| Commit | `ce47a18dfeb3e41a1b2a2dfe00a25761c3c3a4f1` |
| Data do commit | 2026-08-24 |
| Origem em inglês | `src/2014/en/` → `en/` |
| Origem em português | `src/2014/pt-BR/` → `pt-BR/` |

O commit está registrado em `SOURCE_COMMIT.txt`. Esse arquivo é a fonte da verdade;
se ele e este README divergirem, o `SOURCE_COMMIT.txt` vence e este README está
desatualizado.

O repositório `5e-bits/5e-database` **não é** a fonte primária do conteúdo. Ele é uma
conversão para JSON do documento em prosa publicado pela Wizards of the Coast. A
fonte primária é o PDF do SRD 5.1 em
https://dnd.wizards.com/resources/systems-reference-document.

## 3. Inventário — e por que ele é tão pequeno

Contagem verificada nos arquivos desta pasta:

| Arquivo | Registros | Observação |
|---|---:|---|
| `Classes.json` | 12 | as 12 classes básicas |
| `Subclasses.json` | **12** | **exatamente uma por classe** |
| `Races.json` | 9 | |
| `Subraces.json` | **4** | só Anão da Colina, Elfo Alto, Halfling Pés-Leves, Gnomo das Rochas |
| `Backgrounds.json` | **1** | só Acólito |
| `Feats.json` | **1** | só Agarrador (*Grappler*) |
| `Spells.json` | 319 | |
| `Monsters.json` | 334 | |
| `Magic-Items.json` | 362 | |
| `Equipment.json` | 237 | |
| `Levels.json`, `Features.json`, `Traits.json`, `Proficiencies.json` | — | tabelas de apoio |
| `Rules.json`, `Rule-Sections.json` | — | texto de regra |

Os números destacados **não são bug nem download incompleto**. O SRD 5.1 é
deliberadamente enxuto: a Wizards liberou uma fatia mínima do sistema, o suficiente
para terceiros construírem produtos compatíveis, e reteve o resto.

**Não está no SRD e, portanto, não pode ser copiado de lugar nenhum para este
projeto:**

- Antecedentes do Player's Handbook além de Acólito (Charlatão, Criminoso, Herói do
  Povo, Nobre, Sábio, Soldado…).
- Talentos além de Agarrador (Alerta, Atacante Grande, Mestre em Armas, Sortudo,
  Observador, Combatente com Duas Armas…).
- Subclasses do PHB e posteriores: Caminho do Guerreiro Totêmico, Domínios de Clérigo
  que não o da Vida, Círculo da Lua, Mestre de Batalha, Cavaleiro Arcano, Patrulheiro
  Explorador, Ladino Assassino/Trapaceiro Arcano, Magia Selvagem, Corte de Fadas,
  Grande Antigo, e todas as escolas de mago exceto Evocação.
- Raças fora da lista de 9 e sub-raças fora da lista de 4 (Anão da Montanha, Elfo da
  Floresta, Drow, Halfling Robusto, Gnomo da Floresta, e todas as raças exóticas).
- Criaturas icônicas que são *Product Identity* da Wizards. Verificado como **ausente**
  desta pasta: **beholder, mind flayer (illithid), displacer beast, carrion crawler,
  umber hulk, yuan-ti, githyanki, githzerai, slaad, kuo-toa, intellect devourer**.
  Se algum desses aparecer aqui um dia, o dado veio de fonte errada e precisa ser
  removido.
- Cenários de campanha (Forgotten Realms, Ravenloft, Eberron, Dragonlance), panteões,
  divindades nomeadas, mapas, geografia, personagens e aventuras publicadas.
- Todo o conteúdo de Xanathar's, Tasha's, Mordenkainen's, Volo's e demais suplementos.
- Toda a arte, ilustração, diagramação, tipografia e identidade visual dos livros.
- O ruleset **2024** (SRD 5.2.1). Ele existe e também é CC-BY-4.0, mas é **outro
  documento**, com **outra atribuição** e outra modelagem. Migrar para ele é uma
  decisão de produto, não uma atualização de dados. Veja §7.

> **Regra prática:** se a informação não está em um arquivo desta pasta, ela não está
> no SRD. "Achei em outro site/API/wiki" não é fonte válida — a maioria desses sites
> republica conteúdo protegido.

## 4. Licença

Estes dados **não estão** sob a licença MIT do `LICENSE` da raiz. Aquela licença cobre
só o código.

O conteúdo do SRD 5.1 é da **Wizards of the Coast LLC**, sob
**Creative Commons Attribution 4.0 International (CC-BY-4.0)**. A atribuição literal
obrigatória, o aviso de isenção de garantias, a cadeia de modificações e o aviso de
marcas registradas estão em [`../../../NOTICE.md`](../../../NOTICE.md).

Resumo operacional:

- ✅ **Pode** usar, copiar, modificar e redistribuir.
- ✅ **Pode** usar comercialmente, inclusive por trás de assinatura paga.
- ✅ **Pode** relicenciar as adaptações próprias como quiser (a CC-BY-4.0 não tem
  cláusula *ShareAlike*).
- ❗ **Tem que** manter a atribuição do `NOTICE.md` e indicar que houve modificação.
- ❌ **Não pode** usar marcas, logos ou identidade visual da Wizards. A CC-BY-4.0
  licencia direito autoral, não marca (art. 2(b)(2)).
- ❌ **Não pode** sugerir endosso ou afiliação (art. 2(a)(6)).

Os arquivos de `pt-BR/` são **obra derivada** — tradução e conversão de unidades para o
sistema métrico feitas por contribuidores do `5e-bits`, não pela Wizards. Eles têm
atribuição própria e uma ressalva de licenciamento registrada no `NOTICE.md`, §2.3.

## 5. Homebrew não mora aqui

Conteúdo autoral de usuário nunca entra nesta pasta. Esta pasta é **imutável** e
representa exclusivamente o SRD 5.1 tal como publicado.

Homebrew entra pelo banco, em runtime, com:

- `source = HOMEBREW` (nunca `SRD`),
- `srdIndex = NULL`,
- `ownerId` preenchido com o usuário que criou,
- `basedOnItemId` apontando para o original quando for clone de uma definição do SRD.

Registros com `source = SRD` são **imutáveis** por decisão de produto: customizar é
clonar, nunca remendar. Isso não é só arquitetura — é o que mantém a fronteira
jurídica visível. Um registro `SRD` é rastreável até esta pasta e até a atribuição da
Wizards; um registro `HOMEBREW` é responsabilidade de quem o criou.

## 6. Como o seed deve tratar estes arquivos

- Ler, nunca escrever. O processo de *seed* é unidirecional.
- Usar `srdIndex` (o campo `index` do JSON) como chave de idempotência, com `upsert`.
  Rodar o seed duas vezes não pode duplicar nada.
- Carimbar todo registro criado a partir daqui com `source = SRD`.
- Converter unidades na entrada, não depois: custo → `costCp` (inteiro, peças de
  cobre); peso → `weightCentiLb` (inteiro, libras × 100). Os JSON de origem trazem
  valores em `gp`/`sp`/`cp` e libras; os de `pt-BR/` trazem metros e quilos — atenção
  redobrada ao ler os dois.
- Não persistir valor derivado. Modificador de atributo, bônus de proficiência, CA,
  iniciativa, CD de magia e percepção passiva são calculados na camada de *service*.
- **Atribuição na API:** todo endpoint que devolva porção substancial deste conteúdo
  deve carregar a atribuição. O caminho de menor atrito é um cabeçalho HTTP constante
  em toda resposta de catálogo, mais um campo no payload de erro/metadados:
  ```
  X-Attribution: This work includes material taken from the System Reference Document 5.1 ("SRD 5.1") by Wizards of the Coast LLC and available at https://dnd.wizards.com/resources/systems-reference-document. The SRD 5.1 is licensed under the Creative Commons Attribution 4.0 International License available at https://creativecommons.org/licenses/by/4.0/legalcode.
  ```
  Além disso, exponha um endpoint `GET /legal` (ou `/attribution`) devolvendo o
  conteúdo do `NOTICE.md`, e cite-o na descrição do OpenAPI. A CC-BY-4.0 art. 3(a)(2)
  aceita link para um recurso que contenha a informação exigida — o endpoint satisfaz
  isso e evita poluir cada payload.

## 7. Como reatualizar

Reatualizar é **substituir a pasta inteira** por uma nova cópia de um commit novo.
Não é aplicar patch.

```bash
# 1. Clone raso do upstream numa pasta temporária, fora do repositório.
git clone --depth 1 https://github.com/5e-bits/5e-database.git /tmp/5e-database
cd /tmp/5e-database

# 2. Anote o commit exato que você está levando.
git rev-parse HEAD

# 3. Volte ao fichart-api e troque o conteúdo.
cd /caminho/para/fichart-api
rm -f prisma/seed/data/en/*.json prisma/seed/data/pt-BR/*.json
cp /tmp/5e-database/src/2014/en/*.json    prisma/seed/data/en/
cp /tmp/5e-database/src/2014/pt-BR/*.json prisma/seed/data/pt-BR/

# 4. Grave o novo commit de origem.
git -C /tmp/5e-database rev-parse HEAD > prisma/seed/data/SOURCE_COMMIT.txt
```

Depois, obrigatoriamente:

1. **Revise o `git diff`.** Se surgirem raças, subclasses, antecedentes ou talentos
   novos, confira contra o inventário da §3 antes de aceitar. O upstream aceita
   contribuição da comunidade; conteúdo fora do SRD pode entrar lá por engano, e aí
   vira problema *nosso* ao redistribuir.
2. **Confirme que a pasta continua sendo do `src/2014/`.** O upstream também mantém
   `src/2024/`, que é o SRD 5.2.1 — outro documento, outra atribuição, outra
   modelagem. Misturar os dois é erro de licença **e** de regra de jogo.
3. **Atualize `NOTICE.md`, §2**, com o novo commit e a nova data.
4. **Atualize a tabela da §3 deste arquivo** se as contagens mudarem.
5. **Rode o seed em banco limpo** e confirme que o `upsert` por `srdIndex` não
   duplicou nada.
6. **Commit separado**, só com a atualização de dados, mensagem no padrão
   `chore(data): update SRD 5.1 dataset to 5e-bits@<sha-curto>`. Nunca misture
   atualização de dados com mudança de código.

## 8. Verificação rápida de integridade

```bash
# Conta registros por arquivo (compare com a tabela da §3).
python -c "import json,os,sys; [print(f, len(json.load(open(os.path.join(d,f), encoding='utf-8')))) for d in ['prisma/seed/data/en'] for f in sorted(os.listdir(d)) if f.endswith('.json')]"

# Garante que nenhuma criatura fora do SRD entrou no dataset.
python - <<'PY'
import json
banned = {"beholder","mind flayer","displacer beast","carrion crawler","umber hulk",
          "githyanki","githzerai","slaad","kuo-toa","intellect devourer"}
names = {m["name"].lower() for m in json.load(open("prisma/seed/data/en/Monsters.json", encoding="utf-8"))}
hits = banned & names
print("FALHA — conteudo fora do SRD:", hits) if hits else print("OK — nenhum conteudo fora do SRD")
PY
```

---

*Dúvidas de licenciamento: leia [`../../../NOTICE.md`](../../../NOTICE.md) antes de
qualquer outra coisa. Última revisão deste README: 25/08/2026.*
