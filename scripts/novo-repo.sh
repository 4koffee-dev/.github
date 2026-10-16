#!/usr/bin/env bash
# Cria um repositório privado na 4koffee a partir do template-projeto e aplica
# as configurações que o GitHub não copia do template: merge, labels, alertas
# e o quadro de tarefas com a automação de dependências.
#
# Uso:
#   ./scripts/novo-repo.sh nome-do-repositorio "Descrição curta" [--quadro N | --sem-quadro]
#
#   --quadro N     usa o quadro N já existente na organização (ex.: o repositório
#                  de operação de um projeto, que divide o quadro com o de código)
#   --sem-quadro   não liga o repositório a nenhum quadro
#   (sem opção)    cria um quadro novo "nome-do-repositorio — tarefas"
#
# A automação do quadro usa as variáveis de ambiente QUADRO_APP_CLIENT_ID e
# QUADRO_APP_CHAVE_ARQUIVO (combinadas entre os sócios). Sem elas, o
# repositório é criado e o script avisa o que falta.
set -euo pipefail

ORG="4koffee-dev"
TEMPLATE="$ORG/template-projeto"
NOME="${1:?Informe o nome do repositório (ex.: acme-portal)}"
DESCRICAO="${2:-}"
MODO_QUADRO="novo"
NUMERO_QUADRO=""
shift $(( $# >= 2 ? 2 : $# ))
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quadro) MODO_QUADRO="existente"; NUMERO_QUADRO="${2:?Informe o número do quadro}"; shift 2 ;;
    --sem-quadro) MODO_QUADRO="nenhum"; shift ;;
    *) echo "Opção desconhecida: $1" >&2; exit 1 ;;
  esac
done
REPO="$ORG/$NOME"

if [[ ! "$NOME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Nome inválido: use minúsculas, números e hífen (ex.: acme-portal)." >&2
  exit 1
fi
CHAVE="${QUADRO_APP_CHAVE_ARQUIVO:-}"
CHAVE="${CHAVE/#\~/$HOME}"
if [[ -n "$CHAVE" && ! -f "$CHAVE" ]]; then
  echo "Arquivo da chave do aplicativo não encontrado: $CHAVE" >&2
  exit 1
fi

gh repo create "$REPO" --private --template "$TEMPLATE" --description "$DESCRICAO"

# Merge commit como padrão, squash disponível, rebase desligado.
gh api -X PATCH "repos/$REPO" --silent \
  -F allow_merge_commit=true \
  -F allow_squash_merge=true \
  -F allow_rebase_merge=false \
  -F delete_branch_on_merge=true \
  -f merge_commit_title=PR_TITLE \
  -f merge_commit_message=PR_BODY \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY \
  -F has_wiki=false

gh api -X PUT "repos/$REPO/vulnerability-alerts" --silent

# Troca as labels padrão do GitHub pelas da 4koffee.
for label in enhancement documentation duplicate "good first issue" "help wanted" invalid question wontfix accessibility; do
  gh label delete "$label" --repo "$REPO" --yes 2>/dev/null || true
done
gh api "repos/$TEMPLATE/contents/scripts/labels.sh" -H "Accept: application/vnd.github.raw" | bash -s -- "$REPO"

# Quadro de tarefas.
if [[ "$MODO_QUADRO" == "novo" ]]; then
  NUMERO_QUADRO=$(gh project create --owner "$ORG" --title "$NOME — tarefas" --format json --jq '.number')
  CAMPO_STATUS=$(gh project field-list "$NUMERO_QUADRO" --owner "$ORG" --format json --jq '.fields[] | select(.name=="Status") | .id')
  gh api graphql --silent -f campo="$CAMPO_STATUS" -f query='
    mutation($campo: ID!) {
      updateProjectV2Field(input: { fieldId: $campo, singleSelectOptions: [
        { name: "A fazer",           color: GRAY,   description: "Com dependência ainda aberta" },
        { name: "Pronta para pegar", color: BLUE,   description: "Dependências concluídas; qualquer um pode pegar" },
        { name: "Em andamento",      color: YELLOW, description: "Tem responsável" },
        { name: "Em revisão",        color: ORANGE, description: "Pull request aberto, esperando outra pessoa" },
        { name: "Em homologação",    color: PURPLE, description: "Integrada e em homologação" },
        { name: "Concluída",         color: GREEN,  description: "Cumpre a definição de pronto" }
      ] }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } }
    }'
  echo "Quadro criado: https://github.com/orgs/$ORG/projects/$NUMERO_QUADRO"
fi
if [[ "$MODO_QUADRO" != "nenhum" ]]; then
  gh project link "$NUMERO_QUADRO" --owner "$ORG" --repo "$REPO"
  gh variable set QUADRO_PROJETO --repo "$REPO" --body "$NUMERO_QUADRO"
  if [[ -n "${QUADRO_APP_CLIENT_ID:-}" && -n "$CHAVE" ]]; then
    gh variable set QUADRO_APP_CLIENT_ID --repo "$REPO" --body "$QUADRO_APP_CLIENT_ID"
    gh secret set QUADRO_APP_CHAVE --repo "$REPO" < "$CHAVE"
    echo "Automação do quadro configurada."
  else
    echo "Atenção: informe QUADRO_APP_CLIENT_ID e QUADRO_APP_CHAVE_ARQUIVO para ligar a automação do quadro." >&2
  fi
fi

echo "Repositório pronto: https://github.com/$REPO"
