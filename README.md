# 🚀 Kubernetes Explorer Lab

**BPP University School of Technology — Level 7 Software Engineering, DevOps Module, Topic 7: Orchestrating with Kubernetes**

A hands-on lab environment for exploring Kubernetes orchestration concepts using a devcontainer with Minikube. No cloud accounts or credit cards required — everything runs locally inside your development container.

---

## 📋 Learning Outcomes

By working through this lab, you will be able to:

1. **Discuss how Kubernetes operates containerised applications** — by deploying, scaling, and updating a real application on a local cluster.
2. **Explain how applications and metrics could be monitored in Kubernetes** — by using `kubectl`, the metrics-server, and the Kubernetes dashboard.
3. **Create a CI/CD pipeline for Kubernetes** — by understanding the declarative manifests that a pipeline would apply.

---

## 🛠️ Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the **Dev Containers** extension installed
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) running on your machine
- ~4 GB of free RAM (Minikube needs 2 GB inside the container)

> **GitHub Codespaces users:** This lab also works in Codespaces (4-core machine type recommended). Push this repo to GitHub and open it in a Codespace.

---

## 🚀 Getting Started

### 1. Open in a Dev Container

1. Clone or download this repository
2. Open the folder in VS Code
3. When prompted, click **"Reopen in Container"** (or run the command `Dev Containers: Reopen in Container` from the Command Palette)
4. Wait for the container to build and the post-create script to finish — this will:
   - Start a Minikube cluster
   - Install npm dependencies
   - Build the app's Docker image inside Minikube

### 2. Deploy the Application

Once the environment is ready, open a terminal and run:

```bash
bash scripts/deploy.sh
```

This creates a `explorer-lab` namespace and deploys the app with a single replica.

### 3. Access the Application

```bash
# Get the URL for the app
minikube service explorer-app-service -n explorer-lab --url

# Or use curl directly
curl $(minikube service explorer-app-service -n explorer-lab --url)
```

Open the URL in your browser to see the app showing its pod hostname, version, and request count.

---

## 📂 Repository Structure

```
k8s-explorer-lab/
├── .devcontainer/
│   ├── devcontainer.json      # Dev container config (Minikube, kubectl, Docker)
│   └── post-create.sh         # Automatic setup script
├── app/
│   ├── server.js              # Express.js app showing pod metadata
│   ├── Dockerfile             # Multi-stage production build
│   ├── package.json
│   └── test/
│       └── app.test.js
├── k8s/
│   ├── base/                  # Core manifests
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── exercises/             # Progressive exercise manifests
│       ├── 01-scaling.yaml
│       ├── 02-rolling-update.yaml
│       ├── 03-config-and-secrets.yaml
│       ├── 04-self-healing.yaml
│       └── 05-monitoring.yaml
├── scripts/
│   ├── deploy.sh              # Deploy the base app
│   ├── reset.sh               # Tear down and start fresh
│   └── enable-monitoring.sh   # Enable metrics + dashboard
└── README.md
```

---

## 🧪 Exercises

Work through these exercises in order. Each builds on the previous one, and each exercise file contains detailed instructions and reflection questions.

> **💡 Tip:** Before each exercise, read the comments at the top of the YAML file — they explain what to do and what to observe.

### Exercise 1 — Scaling and Load Balancing

**Concepts:** Replicas, horizontal scaling, service-based load balancing

Scale the application from 1 to 3 replicas and observe how Kubernetes distributes incoming traffic across all running pods.

```bash
kubectl apply -f k8s/exercises/01-scaling.yaml
kubectl get pods -n explorer-lab -w
```

Repeatedly curl the app and watch the `hostname` field change — each unique hostname is a different pod handling your request.

---

### Exercise 2 — Rolling Updates and Rollbacks

**Concepts:** Deployment strategies, zero-downtime updates, rollout history

Trigger a rolling update that changes the app version from 1.0.0 to 2.0.0, then roll it back.

```bash
kubectl apply -f k8s/exercises/02-rolling-update.yaml
kubectl rollout status deployment/explorer-app -n explorer-lab
```

Watch pods being replaced one at a time while the service continues responding — this is zero-downtime deployment in action.

---

### Exercise 3 — ConfigMaps and Secrets

**Concepts:** Configuration externalisation, the Twelve-Factor App, secret management

Inject configuration and secrets into pods without rebuilding the Docker image.

```bash
kubectl apply -f k8s/exercises/03-config-and-secrets.yaml
kubectl exec -n explorer-lab deploy/explorer-app -- env | grep -E 'APP_|DB_|API_|LOG_|NODE_'
```

Explore how Kubernetes separates configuration from code — a fundamental principle for cloud-native applications.

---

### Exercise 4 — Self-Healing and Resilience

**Concepts:** Desired state reconciliation, pod restarts vs replacements, CrashLoopBackOff

Deliberately break things and watch Kubernetes recover automatically.

```bash
# Delete a pod and watch it get replaced
kubectl delete pod -n explorer-lab $(kubectl get pods -n explorer-lab -o jsonpath='{.items[0].metadata.name}')
kubectl get pods -n explorer-lab -w
```

This exercise is command-driven rather than manifest-driven — open `k8s/exercises/04-self-healing.yaml` and follow the experiments described in the comments.

---

### Exercise 5 — Monitoring and Observability

**Concepts:** Metrics, logging, dashboards, the difference between monitoring and observability

```bash
bash scripts/enable-monitoring.sh
kubectl top pods -n explorer-lab
minikube dashboard --url
```

Explore built-in monitoring capabilities and discuss what additional tooling (Prometheus, Grafana, ELK) would be needed in production.

---

## 🔄 Resetting the Lab

To tear everything down and start fresh at any point:

```bash
bash scripts/reset.sh
```

This deletes the `explorer-lab` namespace and everything inside it, then recreates a clean namespace ready for redeployment.

---

## 📝 Useful kubectl Commands Reference

| Command | Purpose |
|---------|---------|
| `kubectl get pods -n explorer-lab` | List running pods |
| `kubectl get pods -n explorer-lab -w` | Watch pods in real time |
| `kubectl get all -n explorer-lab` | List all resources in namespace |
| `kubectl describe pod <name> -n explorer-lab` | Detailed pod information |
| `kubectl logs -n explorer-lab -l app=explorer-app` | View application logs |
| `kubectl logs -f -n explorer-lab -l app=explorer-app` | Stream logs live |
| `kubectl exec -it deploy/explorer-app -n explorer-lab -- sh` | Shell into a container |
| `kubectl get events -n explorer-lab --sort-by='.lastTimestamp'` | View recent events |
| `kubectl top pods -n explorer-lab` | Resource usage (needs metrics-server) |
| `kubectl rollout history deployment/explorer-app -n explorer-lab` | Deployment history |
| `kubectl rollout undo deployment/explorer-app -n explorer-lab` | Rollback last change |
| `kubectl scale deployment explorer-app -n explorer-lab --replicas=N` | Scale imperatively |

---

## 🤔 Discussion Points for the Session

These questions are designed to connect the hands-on exercises to broader workplace practice:

1. **Declarative vs Imperative:** You used both `kubectl apply -f` (declarative) and `kubectl scale` (imperative). Which approach is more appropriate for production, and why?

2. **State Reconciliation:** How does Kubernetes' "desired state vs actual state" model compare to traditional server management in your workplace?

3. **Monitoring Gaps:** The built-in tools (`kubectl top`, events, logs) are useful but limited. What monitoring and observability tools does your organisation use, and what gaps would remain if you only had kubectl?

4. **Security Considerations:** You saw that Kubernetes Secrets are only base64-encoded, not encrypted. What additional measures would you recommend for managing secrets in a production cluster?

5. **Scaling Decisions:** When would you choose horizontal scaling (more pods) vs vertical scaling (bigger pods)? What factors from your own projects influence that decision?

---

## 📚 Further Reading

- [Kubernetes Official Documentation](https://kubernetes.io/docs/home/)
- [The Twelve-Factor App](https://12factor.net/) — particularly relevant to Exercises 3 and 4
- [Kubernetes Patterns](https://k8spatterns.io/) — Bilgin Ibryam and Roland Huß
- [Site Reliability Engineering (Google)](https://sre.google/sre-book/table-of-contents/) — monitoring and observability chapters

---

## ⚖️ Licence

This lab is provided for educational use as part of the BPP University School of Technology Level 7 Software Engineering, DevOps module.
