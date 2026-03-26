#!/bin/bash
# ──────────────────────────────────────────────────────────────────
# enable-monitoring.sh
# Enables Minikube addons for monitoring exercises
# ──────────────────────────────────────────────────────────────────
set -e

echo "📊 Enabling metrics-server..."
minikube addons enable metrics-server

echo ""
echo "📈 Enabling dashboard..."
minikube addons enable dashboard

echo ""
echo "⏳ Waiting 60 seconds for metrics to start collecting..."
sleep 60

echo ""
echo "✅ Monitoring addons enabled. Try:"
echo "   kubectl top nodes"
echo "   kubectl top pods -n explorer-lab"
echo "   minikube dashboard --url"
