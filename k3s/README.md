# Trino + Hive Metastore Deployment di Kubernetes

Panduan step-by-step untuk deploy Trino cluster dengan dual Hive Metastore (production + staging) di K3s/Kubernetes.

## 📋 Architecture Overview

Berdasarkan `docker-compose.yml`, arsitektur terdiri dari:
- **Trino**: Main query engine dengan dual catalog (dtd_dw + dtd_dw_staging)  
- **Hive Metastore**: Production metastore (port 9083)
- **Hive Metastore Staging**: Staging metastore (port 9084)
- **PostgreSQL**: Backend database untuk metastores
- **DDL Seed Job**: Schema initialization job
- **MinIO**: S3-compatible object storage (external)

## 🛠️ Prerequisites

### 1. Setup Local Registry
```bash
# Start local Docker registry untuk custom images
docker run -d -p 5000:5000 --name registry registry:2
```

### 2. Build dan Push Custom Images
```bash
cd k3s/
chmod +x build-and-push-images.sh
./build-and-push-images.sh
```

Ini akan build dan push:
- `localhost:5000/trino-ddl-seed:latest` (dari `Dockerfile.seed`)
- `localhost:5000/hive-metastore:latest` (dari `Dockerfile.hivemetastore`)

### 3. Setup Helm Repository
```bash
helm repo add trino https://trinodb.github.io/charts
helm repo update
```

### 4. Create Namespace
```bash
kubectl create namespace dtd-datavisualization
kubectl config set-context --current --namespace=dtd-datavisualization
```

## 🚀 Deployment Steps

### Step 1: Create Secrets dan ConfigMaps

Copy dan customize secrets configuration:

```bash
# Copy example files
cp secrets.example.yaml secrets.yaml

# Edit secrets.yaml - update password placeholders dengan values sebenarnya:
# - your-admin-password → actual Trino admin password  
# - hivepassword → actual PostgreSQL password untuk user hive
# - minioadmin/minioadmin123 → actual MinIO credentials (jika berbeda)
```

Copy dan customize ConfigMap:

```bash
# Copy ConfigMap example
cp datalake-config.example.yaml datalake-config.yaml

# Edit datalake-config.yaml - update MinIO endpoint dan PostgreSQL host sesuai environment
```

Apply secrets dan configmap:

```bash
kubectl apply -f secrets.yaml
kubectl apply -f datalake-config.yaml
```

### Step 2: Deploy PostgreSQL Database

Deploy PostgreSQL dengan 2 databases (metastore + metastore_staging):

```bash
kubectl apply -f postgres-deploy.yaml

# Wait untuk PostgreSQL ready
kubectl wait --for=condition=available deployment/postgres --timeout=300s
```

### Step 3: Initialize Hive Metastore Schema (Optional)

Jika PostgreSQL belum ada schema metastore:

```bash
kubectl apply -f hive-metastore-init.yaml
kubectl wait --for=condition=complete job/hive-metastore-init --timeout=300s
```

### Step 4: Deploy Hive Metastores

Deploy both production dan staging metastores:

```bash
kubectl apply -f hive-metastore-deploy.yaml

# Wait untuk metastores ready
kubectl wait --for=condition=available deployment/hive-metastore --timeout=300s
kubectl wait --for=condition=available deployment/hive-metastore-staging --timeout=300s
```

### Step 5: Configure Trino Values

Copy dan edit values file:

```bash
cp values-trino.example.yaml values-trino.yaml
# Edit values-trino.yaml sesuai environment Anda
```

Key configurations di `values-trino.yaml`:
- **Catalogs**: `dtd_dw` (production) dan `dtd_dw_staging`
- **Environment variables**: MinIO credentials, metastore endpoints
- **Authentication**: Password-based auth

### Step 6: Deploy Trino Cluster

```bash
# Install Trino dengan Helm
helm install trino-cluster trino/trino -f values-trino.yaml

# Wait untuk Trino ready  
kubectl wait --for=condition=available deployment/trino-cluster-trino-coordinator --timeout=600s
kubectl wait --for=condition=available deployment/trino-cluster-trino-worker --timeout=600s
```

### Step 7: Seed DDL Schemas

Jalankan job untuk create schemas dan tables:

```bash
kubectl apply -f trino-ddl-seed.yaml

# Monitor job progress
kubectl logs -f job/trino-ddl-seed
kubectl wait --for=condition=complete job/trino-ddl-seed --timeout=600s
```

### Step 8: Verification

```bash
# Check all pods running
kubectl get pods

# Port forward ke Trino UI
kubectl port-forward svc/trino-cluster-trino 8080:8080

# Access Trino Web UI
# http://localhost:8080 (admin/your-admin-password)

# Test query via CLI
kubectl exec -it deployment/trino-cluster-trino-coordinator -- trino --server localhost:8080 --user admin

# Sample queries:
# SHOW CATALOGS;
# SHOW SCHEMAS FROM dtd_dw;
# SHOW SCHEMAS FROM dtd_dw_staging;
```

## 🔄 Management Commands

### Restart Deployments
```bash
# Restart Trino cluster
kubectl rollout restart deployment/trino-cluster-trino-coordinator
kubectl rollout restart deployment/trino-cluster-trino-worker

# Restart metastores
kubectl rollout restart deployment/hive-metastore
kubectl rollout restart deployment/hive-metastore-staging

# Check rollout status
kubectl rollout status deployment/trino-cluster-trino-coordinator
kubectl rollout status deployment/hive-metastore
kubectl rollout status deployment/hive-metastore-staging
```

### Upgrade Trino
```bash
# Update Helm chart
helm repo update
helm upgrade trino-cluster trino/trino -f values-trino.yaml
```

### Logs dan Debugging
```bash
# Trino coordinator logs
kubectl logs -f deployment/trino-cluster-trino-coordinator

# Metastore logs
kubectl logs -f deployment/hive-metastore
kubectl logs -f deployment/hive-metastore-staging

# DDL seed job logs
kubectl logs job/trino-ddl-seed
```

## 📊 Service Endpoints

- **Trino Coordinator**: `trino-cluster-trino:8080`
- **Production Metastore**: `hive-metastore:9083`  
- **Staging Metastore**: `hive-metastore-staging:9084`
- **PostgreSQL**: `postgres:5432`

## 🗂️ Catalog Configuration

Trino memiliki akses ke dual catalogs:
- **`dtd_dw`**: Production catalog → `hive-metastore:9083`
- **`dtd_dw_staging`**: Staging catalog → `hive-metastore-staging:9084`

Kedua catalog connect ke MinIO S3 storage yang sama tapi bisa pakai prefix/bucket berbeda untuk isolation.

## ⚠️ Troubleshooting

### Common Issues:

1. **Metastore Connection Error**:
   ```bash
   # Check metastore pod logs
   kubectl logs deployment/hive-metastore
   # Verify PostgreSQL connectivity
   kubectl exec -it deployment/hive-metastore -- nc -zv postgres 5432
   ```

2. **Trino Catalog Error**:
   ```bash
   # Check Trino coordinator logs
   kubectl logs deployment/trino-cluster-trino-coordinator
   # Verify metastore connectivity  
   kubectl exec -it deployment/trino-cluster-trino-coordinator -- nc -zv hive-metastore 9083
   ```

3. **DDL Seed Job Failed**:
   ```bash
   # Check job logs
   kubectl logs job/trino-ddl-seed
   # Delete dan retry job
   kubectl delete job/trino-ddl-seed
   kubectl apply -f trino-ddl-seed.yaml
   ```

4. **Image Pull Errors**:
   ```bash
   # Verify local registry
   curl http://localhost:5000/v2/_catalog
   # Re-run build script
   ./build-and-push-images.sh
   ```
