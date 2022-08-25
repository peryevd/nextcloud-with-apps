### Install

  - docker-compose up
  - run ```./set_configuration.sh```
  - go to container "app-server",
  - open "config/config.php" and add your ip to trusted_domains (172.22.115.221)
  - run ```apt-get install smbclient```
  - restart the container
  - go to nextcloud, apps, and install "ONLYOFFICE" and "Full text search", "Full text search - Elasticsearch Platform", "Full text search - Files"
  - go to settings - ONLYOFFICE, enter "http://ip/" in address
  - go to settings - Full text search, enter platform Elasticsearch, enter addres servlet - http://elasticsearch_nc:9200
  - enter index: my_index  
  - run ```sudo docker exec -u www-data app-server php /var/www/html/occ fulltextsearch:index```
 
### Convert db type
```sudo docker exec -u www-data app-server php occ db:convert-type --all-apps --password="nextcloud" mysql nextcloud 192.168.96.6 nextcloud```
