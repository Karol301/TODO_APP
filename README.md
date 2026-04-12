# 🏗️ Cloud-Native TODO Stack (AWS Edition)

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Argo CD](https://img.shields.io/badge/Argo%20CD-%23ef7b4d.svg?style=for-the-badge&logo=argo&logoColor=white)

Projekt TODO APP zaimplementowany jako mikroserwis, działający w oparciu o model **GitOps** na chmurze AWS. 

---

## 🛠️ Architektura DevOps & Cloud

### 🌐 Infrastruktura na AWS (Terraform)
Całość zasobów jest zarządzana przez Terraform w katalogu `/terraform`:
- **VPC (Virtual Private Cloud):** Dedykowana, odizolowana sieć z podziałem na subnety publiczne (dla ALB) i prywatne (dla worker nodes klastra EKS).
- **AWS EKS (Elastic Kubernetes Service):** Zarządzany klaster Kubernetes, zapewniający wysoką dostępność warstwy kontrolnej.
- **IAM Roles:** Precyzyjne uprawnienia (Least Privilege) dla nodów i serwisów (IRSA).

### ☸️ Orchestracja (Kubernetes)
Aplikacja jest wdrażana na klaster EKS przy użyciu manifestów z katalogu `/k8s`:
- **Deployment:** Zarządza replikami kontenerów i strategią aktualizacji.
- **Service (ClusterIP):** Wewnętrzna komunikacja między podami.
- **Ingress & ALB (AWS Load Balancer Controller):** Wykorzystanie **AWS Application Load Balancer (ALB)** do kierowania ruchu zewnętrznego (L7) do klastra.

### 🔄 GitOps & CI/CD
Proces dostarczania oprogramowania podzielony jest na dwa etapy:

1. **CI (GitHub Actions):** 
   - Budowanie obrazu Docker i wypchnięcie do **Docker HUB** 
   - Aktualizacja tagu obrazu w repozytorium.

2. **CD & GitOps (Argo CD):**
   - **Argo CD** śledzi zmiany w repozytorium Git i automatycznie synchronizuje stan klastra EKS z deklarowaną konfiguracją.
     
---

![Video Project 3](https://github.com/user-attachments/assets/49d631c0-c527-434a-a266-b2e279898be4)


---
**Author:** [Karol301](https://github.com/Karol301)
