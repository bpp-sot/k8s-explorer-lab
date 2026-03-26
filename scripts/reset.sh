#!/bin/bash
# ──────────────────────────────────────────────────────────────────
# reset.sh — Tear down everything and start fresh
# ──────────────────────────────────────────────────────────────────
set -e

echo "🧹 Deleting explorer-lab namespace (and everything in it)..."
kubectl delete namespace explorer-lab --ignore-not-found

echo ""
echo "🏗️  Recreating clean namespace..."
kubectl apply -f k8s/base/namespace.yaml

echo ""
echo "✅ Reset complete. Run 'bash scripts/deploy.sh' to redeploy."
