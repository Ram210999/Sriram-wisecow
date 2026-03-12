# Wisecow Application – Kubernetes CI/CD Deployment with TLS

## Project Overview
This project demonstrates containerization, Kubernetes deployment, and CI/CD automation for the Wisecow web application.

---

## Technologies Used

- Docker
- Kubernetes
- Minikube
- NGINX Ingress
- GitHub Actions

---

## Project Structure

```
.
├── Dockerfile
├── wisecow.sh
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── .github
    └── workflows
        └── wc.yml
```

---

## Docker Build

```
docker build -t srirammanyam/wisecow:latest .
```

---

## Kubernetes Deployment

```
kubectl apply -f k8s/
```

---

## Verify Pods

```
kubectl get pods
```

---

## Verify Services

```
kubectl get svc
```

---

## Verify Ingress

```
kubectl get ingress
```

---

## HTTPS Test

```
curl -k https://wisecow.local
```

---

## CI/CD Pipeline

The GitHub Actions pipeline performs:

1. Build Docker image  
2. Push image to DockerHub  
3. Start Minikube cluster  
4. Enable ingress controller  
5. Deploy Kubernetes manifests  
6. Configure TLS  
7. Test HTTPS endpoint  

---

