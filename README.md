## Install:

### Check port 88
```sh
lsof -t -i :88
```

### Run 
``` bash
./install.sh
```

### Add trusted domains

 - Go to container "app-server"
```bash
 vi config/config.php 
 ```
 - add your ip to trusted_domains
 - restart the container

### Run index file into elasticsearch

```bash
docker exec -u www-data app-server php /var/www/html/occ fulltextsearch:index
```