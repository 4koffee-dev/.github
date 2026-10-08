# .github

Repositório de padrões da organização 4koffee. O que está aqui vale para todos os repositórios da organização, sem precisar copiar nada para cada projeto.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Como trabalhamos: nomes de repositório, branches, commits, revisão e cuidados com segredos |
| [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md) | Texto inicial de todo pull request |
| [ISSUE_TEMPLATE/](ISSUE_TEMPLATE) | Modelos de issue: bug, funcionalidade e tarefa |
| [SECURITY.md](SECURITY.md) | Como relatar uma vulnerabilidade |
| [profile/README.md](profile/README.md) | Texto da página pública da organização |
| [scripts/novo-repo.sh](scripts/novo-repo.sh) | Cria um repositório novo já configurado |

O GitHub aplica o CONTRIBUTING, o SECURITY e os modelos de issue e de pull request a qualquer repositório da organização que não tenha o seu próprio. Se um projeto precisar de um modelo diferente, basta criar o arquivo no repositório dele.

## Criar um repositório novo

Só os Owners da organização criam repositórios. É preciso ter o [gh CLI](https://cli.github.com/) autenticado com a conta que é Owner.

```bash
./scripts/novo-repo.sh nome-do-repositorio "Descrição curta"
```

O script:

1. cria o repositório privado a partir do [template-projeto](https://github.com/4koffee-dev/template-projeto);
2. configura o merge: merge commit como padrão, squash disponível, rebase desligado e exclusão da branch após o merge;
3. liga os alertas do Dependabot;
4. aplica as labels padrão da 4koffee.

O nome segue a regra do CONTRIBUTING: minúsculas com hífen, `cliente-projeto` para trabalho de cliente e `interno-nome` para projetos próprios.

Depois de criar, siga o checklist "Ao iniciar um projeto" do README do repositório novo.

## Mudar um padrão

A `main` deste repositório é protegida: toda mudança entra por pull request. Como os arquivos valem para a organização inteira, combine a mudança com os outros sócios antes de abrir o PR.

Este repositório é público porque o GitHub só usa a página de perfil e os arquivos padrão de um `.github` público. Não coloque aqui nada que seja interno ou de cliente.
