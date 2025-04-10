~/minio/
├── docker-compose.yaml
├── nginx.conf
├── ssl/
│   ├── cert.pem         <- SSL cert (Let's Encrypt/self-signed)
│   └── key.pem

Cấp chứng chỉ SSL

sudo apt install certbot
sudo systemctl stop docker
sudo certbot certonly --standalone -d minio.deepbim.net

sudo cp /etc/letsencrypt/live/minio.deepbim.net/fullchain.pem ~/minio/ssl/cert.pem
sudo cp /etc/letsencrypt/live/minio.deepbim.net/privkey.pem ~/minio/ssl/key.pem
