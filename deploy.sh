echo " =========================================="
echo "git pull"
git pull

echo " =========================================="
docker compose down
docker compose up -d
