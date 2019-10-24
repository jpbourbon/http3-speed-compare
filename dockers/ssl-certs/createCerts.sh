
docker volume create --name mkcert-data
docker run -d -e domain=msa.jpbourbon-httpspeed.io,msb.jpbourbon-httpspeed.io,msc.jpbourbon-httpspeed.io,msd.jpbourbon-httpspeed.io --name mkcert -v mkcert-data:/root/.local/share/mkcert vishnunair/docker-mkcert
