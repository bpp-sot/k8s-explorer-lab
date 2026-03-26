#!/bin/bash
# ──────────────────────────────────────────────────────────────────
# deploy.sh — Deploy the base application to the Minikube cluster
# ──────────────────────────────────────────────────────────────────
set -e

echo "🏗️  Creating namespace..."
kubectl apply -f k8s/base/namespace.yaml

echo "🚀 Deploying application..."
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/base/service.yaml

echo ""
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/explorer-app -n explorer-lab --timeout=120s

echo ""
echo "✅ Deployment complete!"
echo ""
kubectl get all -n explorer-lab
echo ""

# Detect environment and show the right access instructions
if [ -n "$CODESPACES" ]; then
  echo "🌐 Running in GitHub Codespaces — use port-forward to access the app:"
  echo ""
  echo "   kubectl port-forward -n explorer-lab svc/explorer-app-service 8080:80"
  echo ""
  echo "   Codespaces will detect port 8080 and offer to open it in your browser."
  echo "   Or in a second terminal:  curl http://localhost:8080"
  echo ""
  echo "   💡 Shortcut:  bash scripts/port-forward.sh"
else
  SERVICE_URL=$(minikube service explorer-app-service -n explorer-lab --url 2>/dev/null || echo "")
  if [ -n "$SERVICE_URL" ]; then
    echo "🌐 App available at: $SERVICE_URL"
    echo "   Try:  curl $SERVICE_URL"
  else
    echo "🌐 To access the app, run:"
    echo "   kubectl port-forward -n explorer-lab svc/explorer-app-service 8080:80"
    echo "   Then visit:  http://localhost:8080"
  fi
fi
