#!/bin/bash
set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🚀 Kubernetes Explorer Lab — Setting Up            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# -------------------------------------------------------------------
# 1. Start Minikube
# -------------------------------------------------------------------
echo "⏳ Starting Minikube (this may take a couple of minutes)..."
minikube start --driver=docker --memory=2048 --cpus=2

echo ""
echo "✅ Minikube is running!"
minikube status

# -------------------------------------------------------------------
# 2. Install the app's npm dependencies
# -------------------------------------------------------------------
echo ""
echo "📦 Installing app dependencies..."
cd /workspaces/k8s-explorer-lab/app
npm install

# -------------------------------------------------------------------
# 3. Build the Docker image inside Minikube's Docker daemon
# -------------------------------------------------------------------
echo ""
echo "🐳 Building the app's Docker image inside Minikube..."
eval $(minikube docker-env)
docker build -t k8s-explorer-app:1.0.0 -f /workspaces/k8s-explorer-lab/app/Dockerfile /workspaces/k8s-explorer-lab/app

# -------------------------------------------------------------------
# 4. Verify everything is ready
# -------------------------------------------------------------------
echo ""
echo "🔍 Verifying cluster..."
kubectl cluster-info
echo ""
kubectl get nodes

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✅  Environment ready! Open README.md to get started.     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
