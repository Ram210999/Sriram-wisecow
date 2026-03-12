# Wisecow Application – Kubernetes CI/CD Deployment with TLS

![CI](https://github.com/Ram210999/Sriram-wisecow/actions/workflows/wc.yml/badge.svg)

## Project Overview

This project demonstrates containerization, Kubernetes deployment, CI/CD automation, and monitoring for the **Wisecow web application**.

The assignment consists of two main parts:

### Problem 1
Containerize the Wisecow application, deploy it on Kubernetes, and automate the deployment using CI/CD with secure TLS communication.

### Problem 2
Develop scripts for system monitoring and application health checking.

---

# Technologies Used

- Docker
- Kubernetes
- Minikube
- NGINX Ingress Controller
- GitHub Actions
- Bash
- Python
- OpenSSL

---

# Project Structure

```
.
├── Dockerfile
├── wisecow.sh
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── problem-2
│   ├── SHM.sh
│   └── AHC.py
├── .github
│   └── workflows
│       └── wc.yml
└── README.md
```

---

# Problem 1 – Wisecow Deployment with TLS

## Docker Containerization

Build Docker image:

```
docker build -t srirammanyam/wisecow:latest .
```

Push image to DockerHub:

```
docker push srirammanyam/wisecow:latest
```

---

## Kubernetes Deployment

Deploy the application:

```
kubectl apply -f k8s/
```

Verify pods:

```
kubectl get pods
```

Verify services:

```
kubectl get svc
```

Verify ingress:

```
kubectl get ingress
```

---

## TLS Configuration

Secure HTTPS communication is configured using **NGINX Ingress** and a **self-signed TLS certificate**.

Generate TLS certificate:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout tls.key \
-out tls.crt \
-subj "/CN=wisecow.local/O=wisecow"
```

Create Kubernetes TLS secret:

```
kubectl create secret tls wisecow-tls --cert=tls.crt --key=tls.key
```

---

## HTTPS Verification

The application endpoint is verified using:

```
curl -k https://wisecow.local
```

Example output:

```
<pre>
 ______________________
< Some fortune message >
 ----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
</pre>
```

---

# CI/CD Pipeline

The CI/CD pipeline is implemented using **GitHub Actions**.

Pipeline file:

```
.github/workflows/wc.yml
```

Pipeline steps:

1. Checkout source code
2. Build Docker image
3. Push image to DockerHub
4. Start Minikube cluster
5. Enable NGINX Ingress controller
6. Generate TLS certificate
7. Deploy Kubernetes manifests
8. Verify HTTPS endpoint

The pipeline automatically runs on every push to the **main branch**.

---

# Local Testing Instructions

Start Minikube cluster:

```
minikube start
```

Enable ingress controller:

```
minikube addons enable ingress
```

Deploy the application:

```
kubectl apply -f k8s/
```

Get Minikube IP:

```
minikube ip
```

Add entry in hosts file:

```
<MINIKUBE-IP> wisecow.local
```

Access the application:

```
https://wisecow.local
```

---

# Problem 2 – Monitoring Scripts

This section contains scripts developed to monitor **system health** and **application availability**.

Directory structure:

```
problem-2
 ├── SHM.sh
 └── AHC.py
```

---

## 1. System Health Monitoring Script

File:

```
SHM.sh
```

Language:

```
Bash
```

### Objective

This script monitors the health of a Linux system by checking the following metrics:

- CPU usage
- Memory usage
- Disk usage
- Running processes

### Threshold Conditions

The script generates alerts if any metric exceeds predefined thresholds.

Example thresholds:

```
CPU Usage > 80%
Memory Usage > 80%
Disk Usage > 80%
```

### Example Alert Output

```
ALERT: CPU usage exceeded 80%
ALERT: Memory usage exceeded 80%
```

### Run the Script

```
bash SHM.sh
```

---

## 2. Application Health Checker

File:

```
AHC.py
```

Language:

```
Python
```

### Objective

This script checks the **uptime and availability of the application** by verifying its HTTP response status code.

### How It Works

The script sends an HTTP request to the application and evaluates the returned status code.

Application status logic:

```
HTTP 200 → Application is UP
Other Status Codes / No Response → Application is DOWN
```

### Example Output

If the application is running:

```
Application Status: UP
HTTP Status Code: 200
```

If the application is unavailable:

```
Application Status: DOWN
Application is not responding
```

### Run the Script

```
python3 AHC.py
```

---

# Assignment Components

Problem 1:
- Containerization using Docker
- Kubernetes deployment
- CI/CD automation
- Secure TLS communication

Problem 2:
- System health monitoring script
- Application health checker script

---

