#!/bin/bash

# Script untuk build dan push Docker images ke local registry (localhost:5000)
# Dijalankan dari directory k3s/

set -e  # Exit on any error

# Colors untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Local registry URL
REGISTRY="localhost:5000"

# Image names dan tags
SEED_IMAGE="${REGISTRY}/trino-ddl-seed"
HIVE_METASTORE_IMAGE="${REGISTRY}/hive-metastore"
TAG="latest"

echo -e "${BLUE}=== Building and Pushing Trino Images ===${NC}"
echo -e "${YELLOW}Registry: ${REGISTRY}${NC}"
echo ""

# Pastikan kita di directory k3s
if [[ ! -f "values-trino.example.yaml" ]]; then
    echo -e "${RED}Error: Script harus dijalankan dari directory k3s/${NC}"
    exit 1
fi

# Function untuk build dan push image
build_and_push() {
    local dockerfile=$1
    local image_name=$2
    local context_dir=$3
    
    echo -e "${YELLOW}Building ${image_name}:${TAG}...${NC}"
    docker build -f "$dockerfile" -t "${image_name}:${TAG}" "$context_dir"
    
    echo -e "${YELLOW}Pushing ${image_name}:${TAG}...${NC}"
    docker push "${image_name}:${TAG}"
    
    echo -e "${GREEN}✓ Successfully pushed ${image_name}:${TAG}${NC}"
    echo ""
}

# Cek apakah local registry berjalan
echo -e "${YELLOW}Checking local registry at ${REGISTRY}...${NC}"
if ! curl -s "http://${REGISTRY}/v2/" > /dev/null; then
    echo -e "${RED}Error: Local registry tidak tersedia di ${REGISTRY}${NC}"
    echo -e "${YELLOW}Pastikan local registry berjalan:${NC}"
    echo "  docker run -d -p 5000:5000 --name registry registry:2"
    exit 1
fi
echo -e "${GREEN}✓ Local registry tersedia${NC}"
echo ""

# Build dan push Trino DDL Seed image
echo -e "${BLUE}=== Building Trino DDL Seed Image ===${NC}"
build_and_push "../Dockerfile.seed" "$SEED_IMAGE" ".."

# Build dan push Hive Metastore image  
echo -e "${BLUE}=== Building Hive Metastore Image ===${NC}"
build_and_push "../Dockerfile.hivemetastore" "$HIVE_METASTORE_IMAGE" ".."

# Summary
echo -e "${GREEN}=== BUILD AND PUSH COMPLETED ===${NC}"
echo -e "${GREEN}Images pushed to local registry:${NC}"
echo -e "  • ${SEED_IMAGE}:${TAG}"
echo -e "  • ${HIVE_METASTORE_IMAGE}:${TAG}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Update values-trino.yaml dengan image names yang sesuai"
echo -e "  2. Deploy dengan: helm install trino trino/trino -f values-trino.yaml"
echo ""
echo -e "${BLUE}Untuk cek images di registry:${NC}"
echo -e "  curl http://${REGISTRY}/v2/_catalog"
