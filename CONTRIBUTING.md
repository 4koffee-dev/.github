# Como trabalhamos na 4koffee

Estes padrões valem para todos os repositórios da organização.

## Nomes de repositório

- Sempre em minúsculas, com hífen.
- Trabalho de cliente: `cliente-projeto` (ex.: `acme-portal`).
- Projetos próprios: `interno-nome`.
- Repositórios novos nascem privados e a partir do `template-projeto`.

## Fluxo de trabalho

1. A `main` sempre funciona. Ninguém faz commit direto nela.
2. Cada tarefa é uma branch curta, criada a partir da `main`:
   - `feat/descricao-curta` para funcionalidades
   - `fix/descricao-curta` para correções
   - `chore/descricao-curta` para manutenção
3. A branch entra por pull request, com revisão de pelo menos um outro sócio.
4. O merge é sempre por squash, e a branch é apagada depois.

No plano gratuito o GitHub não bloqueia push direto na `main` de repositórios privados. A regra acima é um combinado entre nós.

## Commits

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/). Como o merge é por squash, o título do pull request vira o commit na `main`, então é ele que precisa seguir o padrão:

```
tipo(escopo opcional): descrição no imperativo, em minúsculas
```

Tipos aceitos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `build`, `ci`, `revert`.

Exemplos:

- `feat: cadastro de clientes`
- `fix(login): corrige redirecionamento após expirar a sessão`
- `docs: atualiza instruções de deploy`

## Revisão de código

- Quem abre o PR explica o que mudou e como testar.
- Quem revisa roda ou lê o código com atenção, e aprova ou pede ajustes em até um dia útil.
- PRs pequenos são revisados mais rápido. Prefira vários PRs curtos a um grande.

## Segredos e dados de cliente

- Nunca versionar senhas, chaves, tokens ou arquivos `.env`.
- Dados reais de cliente não entram em repositório, nem em testes.
