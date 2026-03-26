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

# Get the service URL
SERVICE_URL=$(minikube service explorer-app-service -n explorer-lab --url 2>/dev/null || echo "")
if [ -n "$SERVICE_URL" ]; then
  echo "🌐 App available at: $SERVICE_URL"
  echo "   Try:  curl $SERVICE_URL"
else
  echo "🌐 To access the app, run:"
  echo "   minikube service explorer-app-service -n explorer-lab --url"
fi
