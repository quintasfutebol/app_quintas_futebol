#!/bin/bash

set -e

THRESHOLD_FILE="coverage_threshold.txt"
COVERAGE_FILE="coverage/.last_run.json"

if [[ ! -f "$COVERAGE_FILE" ]]; then
  echo "❌ Coverage file not found. Run the tests first: bundle exec rspec"
  exit 1
fi

if [[ ! -f "$THRESHOLD_FILE" ]]; then
  echo "⚠️ Threshold file not found. Creating with current coverage."
  ACTUAL=$(jq '.result.line' "$COVERAGE_FILE")
  echo "$ACTUAL" > "$THRESHOLD_FILE"
  exit 0
fi

# Read values
ACTUAL=$(jq '.result.line' "$COVERAGE_FILE")
THRESHOLD=$(cat "$THRESHOLD_FILE")

# Normalize with 2 decimal places
ACTUAL_FLOAT=$(printf "%.2f" "$ACTUAL")
THRESHOLD_FLOAT=$(printf "%.2f" "$THRESHOLD")

echo "🔎 Current coverage: $ACTUAL_FLOAT%"
echo "📊 Threshold stored: $THRESHOLD_FLOAT%"

COMPARE=$(echo "$ACTUAL_FLOAT >= $THRESHOLD_FLOAT" | bc)

if [[ "$COMPARE" -eq 1 ]]; then
  echo "$ACTUAL_FLOAT" > "$THRESHOLD_FILE"
  echo "✅ Threshold updated to $ACTUAL_FLOAT%"
  exit 0
else
  echo "🚫 Coverage is lower than threshold. File not updated."
  exit 1
fi