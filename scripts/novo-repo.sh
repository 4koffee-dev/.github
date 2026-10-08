#!/usr/bin/env bash
# Cria um repositório privado na 4koffee a partir do template-projeto e aplica
# as configurações que o GitHub não copia do template: merge, labels e alertas.
# Uso: ./scripts/novo-repo.sh nome-do-repositorio "Descrição curta"
set -euo pipefail

ORG="4koffee-dev"
TEMPLATE="$ORG/template-projeto"
NOME="${1:?Informe o nome do repositório (ex.: acme-portal)}"
DESCRICAO="${2:-}"
REPO="$ORG/$NOME"

if [[ ! "$NOME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Nome inválido: use minúsculas, números e hífen (ex.: acme-portal)." >&2
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

echo "Repositório pronto: https://github.com/$REPO"
