#!/bin/bash

set -e

echo "🔍 Running RSpec to check test coverage..."

# Executa os testes e captura cobertura gerada
bundle exec rspec > /dev/null

COVERAGE_FILE="coverage/.last_run.json"
THRESHOLD_FILE="coverage_threshold.txt"

if [[ ! -f "$COVERAGE_FILE" ]]; then
  echo "❌ Coverage report not found. Make sure SimpleCov is configured."
  exit 1
fi

ACTUAL=$(jq '.result.line' "$COVERAGE_FILE")
THRESHOLD=$(cat "$THRESHOLD_FILE")

echo "🔎 Coverage: $ACTUAL% (Threshold: $THRESHOLD%)"

# Remove casas decimais para comparação segura com bc
ACTUAL_FLOAT=$(printf "%.2f" "$ACTUAL")
THRESHOLD_FLOAT=$(printf "%.2f" "$THRESHOLD")

COMPARE=$(echo "$ACTUAL_FLOAT >= $THRESHOLD_FLOAT" | bc)

if [[ "$COMPARE" -eq 1 ]]; then
  echo "✅ Coverage is sufficient."
  exit 0
else
  echo "🚫 Coverage dropped below threshold! Push blocked."
  exit 1
fi