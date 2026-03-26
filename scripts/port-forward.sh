#!/bin/bash
# ──────────────────────────────────────────────────────────────────
# port-forward.sh — Forward the Kubernetes service to localhost
#
# In GitHub Codespaces (or any remote environment), Minikube's
# node IP is not directly reachable. This script uses kubectl
# port-forward to make the app accessible on localhost:8080.
#
# Codespaces will automatically detect the forwarded port and
# offer to open it in your browser.
# ──────────────────────────────────────────────────────────────────
set -e

PORT=${1:-8080}

echo "🔗 Forwarding explorer-app-service → http://localhost:${PORT}"
echo "   Press Ctrl+C to stop."
echo ""

if [ -n "$CODESPACES" ]; then
  echo "   📌 Codespaces detected — check the Ports tab or the pop-up"
  echo "      notification to open the app in your browser."
  echo ""
fi

kubectl port-forward -n explorer-lab svc/explorer-app-service "${PORT}:80"
