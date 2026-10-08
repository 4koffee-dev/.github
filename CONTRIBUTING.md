# Como trabalhamos na 4koffee

Estes padrões valem para todos os repositórios da organização.

## Nomes de repositório

- Sempre em minúsculas, com hífen.
- Trabalho de cliente: `cliente-projeto` (ex.: `acme-portal`).
- Projetos próprios: `interno-nome`.
- Repositórios novos nascem privados e a partir do `template-projeto`.
- Só os Owners da organização criam repositórios, sempre com `scripts/novo-repo.sh` deste repositório. O script cria o repositório a partir do template e aplica as configurações de merge e as labels, que o GitHub não copia do template.

## Fluxo de trabalho

1. A `main` sempre funciona. Ninguém faz commit direto nela.
2. Cada tarefa é uma branch curta, criada a partir da `main`:
   - `feat/descricao-curta` para funcionalidades
   - `fix/descricao-curta` para correções
   - `chore/descricao-curta` para manutenção
3. A branch entra por pull request, com revisão de pelo menos um outro sócio.
4. O merge padrão é por merge commit, que preserva os commits da branch. O squash fica disponível para quando os commits da branch não merecem ir para a `main`. A branch é apagada depois do merge.

No plano gratuito o GitHub não bloqueia push direto na `main` de repositórios privados. A regra acima é um combinado entre nós.

## Commits

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/). Como o merge preserva os commits da branch, o padrão vale para cada commit e também para o título do pull request, que vira o título do commit de merge na `main`:

```
tipo(escopo opcional): descrição no imperativo, em minúsculas
```

Tipos aceitos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `build`, `ci`, `revert`.

Exemplos:

- `feat: cadastro de clientes`
- `fix(login): corrige redirecionamento após expirar a sessão`
- `docs: atualiza instruções de deploy`

Cada commit deve ser uma mudança coesa, que faça sentido sozinha. Antes de abrir o PR, arrume commits como "wip" e "ajuste" com `git rebase -i`, ou faça o merge por squash.

O workflow `padrao-de-commits.yml` do `template-projeto` confere o título do PR e a mensagem de cada commit. Para ler a `main` uma entrega por linha, use `git log --first-parent`.

## Revisão de código

- Quem abre o PR explica o que mudou e como testar.
- Quem revisa roda ou lê o código com atenção, e aprova ou pede ajustes em até um dia útil.
- PRs pequenos são revisados mais rápido. Prefira vários PRs curtos a um grande.

## Segredos e dados de cliente

- Nunca versionar senhas, chaves, tokens ou arquivos `.env`.
- Dados reais de cliente não entram em repositório, nem em testes.
