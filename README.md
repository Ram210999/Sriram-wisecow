# Wisecow – DevOps Assessment

Small repo that:
- containerizes the original `wisecow.sh` (unchanged),
- deploys it to Kubernetes with TLS on Ingress,
- and includes two utility scripts for system/app health.

---

## Repo layout

```
.
├─ wisecow.sh
├─ Dockerfile
├─ k8s/
│  ├─ deployment.yaml
│  ├─ service.yaml
│  └─ ingress.yaml
├─ problem-2/
│  ├─ SHM.sh      # System Health Monitor (bash)
│  └─ AHC.py      # App Health Checker (python)
└─ .github/workflows/ci-cd.yml
```

---

## Problem 1 — Container + K8s + TLS

### Run locally (Minikube)
Prereqs: Docker, Minikube, kubectl, openssl.

```bash
minikube start --driver=docker
minikube addons enable ingress
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=600s

# self-signed cert + secret (TLS for Ingress)
openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout tls.key -out tls.crt -subj "/CN=wisecow.local/O=wisecow"
kubectl create secret tls wisecow-tls --cert=tls.crt --key=tls.key

# deploy
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl rollout status deploy/wisecow-deployment --timeout=300s

# host entry, then open in browser
echo "$(minikube ip) wisecow.local" | sudo tee -a /etc/hosts
# Browser: https://wisecow.local  (accept the self-signed warning)
```

**Plain HTTP preview (optional):**
```bash
kubectl port-forward svc/wisecow-service 4499:4499
# Browser: http://localhost:4499
```

---

## CI/CD (GitHub Actions)

Workflow: `.github/workflows/ci-cd.yml`

What it does:
- builds and pushes Docker image to Docker Hub,
- starts Minikube on the runner, enables Ingress,
- creates a self-signed TLS secret,
- applies `k8s/*` and waits for rollout,
- curls `https://wisecow.local` (proof in logs).

Secrets required:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

---

## Problem 2 — Utility Scripts

Both scripts are executable. Run from repo root or `problem-2/`.

### 1) System Health Monitor (`SHM.sh`)
Checks CPU, memory, disk, and process count.  
Exit `0` = OK, `2` = threshold breached.

```bash
./problem-2/SHM.sh -c 80 -m 90 -d 90 -p 0 -f /
# sample safe run:
./problem-2/SHM.sh -c 100 -m 100 -d 100 -p 999999 -f /
```

Flags:
- `-c` CPU%  `-m` MEM%  `-d` DISK%  `-p` PROCS(0=off)  `-f` mount path  `-l` logfile

### 2) App Health Checker (`AHC.py`)
GETs one or more URLs and fails on non-2xx/3xx.

```bash
./problem-2/AHC.py https://example.com
./problem-2/AHC.py --insecure https://wisecow.local
```

Flags:
- `-t` timeout (s)  `-r` retries  `--insecure` skip TLS verify (useful for self-signed)

---

## Quick Docker run (no K8s)

```bash
docker run -p 4499:4499 srirammanyam/wisecow:latest
# Browser: http://localhost:4499
```

---

## Notes

- Keep the repo **Public** for review; Docker creds live in **GitHub Secrets**.
- No TLS keys are committed—certs are generated during runs.
