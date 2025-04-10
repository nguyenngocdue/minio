git reset --hard
chmod +x setup-minio-nginx.sh

git pull
#!/bin/bash
DOMAIN="minio.deepbim.net"
MINIO_PORT_UI=9000
MINIO_PORT_CONSOLE=9001

echo " =========================================="
echo "🧼 Cleaning old configs (if any)..."
sudo rm -f /etc/nginx/sites-available/minio.deepbim.net
sudo rm -f /etc/nginx/sites-enabled/minio.deepbim.net

echo " =========================================="

echo "🔧 Creating NGINX config for MinIO..."

cat <<EOF | sudo tee /etc/nginx/sites-available/minio.deepbim.net
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:$MINIO_PORT_UI;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /console/ {
        proxy_pass http://localhost:$MINIO_PORT_CONSOLE/;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        rewrite ^/console/(.*) /\$1 break;
    }
}
EOF

echo "📌 Enabling config..."
sudo ln -sf /etc/nginx/sites-available/minio.deepbim.net /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
echo " =========================================="


echo "🔐 Installing Certbot SSL..."
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m duengocnguyen@gmail.com

echo " =========================================="
echo "✅ DONE! You can now access:"
echo "👉 https://$DOMAIN"
echo "👉 https://$DOMAIN/console"
