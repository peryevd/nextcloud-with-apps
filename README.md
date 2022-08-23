### Install

  - docker-compose up
### Set configuration

  - run ```./set_configuration.sh```
##### Trusted domains
  
  - go to container "app-server", open "config/config.php" and add your ip to trusted_domains (172.22.115.221), restart the container
##### Install apps

  - go to nextcloud, apps, and install "ONLYOFFICE" and "Full text search", "Full text search - Elasticsearch Platform", "Full text search - Files"
##### Settings ONLYOFFICE

  - go to settings - ONLYOFFICE, enter "http://ip/" in address

##### Settings ELASTICSEARCH

  - go to settings - Full text search, enter platform Elasticsearch, enter addres servlet - http://elasticsearch_nc:9200
  - enter index: my_index  
  - run ```sudo docker exec -u www-data app-server php /var/www/html/occ fulltextsearch:index```


##### Change db type
```sudo docker exec -u www-data container-name php occ db:convert-type --all-apps --password="pass" db_type username ip dbname ```
##### Example

```sudo docker exec -u www-data app-server php occ db:convert-type --all-apps --password="nextcloud" mysql nextcloud 192.168.96.6 nextcloud```
