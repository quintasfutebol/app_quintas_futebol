#!/usr/bin/env bash

# Exemplo de uso:
# kamal secrets fetch --adapter ./kamal/secrets_adapter_google.sh --from "my-gcp-project" VAR1 VAR2

PROJECT_ID="$1"
shift

for VAR in "$@"; do
  VALUE=$(gcloud secrets versions access latest --secret="$VAR" --project="$PROJECT_ID" 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    echo "Erro ao buscar o segredo '$VAR'" >&2
    exit 1
  fi
  echo "export $VAR=$VALUE"
done