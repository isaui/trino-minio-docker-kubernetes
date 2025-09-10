Catatan Deployment

1. Buat Secret/ConfigMap dari .env.
    secret trino-password-db untuk load password admin trino
    secret minio-cred berisi credential minio
    secret metastore-db berisi credential postgres
    configmap data-lake-config berisi info variable postgres dan minio (termasuk METASTORE_PORT dan METASTORE_STAGING_PORT)
    secret trino-auth untuk seed-ddl berisi autentikasi trino
    atau semuanya bisa dijadikan satu secret biar ga repot. 

2. (Opsional) Init schema HMS → Job hive-metastore-init.
kubectl apply -f hive-metastore-init.yaml

3. Deploy HMS (Deployment+Service) - Both production and staging.
kubectl apply -f hive-metastore-deploy.yaml

4. Run Trino initialization job.
kubectl apply -f trino-init.yaml

5. Upgrade Trino Helm → pasang catalog Hive & env MinIO.
helm upgrade trino-cluster trino/trino -n dtd-datavisualization -f values-trino.yaml

6. Jalankan Job trino-ddl-seed (akan menunggu semua service siap).
kubectl apply -f trino-ddl-seed.yaml

7. Verifikasi query di Trino.

untuk restart deployment:
kubectl -n dtd-datavisualization rollout restart deploy/trino-cluster-trino-cluster-trino
kubectl -n dtd-datavisualization rollout status deploy/trino-cluster-trino-cluster-trino
kubectl -n dtd-datavisualization rollout restart deploy/hive-metastore
kubectl -n dtd-datavisualization rollout restart deploy/hive-metastore-staging

Note: Both production and staging Hive Metastore services are deployed simultaneously.
- Production metastore: hive-metastore:9083
- Staging metastore: hive-metastore-staging:9084 (mapped to internal port 9083)
- Trino has access to both catalogs: 'hive' (production) and 'hive_staging'
