Catatan Deployment

1. Buat Secret/ConfigMap dari .env.
    secret trino-password-db untuk load password admin trino
    secret minio-cred berisi credential minio
    secret metastore-db berisi credential postgres
    configmap  data-lake-config berisi info variable postgres dan minio
    secret trino-auth untuk seed-ddl berisi autentikasi trino
    atau semuanya bisa dijadikan satu secret biar ga repot. 

2. (Opsional) Init schema HMS → Job hive-metastore-init.
kubectl apply -f hive-metastore-init.yaml

3. Deploy HMS (Deployment+Service).
kubectl apply -f hive-metastore-deploy.yaml

4. Upgrade Trino Helm → pasang catalog Hive & env MinIO.
helm upgrade trino-cluster trino/trino   -n dtd-datavisualization -f values-trino.yaml

5. Jalankan Job trino-ddl-seed.
kubectl apply -f trino-ddl-seed.yaml
6. Verifikasi query di Trino.

untuk restart deployment:
kubectl -n dtd-datavisualization rollout restart deploy/trino-cluster-trino-cluster-trino
kubectl -n dtd-datavisualization rollout status deploy/trino-cluster-trino-cluster-trino
